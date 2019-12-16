module add32(in1, in2, out);
    // For adding PC+4 with relative address to get branch address
    input [31:0] in1, in2;
    output [31:0] out;

    assign out = in1 + in2;
endmodule