`timescale 1ns / 1ps
module MUX32(select, in0, in1, out);
    // If select == 0, choose in0; otherwise choose in1
    input select;
    input [31:0]in0, in1;
    output [31:0]out;
    reg [31:0]out;

    always @ (*)  begin
        if (select == 1'b0)    out <= in0;
        else    out <= in1; 
    end
endmodule