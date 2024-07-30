module DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,	
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 512;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];

	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)
		if (reset)
			begin
			

			for (i = 0; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
			
			RAM_data[0] <= 6;
			RAM_data[1] <= 0; RAM_data[2] <= 9;RAM_data[3] <= 3;RAM_data[4] <= 6;RAM_data[5] <= -1;RAM_data[6] <= -1;
			RAM_data[33] <= 9;RAM_data[34] <= 0;RAM_data[35] <= -1;RAM_data[36] <= 3;RAM_data[37] <= 4;RAM_data[38] <= 1;
			RAM_data[65] <= 3;RAM_data[66] <= -1;RAM_data[67] <= 0;RAM_data[68] <= 2;RAM_data[69] <= -1;RAM_data[70] <= 5;
			RAM_data[97] <= 6;RAM_data[98] <= 3;RAM_data[99] <= 2;RAM_data[100] <= 0;RAM_data[101] <= 6;RAM_data[102] <= -1;
			RAM_data[129] <= -1;RAM_data[130] <= 4;RAM_data[131] <= -1;RAM_data[132] <= 6;RAM_data[133] <= 0;RAM_data[134] <= 2;
			RAM_data[161] <= -1;RAM_data[162] <= 1;RAM_data[163] <= 5;RAM_data[164] <= -1;RAM_data[165] <= 2;RAM_data[166] <= 0;
			end
		else if (MemWrite)
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
			
endmodule
