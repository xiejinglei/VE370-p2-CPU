`timescale 1ns / 1ps
module PC_reg(PC_in, PCWrite, clk, PC_out);
    // In single cycle, PCWrite is always 1
    // In pipeline, if there should be a nop, PCWrite = 0
    input [31:0] PC_in;
    input PCWrite, clk;
    output [31:0] PC_out;
    
    reg start;
    reg [31:0] PC_out;

    initial begin
        start = 0;
        PC_out = 0;
    end

    always @ (posedge clk) begin
        if (start == 0) begin
            PC_out <= 0;
            start <= 1;
        end
        else if (PCWrite == 1'b1)   PC_out <= PC_in;
        else    PC_out <= PC_out;
    end
endmodule