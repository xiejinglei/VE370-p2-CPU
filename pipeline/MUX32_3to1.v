`timescale 1ns / 1ps
module MUX32_3to1(select, in00, in01, in10, out);
    // If select == 00, choose in00; 
    // If select == 01, choose in01;
    // If select == 10, choose in10
    input [1:0]select;
    input [31:0]in00, in01, in10;
    output [31:0]out;
    reg [31:0]out;

    always @ (*)  begin
        if (select == 2'b00)    out <= in00;
        else if (select == 2'b01)    out <= in01; 
        else if (select == 2'b10)    out <= in10;
        else    out <= in00;
    end
endmodule