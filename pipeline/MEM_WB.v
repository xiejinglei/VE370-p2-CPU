`timescale 1ns / 1ps

module MEM_WB(clk, MEM_MemtoReg, MEM_RegWrite, MEM_MemRead, MEM_ReadData, MEM_ALUResult,
    MEM_WriteReg, WB_MemtoReg, WB_RegWrite, WB_MemRead, WB_Mem_ReadData, WB_ALUResult,
    WB_WriteReg);

    input clk;
    // Signals related to WB
    input MEM_MemtoReg, MEM_RegWrite, MEM_MemRead;
    input [31:0] MEM_ReadData, MEM_ALUResult; 
    // reg to be write in regFile
    input [4:0] MEM_WriteReg;

    output WB_MemtoReg, WB_RegWrite, WB_MemRead;
    output [31:0] WB_Mem_ReadData, WB_ALUResult;
    // reg to be write in regFile
    output [4:0] WB_WriteReg;

    reg WB_MemtoReg, WB_RegWrite, WB_MemRead;
    reg [31:0] WB_Mem_ReadData, WB_ALUResult;
    reg [4:0] WB_WriteReg;

    always@ (posedge clk) begin
        WB_MemtoReg <= MEM_MemtoReg;
        WB_RegWrite <= MEM_RegWrite;
        WB_MemRead <= MEM_MemRead;
        WB_Mem_ReadData <= MEM_ReadData;
        WB_ALUResult <= MEM_ALUResult;
        WB_WriteReg <= MEM_WriteReg;
    end

endmodule
