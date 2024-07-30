module Device(
	input  reset    , 
	input  clk      , 
	input  MemRead  , 
	input  MemWrite ,
	input  [32 -1:0] MemBus_Address     , 
	input  [32 -1:0] MemBus_Write_Data  , 
	output [32 -1:0] Device_Read_Data
);

	// device registers
	reg [31:0] reg_op;
	reg [31:0] reg_start;
	reg [31:0] reg_ans;

	// -------- Your code below (for question 3) --------
	always @(*)begin
		if(MemWrite)begin 
			if (MemBus_Address == 32'h40000000) reg_op <= MemBus_Write_Data;
			if (MemBus_Address == 32'h40000008) reg_start <= MemBus_Write_Data;
		end
	end

	assign Device_Read_Data = (MemRead & (MemBus_Address == 32'h40000004))? reg_ans : 0;
	
	reg [2:0] cycle;
	reg [31:0] t;

	always @(posedge clk or posedge reset)begin
		if(reset)begin 
			cycle <= 3'b000;
			reg_op <= 32'h00000000;
			reg_start <= 32'h00000000;
			reg_ans <= 32'h00000000;
			t <= 32'h00000000;
		end
		else begin
		if(reg_start == 0) cycle <= 0;
		else 
		begin
			if(cycle == 0)begin
				reg_ans <= 32'h00000001;
				t <= reg_op;
				cycle <= 2;
			end
			else begin
			 if(cycle == 2 | cycle == 3 | cycle == 4)begin
				reg_ans <= reg_ans + t;
				t <= t*reg_op;
				cycle <= cycle + 1;
			end
				if(cycle == 5)begin
					reg_ans <= reg_ans + t;
					reg_start <= 0;
				end
			end
		end
		end
	end


	// -------- Your code above (for question 3) --------

endmodule
