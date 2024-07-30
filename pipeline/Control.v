
module Control(
	input  [6 -1:0] OpCode   ,
	input  [6 -1:0] Funct    ,
	output [2 -1:0] PCSrc    ,
	output Branch            ,
	output RegWrite          ,
	output [2 -1:0] RegDst   ,
	output MemRead           ,
	output MemWrite          ,
	output [2 -1:0] MemtoReg ,
	output ALUSrc1           ,
	output ALUSrc2           ,
	output ExtOp             ,
	output LuOp              ,
	output [4 -1:0] ALUOp	 ,
	output IsJump
);
	
	// Add your code below (for question 2)
	
	// Your code below (for question 1)
	assign PCSrc = ((OpCode == 0)&(Funct == 8))? 2'b10: ((OpCode == 2) | (OpCode == 3))? 2'b01 : 0;
	assign Branch =((OpCode == 4) | (OpCode == 5) | (OpCode == 6'h07)|
					(OpCode == 6'h06)|(OpCode == 6'h01))? 1:0;
	assign RegWrite = (((OpCode == 0)&(Funct == 8)) | (OpCode == 2) |(OpCode == 4)| (OpCode == 5) |
						(OpCode == 6'h07) |(OpCode == 6'h2b))? 0:1;
	assign RegDst = (OpCode == 3)? 2: ((OpCode == 0) | (OpCode == 6'h1c))? 1:0;				//jal 2, Råž?1
	assign MemRead = (OpCode == 6'h23)? 1:0;
	assign MemWrite = (OpCode == 6'h2b)? 1:0;
	assign MemtoReg = (OpCode == 6'h23)? 1: (OpCode == 3)? 2: 0;
	// ALUSrc1: 0 Databus1
	// ALUSrc2: 0 Databus2
	assign ALUSrc1 = (OpCode == 0)&((Funct == 0)| (Funct == 2) |(Funct == 3))? 1:0;
	assign ALUSrc2 = ((OpCode == 4)| (OpCode==5)|(OpCode == 0) | (OpCode == 6'h1c))? 0:1;										// Råž‹å°±ä¸?1
	assign LuOp = (OpCode == 6'hf)? 1:0;
	assign ExtOp = (OpCode == 6'h0c)? 0:1 ;
	assign IsJump = ((OpCode == 6'h02)| (OpCode == 6'h03)| 
						(OpCode == 0 & (Funct == 6'h08 | Funct == 6'h09))	)? 1:0;				// j, jal, jr, jalr 

	// Your code above (for question 1)

	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h0c)? 3'b100: 		
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 

		3'b000;
		
	assign ALUOp[3] = OpCode[0];

	// Add your code above (for question 2)
	
endmodule