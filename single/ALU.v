`timescale 1ns / 1ps
module ALU(clk, ALUcontrol, in1, in2, result, zero);
    input [3:0]ALUcontrol;
    input [31:0]in1;
    input [31:0]in2;
    input clk;
    output [31:0]result;
    output zero;

    reg [31:0]result;
    reg zero;

    always @ (ALUcontrol or in1 or in2) begin
        case (ALUcontrol)
            4'b0000: result <= in1 & in2;   // and
            4'b0001: result <= in1 | in2;   // or 
            4'b0010: result <= in1 + in2;   // add
            4'b0110: result <= in1 - in2;   // sub
            4'b0111: result <= (in1 < in2) ? 1:0;   // sll    
            default: result <= in1 & in2;
        endcase  
    end
    always @ (negedge clk or ALUcontrol or in1 or in2) begin
        if (ALUcontrol == 4'b0110 && result == 0)
            zero <= 1'b1;
        else
            zero <= 1'b0;
    end
endmodule 