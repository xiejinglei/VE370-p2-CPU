`timescale 1ns / 1ps
module PC_add4(PC_in, PC_out);
    input [31:0] PC_in;
    output [31:0] PC_out;

    assign PC_out = PC_in + 4;
endmodule