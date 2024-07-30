`timescale 1ns / 1ps
module Forwarding_ID(
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire [4:0] Rw_MEM,
    input wire RegWrite_MEM,
    input wire MEM_MemRead,
    input wire [4:0] Rw_WB,
    
    output wire [1:0] BrForwardingA,
    output wire [1:0] BrForwardingB
);

    assign BrForwardingA = (rs == Rw_MEM && RegWrite_MEM && MEM_MemRead == 0) ? 1:         
                           /*(rs == Rw_WB && Load_WB) ? 2 :*/  0;           
    assign BrForwardingB = (rt == Rw_MEM && RegWrite_MEM && MEM_MemRead == 0) ? 1 :
                           /* (rt == Rw_WB && Load_WB) ? 2 :*/ 0;

endmodule