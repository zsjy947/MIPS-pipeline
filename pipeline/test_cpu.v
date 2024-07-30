module test_cpu(
	input	sys_clk,
	input	key1,
	output [12  -1: 0]	BCD_control 
);
	
	// reg reset   ;
	// reg clk     ;

	wire        MemRead             ; 
	wire        MemWrite            ;
	wire [31:0] MemBus_Address      ;
	wire [31:0] MemBus_Write_Data   ;
	wire [31:0] Device_Read_Data    ;
	wire 		clk					;
	wire		reset				;

	debounce de(sys_clk,key1,reset);

	// clk_gen clk_gen1K(
	// 	sys_clk,
	// 	reset,
	// 	clk
	// );
	assign clk = sys_clk;
	
	CPU cpu1(  
		.reset              (reset              ), 
		.sys_clk                (clk                ), 
		.MemBus_Address     (MemBus_Address     ),
		.Device_Read_Data   (Device_Read_Data   ), 
		.MemBus_Write_Data  (MemBus_Write_Data  ), 
		.MemRead            (MemRead            ), 
		.MemWrite           (MemWrite           )
	);


	BCD_Welog bcd1(
		.reset              (reset              ), 
		.clk                (clk                ), 
		.MemBus_Address     (MemBus_Address     ),
		.BCD_control   		(BCD_control	    ), 
		.MemBus_Write_Data  (MemBus_Write_Data  ), 
		.MemRead            (MemRead            ), 
		.MemWrite           (MemWrite           )
	);
	
	
		
endmodule
