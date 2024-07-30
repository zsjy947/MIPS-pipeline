`timescale 1ns/1ps
module Forwarding_EX(
    input wire [4:0] EX_rs,
    input wire [4:0] EX_rt,
    input wire [4:0] MEM_rd,
    input wire [4:0] WB_rd,
    input wire MEM_RegWrite,
    input wire WB_RegWrite,
    input wire MEM_MemRead,

    output wire [1:0] ALUForward1, 
    output wire [1:0] ALUForward2
);

    assign ALUForward1 = (MEM_RegWrite & (EX_rs == MEM_rd) &(MEM_MemRead == 0))? 2:                 // 优先考虑MEM，因为MEM是上�?条， WB是上上条
                         (WB_RegWrite & (EX_rs == WB_rd))? 1:0;

    assign ALUForward2 = (MEM_RegWrite & (EX_rt == MEM_rd) &(MEM_MemRead == 0))? 2:                 // 优先考虑MEM，因为MEM是上�?条， WB是上上条
                         (WB_RegWrite & (EX_rt == WB_rd))? 1:0;


endmodule