`timescale 1ns / 1ps

module EX_MEM(clk, EXALUResult, EXMUX2_result, EX_WriteReg, EXMemRead, EXMemtoReg,
    EXMemWrite, EXRegWrite, MEMALUResult, MEMWriteData_orig, MEM_WriteReg, MEMMemRead, 
    MEMMemtoReg, MEMMemWrite, MEMRegWrite);

    input clk;
    input [31:0] EXALUResult, EXMUX2_result;
    // reg to be write in regFile
    input [4:0] EX_WriteReg; 
    // Singals related to WB
    input EXMemRead, EXMemtoReg, EXMemWrite, EXRegWrite;

    output [31:0] MEMALUResult, MEMWriteData_orig;
    // reg to be write in regFile
    output [4:0] MEM_WriteReg; 
    // Signals related to WB
    output MEMMemRead, MEMMemtoReg, MEMMemWrite, MEMRegWrite;

    reg [31:0] MEMALUResult, MEMWriteData_orig;
    reg [4:0] MEM_WriteReg;
    reg MEMMemRead, MEMMemtoReg, MEMMemWrite, MEMRegWrite;

    always @ (posedge clk) begin
        MEMALUResult <= EXALUResult;
        MEMWriteData_orig <= EXMUX2_result;
        MEM_WriteReg <= EX_WriteReg;
        MEMMemRead <= EXMemRead;
        MEMMemtoReg <= EXMemtoReg;
        MEMMemWrite <= EXMemWrite;
        MEMRegWrite <= EXRegWrite;
    end

endmodule
