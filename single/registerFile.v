`timescale 1ns / 1ps
module registerFile(clk, ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, 
    ReadData1, ReadData2, s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9);

    input [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    input [31:0] WriteData;
    input clk, RegWrite;
    output [31:0] ReadData1, ReadData2;
    output [31:0] s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9;

    reg [31:0] regs[0:31];

    // Initialize all the registers to 0
    initial begin
        regs[0] = 32'b00000000000000000000000000000000;
        regs[1] = 32'b00000000000000000000000000000000;
        regs[2] = 32'b00000000000000000000000000000000;
        regs[3] = 32'b00000000000000000000000000000000;
        regs[4] = 32'b00000000000000000000000000000000;
        regs[5] = 32'b00000000000000000000000000000000;
        regs[6] = 32'b00000000000000000000000000000000;
        regs[7] = 32'b00000000000000000000000000000000;
        regs[8] = 32'b00000000000000000000000000000000;
        regs[9] = 32'b00000000000000000000000000000000;
        regs[10] = 32'b00000000000000000000000000000000;
        regs[11] = 32'b00000000000000000000000000000000;
        regs[12] = 32'b00000000000000000000000000000000;
        regs[13] = 32'b00000000000000000000000000000000;
        regs[14] = 32'b00000000000000000000000000000000;
        regs[15] = 32'b00000000000000000000000000000000;
        regs[16] = 32'b00000000000000000000000000000000;
        regs[17] = 32'b00000000000000000000000000000000;
        regs[18] = 32'b00000000000000000000000000000000;
        regs[19] = 32'b00000000000000000000000000000000;
        regs[20] = 32'b00000000000000000000000000000000;
        regs[21] = 32'b00000000000000000000000000000000;
        regs[22] = 32'b00000000000000000000000000000000;
        regs[23] = 32'b00000000000000000000000000000000;
        regs[24] = 32'b00000000000000000000000000000000;
        regs[25] = 32'b00000000000000000000000000000000;
        regs[26] = 32'b00000000000000000000000000000000;
        regs[27] = 32'b00000000000000000000000000000000;
        regs[28] = 32'b00000000000000000000000000000000;
        regs[29] = 32'b00000000000000000000000000000000;
        regs[30] = 32'b00000000000000000000000000000000;
        regs[31] = 32'b00000000000000000000000000000000;
    end

    // Get registers for t and s
    assign t0 = regs[8];
    assign t1 = regs[9];
    assign t2 = regs[10];
    assign t3 = regs[11];
    assign t4 = regs[12];
    assign t5 = regs[13];
    assign t6 = regs[14];
    assign t7 = regs[15];
    assign s0 = regs[16];
    assign s1 = regs[17];
    assign s2 = regs[18];
    assign s3 = regs[19];
    assign s4 = regs[20];
    assign s5 = regs[21];
    assign s6 = regs[22];
    assign s7 = regs[23];  
    assign t8 = regs[24];
    assign t9 = regs[25];  

    // Write data 
    always @ (negedge clk)  begin
        if(RegWrite == 1'b1)    regs[WriteRegister] <= WriteData;
    end

    // Read data (not clock triggered)
    assign ReadData1 = regs[ReadRegister1];
    assign ReadData2 = regs[ReadRegister2];

endmodule