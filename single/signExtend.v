`timescale 1ns / 1ps
module signExtend(in, out);
    // For I-type sign extend
    input [15:0] in;
    output [31:0] out;
    reg [31:0] out;

    always @ (in)   begin
        out[15:0] <= in[15:0];
        if (in[15] == 1'b0)
            out[31:16] = 16'b0000000000000000;
        else
            out[31:16] = 16'b1111111111111111;
    end
endmodule