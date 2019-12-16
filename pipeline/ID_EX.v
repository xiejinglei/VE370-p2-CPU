`timescale 1ns / 1ps

module ID_EX(clk, IDMemRead, IDMemtoReg, IDMemWrite, IDALUSrc, IDRegWrite, IDRegDst,
    IDALUOp, ID_readData1, ID_readData2, IDImmi, IDRegisterRs, IDRegisterRt, IDRegisterRd, 
    EXReg1, EXReg2, EXImmi, EXRegisterRs, EXRegisterRt, EXRegisterRd, EXMemRead, 
    EXMemtoReg, EXMemWrite, EXALUSrc, EXRegWrite, EXRegDst, EXALUOp);
 
    input clk;
    // Control signals
    input [2:0] IDALUOp;
    input IDMemRead, IDMemtoReg, IDMemWrite, IDALUSrc, IDRegWrite, IDRegDst;

    // data for ALU from ID
    input [31:0] ID_readData1, ID_readData2, IDImmi;

    // For detecting forwarding
    input [4:0] IDRegisterRs, IDRegisterRt, IDRegisterRd;

    // data for ALU in EXE
    output [31:0] EXReg1, EXReg2, EXImmi;

    // For detecting forwarding
    output [4:0] EXRegisterRs, EXRegisterRt, EXRegisterRd;

    // Control signals
    output [2:0] EXALUOp;
    output EXMemRead, EXMemtoReg, EXMemWrite, EXALUSrc, EXRegWrite, EXRegDst;
    

    // Outputs are all registers
    reg [31:0] EXReg1, EXReg2, EXImmi;
    reg [4:0] EXRegisterRs, EXRegisterRt, EXRegisterRd;
    reg [2:0] EXALUOp;
    reg EXMemRead, EXMemtoReg, EXMemWrite, EXALUSrc, EXRegWrite, EXRegDst;

    // Initialize to 0
    initial begin
        EXReg1 <= 32'b0;
        EXReg2 <= 32'b0;
        EXImmi <= 32'b0;
        EXRegisterRs <= 5'b0;
        EXRegisterRt <= 5'b0;
        EXRegisterRd <= 5'b0;
        EXALUOp <= 2'b0;
        EXMemRead <= 1'b0;
        EXMemtoReg <= 1'b0;
        EXMemWrite <= 1'b0;
        EXALUSrc <= 1'b0;
        EXRegWrite <= 1'b0;
        EXRegDst <= 1'b0;
    end

    always @ (posedge clk) begin
        EXReg1 <= ID_readData1;
        EXReg2 <= ID_readData2;
        EXImmi <= IDImmi;
        EXRegisterRs <= IDRegisterRs;
        EXRegisterRt <= IDRegisterRt;
        EXRegisterRd <= IDRegisterRd;
        EXALUOp <= IDALUOp;
        EXMemRead <= IDMemRead;
        EXMemtoReg <= IDMemtoReg;
        EXMemWrite <= IDMemWrite;
        EXALUSrc <= IDALUSrc;
        EXRegWrite <= IDRegWrite;
        EXRegDst <= IDRegDst;
    end

endmodule
