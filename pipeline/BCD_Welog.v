module BCD_Welog(
    input  reset    , 
	input  clk      , 
	input  MemRead  , 
	input  MemWrite ,
	input  [32 -1:0] MemBus_Address     , 
	input  [32 -1:0] MemBus_Write_Data  , 
	output reg [12 -1:0] BCD_control
    );

    
    always@(posedge reset or posedge clk)
    begin
        if(reset)begin
            BCD_control <= 32'h0000_0000;
        end
        else
         if (MemWrite & (MemBus_Address == 32'h4000_0010))
             BCD_control <= MemBus_Write_Data[11:0];
        
    end




endmodule
