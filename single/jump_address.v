`timescale 1ns / 1ps
module jump_address(PC_p4, in, out);
    // PC_p4 = PC+4
    // out = PC+4+in*4
    input [31:0] PC_p4;
    input [25:0] in;
    output [31:0] out;

    reg [31:0] out;

    always @ (PC_p4 or in)  begin        
        out[31:28] <= PC_p4[31:28];
        out[27:2] <= in[25:0];
        out[1:0] <= 2'b00;
    end
endmodule