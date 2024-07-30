`timescale 1ns / 1ps
module BranchALU(
    input wire [5:0] OpCode,
    input wire [31:0] data1,
    input wire [31:0] data2,
    input wire Branch,
    output reg Zero
);

    always@(*) begin
        if(Branch) begin
            if(OpCode == 6'h04) begin       // beq
                Zero <= data1  == data2 ;
            end
            else if(OpCode == 6'h05) begin  // bne
                Zero <= data1  != data2 ;
            end
            else if(OpCode == 6'h06) begin  // blez
                Zero <= (data1  <= data2 );
            end
            else if(OpCode == 6'h07) begin  // bgtz
                Zero <= ((data1[31] == 0) & ~(data1 == 0));
            end
            else if(OpCode == 6'h01) begin  // bltz
                Zero <= (data1[31] == 1 );
            end
            else begin
                Zero <= Zero;
            end
        end
        else begin
            Zero <= 0;
        end
    end

endmodule