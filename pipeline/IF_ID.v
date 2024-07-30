`timescale 1ns / 1ps
module IF_ID(
    input wire clk,
    input wire reset,
    input wire flush_IFID,
    input wire stall,
    // flush is more privileged than stall
    input wire [31:0] PC,
    input wire [31:0] Instruction,
    output reg [31:0] IF_ID_Instruction,
    output reg [31:0] ID_PC
);
    
    always @(posedge clk or posedge reset)
    begin
      if(reset)
      begin
            IF_ID_Instruction <= 0;
            ID_PC <= 0;

      end
      else if(flush_IFID)begin
        IF_ID_Instruction <= 0;
        ID_PC <= 0;
      end
      else if(stall)begin
        IF_ID_Instruction <= IF_ID_Instruction;     
        ID_PC <= ID_PC;    
      end
      else begin
        IF_ID_Instruction <= Instruction;
        ID_PC <= PC;
      end
    end


endmodule