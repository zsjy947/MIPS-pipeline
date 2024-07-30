module CPU(
	input  reset                        , 
	input  sys_clk                          , 
	output MemRead                      , 
	output MemWrite                     ,
	output [32 -1:0] MemBus_Address     , 
	output [32 -1:0] MemBus_Write_Data  , 
	input  [32 -1:0] Device_Read_Data 
);
	assign MemRead = MEM_MemRead;
	assign MemWrite = MEM_MemWrite;
	
	wire clk;
	assign clk = sys_clk;

	wire [2 -1:0] ID_RegDst    ;
	wire [2 -1:0] ID_PCSrc     ;
	wire          ID_MemRead   ;
	wire          ID_MemWrite  ;
	wire [2 -1:0] ID_MemtoReg  ;
	wire          ID_ALUSrc1   ;
	wire          ID_ALUSrc2   ;
	wire [4 -1:0] ID_ALUOp     ;
	wire          ID_ExtOp     ;
	wire          ID_LuOp      ;
	wire          ID_RegWrite  ;
	
	wire [32 -1:0] ID_Databus1;
	wire [32 -1:0] ID_Databus2; 
	wire [32 -1:0] WB_Databus3;
	wire [5  -1:0] ID_rd;
	wire [5  -1:0] EX_rd;
	wire [5  -1:0] MEM_rd;
	wire [5  -1:0] WB_rd;

	wire  EX_RegWrite, EX_Branch, EX_MemRead, EX_MemWrite;
    wire  [1:0]  EX_MemtoReg;
	wire	EX_ALUSrc1, EX_ALUSrc2;
	wire  [4:0] EX_ALUCtrl;
	wire [31:0] EX_Databus1;
	wire [31:0] EX_Databus2; 
    wire [31:0]    EX_LU_out;
	wire [4:0] EX_Shamt; 
	wire [4:0] EX_rs;
	wire [4:0]  EX_rt;
	wire EX_Sign;
	wire [31:0] EX_PC;

	wire MEM_MemRead, MEM_MemWrite;
	wire [31:0] MEM_ALU_out;
	wire [1:0] MEM_MemtoReg;
	wire MEM_RegWrite;
	wire [31:0] MEM_Databus2;
	wire [31:0] MEM_PC  ;

	wire WB_RegWrite;
	wire [1:0] WB_MemtoReg;
	wire [31:0] WB_Memory_Read_Data;
	wire [31:0] WB_ALU_out;
	wire [31:0] WB_PC;

	// PC register
	reg  [31 :0] PC;
	wire [31 :0] PC_next;
	wire [31 :0] ID_PC_plus_4;

	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00000000;
		else
			PC <= PC_next;
	

	// IF 
	// Instruction Memory
	wire [31 :0] Instruction;
	InstructionMemory instruction_memory1(
		.Address        (PC             ), 
		.Instruction    (Instruction    )
	);
	
	wire flush_IFID;
	wire stall_IFID;
	wire [31:0] IF_ID_Instruction;

	wire		  ID_IsJump	   ;
	wire          ID_Branch    ;
	wire 	[31:0]	  ID_PC	   ;
	assign flush_IFID = (ID_IsJump | ID_Branch)&(stall_IFID == 0);
	assign stall_IFID = (ID_Branch &&
				 ((  EX_RegWrite && (EX_rd == IF_ID_Instruction[25:21] || EX_rd == IF_ID_Instruction[20:16]) )						// *-beq?
				 || (MEM_MemRead && (MEM_rd == IF_ID_Instruction[25:21] || MEM_rd == IF_ID_Instruction[20:16])))					// lw-*-beq?
				 || (EX_MemRead && (EX_rd == IF_ID_Instruction[25:21] || EX_rd == IF_ID_Instruction[20:16]))						// lw-*		这里没有管lw-sw,lw-lw的优化，都让它stall�?�?
				 )? 1:0;
	IF_ID IFIDreg(
	.clk(clk),
    .reset(reset),
    .flush_IFID(flush_IFID),
    .stall(stall_IFID),
	.PC(PC),
    .Instruction(Instruction),
    .IF_ID_Instruction(IF_ID_Instruction),
	.ID_PC(ID_PC)
	);


	//ID
	// Control 
		
	Control control1(
		.OpCode     (IF_ID_Instruction[31:26] ), 
		.Funct      (IF_ID_Instruction[5 : 0] ),
		.PCSrc      (ID_PCSrc              ), 
		.Branch     (ID_Branch             ), 
		.RegWrite   (ID_RegWrite           ), 
		.RegDst     (ID_RegDst             ), 
		.MemRead    (ID_MemRead            ),	
		.MemWrite   (ID_MemWrite           ), 
		.MemtoReg   (ID_MemtoReg           ),
		.ALUSrc1    (ID_ALUSrc1            ), 
		.ALUSrc2    (ID_ALUSrc2            ), 
		.ExtOp      (ID_ExtOp              ), 
		.LuOp       (ID_LuOp               ),	
		.ALUOp      (ID_ALUOp              ),
		.IsJump		(ID_IsJump)
	);
	
	// ALU Control
	wire [5 -1:0] ID_ALUCtl;
	wire          ID_Sign  ; 

	ALUControl alu_control1(
		.ALUOp  (ID_ALUOp              ), 
		.Funct  (IF_ID_Instruction[5:0]   ), 
		.ALUCtl (ID_ALUCtl             ), 
		.Sign   (ID_Sign               )
	);

	// Register File

	// RegDst: 00rt, 01rd 
	assign ID_rd = (ID_RegDst == 2'b00)? IF_ID_Instruction[20:16]: (ID_RegDst == 2'b01)? IF_ID_Instruction[15:11]: 5'b11111;


	RegisterFile register_file1(
		.reset          (reset              ), 
		.clk            (clk                ),
		.RegWrite       (WB_RegWrite           ), 
		.Read_register1 (IF_ID_Instruction[25:21] ), 
		.Read_register2 (IF_ID_Instruction[20:16] ), 
		.Write_register (WB_rd     ),
		.Write_data     (WB_Databus3           ), 
		.Read_data1     (ID_Databus1           ), 
		.Read_data2     (ID_Databus2           )
	);

	wire Zero				;
	wire [1:0] BrForwardingA;
    wire [1:0] BrForwardingB;
    wire [31:0] BrALUData1;
    wire [31:0] BrALUData2; 

    Forwarding_ID BrForwarding(IF_ID_Instruction[25:21], IF_ID_Instruction[20:16], 
								  MEM_rd, MEM_RegWrite, 
								  MEM_MemRead, WB_rd, BrForwardingA, BrForwardingB);				
	assign BrALUData1 = BrForwardingA == 1 ? MEM_ALU_out : 
                      BrForwardingA == 2 ? WB_Databus3 : ID_Databus1;
    assign BrALUData2 = BrForwardingB == 1 ? MEM_ALU_out : 
                      BrForwardingB == 2 ? WB_Databus3 : ID_Databus2;
	BranchALU BrAlu(IF_ID_Instruction[31:26], BrALUData1, BrALUData2, ID_Branch, Zero);				



	// Extend
	wire [32 -1:0] Ext_out;
	assign Ext_out = { ID_ExtOp? {16{IF_ID_Instruction[15]}}: 16'h0000, IF_ID_Instruction[15:0]};		//1带符号扩展，0无符号扩�?
	
	wire [32 -1:0] ID_LU_out;
	assign ID_LU_out = ID_LuOp? {IF_ID_Instruction[15:0], 16'h0000}: Ext_out;		
	// calculate PC_next, controlled by signal from ID
	assign ID_PC_plus_4 = ID_PC + 32'd4;
	wire [32 -1:0] Jump_target;
	assign Jump_target = {ID_PC_plus_4[31:28], IF_ID_Instruction[25:0], 2'b00};
	wire [32 -1:0] Branch_target;
	assign Branch_target = (ID_Branch & Zero)? ID_PC_plus_4 + {ID_LU_out[29:0], 2'b00}: 
							(ID_Branch)? ID_PC_plus_4: PC + 32'h4;
	// PCSrc: 00branch/PC+4 , 01jump, 10or11jr  
	assign PC_next =
                     stall_IFID ? PC : 
					(ID_PCSrc == 2'b00)? Branch_target: (ID_PCSrc == 2'b01)? Jump_target: ID_Databus1;


	// ID_EX

	wire flush_IDEX ;
	assign flush_IDEX = (ID_Branch &&
				 ((  EX_RegWrite && (EX_rd == IF_ID_Instruction[25:21] || EX_rd == IF_ID_Instruction[20:16]) )						// *-beq?
				 || (MEM_MemRead && (MEM_rd == IF_ID_Instruction[25:21] || MEM_rd == IF_ID_Instruction[20:16])))					// lw-*-beq?
				 || (EX_MemRead && (EX_rd == IF_ID_Instruction[25:21] || EX_rd == IF_ID_Instruction[20:16]))						// lw-*		这里没有管lw-sw,lw-lw的优化，都让它stall�?�?
				 )? 1:0;

	
	ID_EX IDEXReg(
        clk, reset, flush_IDEX, 
		ID_RegWrite, ID_Branch, ID_MemRead, ID_MemWrite, 
        ID_MemtoReg, ID_ALUSrc1, ID_ALUSrc2, ID_ALUCtl, ID_Databus1, ID_Databus2, 
        ID_LU_out, IF_ID_Instruction[10:6], IF_ID_Instruction[25:21], IF_ID_Instruction[20:16], ID_rd, ID_Sign, ID_PC, 
        EX_RegWrite, EX_Branch, EX_MemRead, EX_MemWrite,
        EX_MemtoReg, EX_ALUSrc1, EX_ALUSrc2, EX_ALUCtrl, EX_Databus1, EX_Databus2, 
        EX_LU_out, EX_Shamt, EX_rs, EX_rt, EX_rd, EX_Sign, EX_PC
    );


	// EX
		
	// ALU
	wire [32 -1:0] ALU_in1;
	wire [32 -1:0] ALU_in2;
	wire [32 -1:0] EX_ALU_out;
	wire           nouse_Zero   ;
    wire [1:0] ALUForward1		;
    wire [1:0] ALUForward2		;

	Forwarding_EX ALUForward(
	EX_rs,EX_rt,
    MEM_rd,WB_rd,
    MEM_RegWrite,WB_RegWrite,MEM_MemRead,
	ALUForward1,ALUForward2
	);

	assign ALU_in1 = EX_ALUSrc1? {27'h00000, EX_Shamt}: 
					 (ALUForward1==2)? MEM_ALU_out:
					 (ALUForward1==1)? WB_Databus3:	EX_Databus1;	
	assign ALU_in2 = EX_ALUSrc2? EX_LU_out: 
					 (ALUForward2==2)? MEM_ALU_out:
					 (ALUForward2==1)? WB_Databus3:	EX_Databus2;
	ALU alu1(
		.in1    (ALU_in1), 
		.in2    (ALU_in2), 
		.ALUCtl (EX_ALUCtrl), 
		.Sign   (EX_Sign), 
		.out    (EX_ALU_out), 
		.zero   (nouse_Zero)
	);
		

	// EX_MEM
    

	EX_MEM EXMEMReg(
        clk, reset, 
		EX_MemRead, EX_MemWrite, EX_ALU_out, EX_rd, EX_MemtoReg, EX_RegWrite, EX_Databus2, EX_PC, 
        MEM_MemRead, MEM_MemWrite, MEM_ALU_out, MEM_rd, MEM_MemtoReg, MEM_RegWrite, MEM_Databus2, MEM_PC  
    );//2+8+8

	// MEM	
	// Data Memory
	wire [32 -1:0] Memory_Read_Data ;
	wire           Memory_Read      ;
	wire           Memory_Write     ;
	wire [32 -1:0] MemBus_Read_Data ;

	// Set the signal for peripheral Device
	// -------- Rewrite code below for question 3 --------
	assign Memory_Read          = /*((MemBus_Address == 32'h40000004) )? 0 :*/ MEM_MemRead ;
	assign Memory_Write         = (/*(MemBus_Address == 32'h40000000) |
									(MemBus_Address == 32'h40000008)| */
									(MemBus_Address == 32'h40000010))? 0 : MEM_MemWrite;
	assign MemBus_Address       = MEM_ALU_out ;
	assign MemBus_Write_Data    = MEM_Databus2;
//	assign MemBus_Read_Data     = (MemBus_Address == 32'h40000004)? Device_Read_Data: Memory_Read_Data;
	// -------- Rewrite code above for question 3 --------

	DataMemory data_memory1(
		.reset      (reset              ), 
		.clk        (clk                ), 
		.Address    (MEM_ALU_out     ), 
		.Write_data (MemBus_Write_Data  ), 
		.Read_data  (Memory_Read_Data   ), //输出		//优化
		.MemRead    (MEM_MemRead       ), //使能		//优化
		.MemWrite   (Memory_Write       )	//使能
	);

	// MEM_WB
	
	MEM_WB MEMWBReg(
        clk, reset, 
		MEM_RegWrite, MEM_MemtoReg, MEM_rd, Memory_Read_Data, MEM_ALU_out, MEM_PC, 
        WB_RegWrite, WB_MemtoReg, WB_rd, WB_Memory_Read_Data, WB_ALU_out, WB_PC
    );


	// WB
	// MemtoReg: 00ALU结果�?01Mem读取结果，其他，PC+4（jal使用�?
	assign WB_Databus3 = (WB_MemtoReg == 2'b00)? WB_ALU_out: (WB_MemtoReg == 2'b01)? WB_Memory_Read_Data: WB_PC + 32'd4 ;
	

endmodule
