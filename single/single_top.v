`timescale 1ns / 1ps
// Single cycle CPU implementation
// Xie Jinglei

 module single_top(clk,currentPC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9);
    input clk;
    // 32 bit registers
    output [31:0]currentPC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9;
    
    wire [31:0]nextPC, currentPC, PC_p4, jumpAddr, branchAddr, addr_p4_branch, 
        instruction, extendedImmi, readData1_reg, readData2_reg, shiftedImmi, 
        ALUResult, readData_mem, writeData_reg, ALUInput2;
    wire RegDst, Jump,MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BeqSig, BneSig, 
        zero, branchSelect;
    wire [2:0] ALUOp;
    wire [3:0] ALUSelect;
    wire [4:0] writeRegister;
    parameter PCWrite = 1'b1;
    
    //reg [31:0]PC_display;
    //initial PC_display = 32'b00000000000000000000000000000000;
    //always@ (negedge clk)    begin
    //    PC_display <= nextPC;
    //end
    
    
    PC_reg PC_reg(nextPC, PCWrite, clk, currentPC);
    PC_add4 PC_add4(currentPC, PC_p4);
    instructionMEM instructionMEM(currentPC, instruction);
    MUX5 MUX_regWrite(RegDst, instruction[20:16], instruction[15:11], writeRegister);
    registerFile registerFile(clk, instruction[25:21], instruction[20:16], writeRegister, 
                            writeData_reg, RegWrite, readData1_reg, readData2_reg, s0, s1, 
                            s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9);
    control control(instruction[31:26], RegDst, Jump, BeqSig, BneSig, MemRead, MemtoReg, 
                    ALUOp, MemWrite, ALUSrc, RegWrite);
    jump_address jump_address(PC_p4, instruction[25:0], jumpAddr);
    signExtend signExtend(instruction[15:0], extendedImmi);
    ALUControl ALUControl(instruction[5:0], ALUOp, ALUSelect);
    MUX32 MUX_ALUInput(ALUSrc, readData2_reg, extendedImmi, ALUInput2);
    ALU ALU(clk, ALUSelect, readData1_reg, ALUInput2, ALUResult, zero);
    shiftLeft2_32 shiftLeft2_32(extendedImmi, shiftedImmi);
    add32 add32(PC_p4, shiftedImmi, branchAddr);
    assign branchSelect = (BeqSig && zero) || (BneSig && (!zero));
    MUX32 MUX_branch(branchSelect, PC_p4, branchAddr, addr_p4_branch);
    MUX32 MUX_jump(Jump, addr_p4_branch, jumpAddr, nextPC);
    dataMemory dataMemory(clk, ALUResult, readData2_reg, MemWrite, MemRead, readData_mem);
    MUX32 MUX_wb(MemtoReg, ALUResult, readData_mem, writeData_reg);
endmodule