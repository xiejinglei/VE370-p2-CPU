`timescale 1ns / 1ps
module dataMemory(clk, Address, WriteData, MemWrite, MemRead, ReadData);
    input clk, MemWrite, MemRead;
    input [31:0]Address, WriteData;
    output [31:0]ReadData;

    // Suppose the memory is 32 words
    reg [31:0]Memory [0:31];
    reg [31:0]ReadData;

    // Write data
    always @ (posedge clk)  begin
        if (MemWrite == 1'b1)   Memory[Address>>2] <= WriteData;
    end

    // Read data
    always @ (*)  begin
        if (MemRead == 1'b1)    ReadData <= Memory[Address>>2];
    end
endmodule