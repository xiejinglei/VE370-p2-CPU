`timescale 1ns / 1ps
module MUX5(select, in0, in1, out);
    // This is a 5 bit mux for selecting WriteRegister
    // If select == 0, choose in0; otherwise choose in1
    input select;
    input [4:0]in0, in1;
    output [4:0]out;
    reg [4:0]out;

    always @ (*)  begin
        if (select == 1'b0)    out <= in0;
        else    out <= in1; 
    end
endmodule