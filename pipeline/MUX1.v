`timescale 1ns / 1ps
module MUX1(select, in0, in1, out);
    // This is a 1 bit mux for selecting WriteRegister
    // If select == 0, choose in0; otherwise choose in1
    input select;
    input in0, in1;
    output out;
    reg out;

    always @ (*)  begin
        if (select == 1'b0)    out <= in0;
        else    out <= in1; 
    end
endmodule