`timescale 1ns / 1ps
module shiftLeft2_32(in, out);
    // For the branch operation
    input [31:0] in;
    output [31:0] out;

    assign out = in << 2;
endmodule