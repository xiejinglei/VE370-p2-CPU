`timescale 1ns / 1ps

module pipeline_top(clk,currentPC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9);

    input clk;
    // 32 bit registers for display
    output [31:0]currentPC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9;
    /*
    output [31:0]ALUResult, WB_writeData, WB_ALUResult;
    output [4:0]WB_WriteReg, MEM_WriteReg, EXRegisterRt, EXRegisterRd, EXWriteReg
    ,ID_instruction_15_11;
    output WBRegWrite, WBMemtoReg, EXRegDst;
    */

    // For MUX in ID to decide whether to clear ID_EX signals
    parameter czero = 1'b0;


    /* ============================ Wire Declarations ======================== */
    // IF stage
    wire PCSrc, PCWrite;    //initial PCSrc = 1, choose PC+4;
    wire [31:0] IF_PC_p4, PCJumpBranch, currentPC, nextPC, IF_instruction;
    wire IF_IDWrite, IF_Flush;      // IF_ID reg signals

    // ID stage
    wire [31:0] ID_instruction, ID_PC_p4; 
    wire [5:0] IDOpcode; // instruction[31:26]
    wire [4:0] ID_instruction_25_21, ID_instruction_20_16;  // rs, rt
    wire [4:0] ID_instruction_15_11; // rd
    wire [25:0] ID_instruction_25_0; // J-type addr
    wire [15:0] ID_instruction_15_0; // Immi
    wire [31:0] ID_readData1, ID_readData2; // data read from regFile
    
    wire [31:0] ID_signExtend, ID_shifted2; // For calculating branchAddr
    wire [31:0] branchAddr, jumpAddr; 

    // ID stage Control signals
    wire [2:0] ALUOp; 
    wire RegDst, Jump, Beq, Bne, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite; // Orig
    wire RegDst_IDout, MemRead_IDout, MemtoReg_IDout, MemWrite_IDout, ALUSrc_IDout, 
        RegWrite_IDout; // After MUX
    wire IDMUX_control; // Select whether to clear the signals
    wire equal; // condition of Beq Bne

    // EX stage
    wire [31:0] EXReg1, EXReg2, EXImmi; // ALU input from ID_EX
    wire [5:0] funct; // EXImmi[5:0]
    wire [2:0] EXALUOp;
    wire [1:0] ForwardA, ForwardB; // output of Forwarding unit
    wire [4:0] EXRegisterRs, EXRegisterRt, EXRegisterRd; // rs, rt, rd passed from previous stage
    wire [4:0] EXWriteReg; // Reg to be written in the register file
    wire [3:0] ALUControlSig; // ALU input
    wire [31:0] MUX2_result; // The first MUX for ALU input 2
    wire [31:0] ALUin1, ALUin2, ALUResult; // ALU in and out
    // singals
    wire EXMemRead, EXMemtoReg, EXMemWrite, EXALUSrc, EXRegWrite, EXRegDst;

    // MEM stage
    wire [31:0] MEMALUResult;   // Write address
    wire [31:0] MEMWriteData_orig, MEMReadData, MEMWriteData;
    wire select_writeData;  // select write data (or + sw hazard)
    wire [4:0] MEM_WriteReg;    // Reg to be written in the register file
    wire MEMRegWrite, MEMMemtoReg, MEMMemRead, MEMMemWrite; // signals

    // WB
    wire [4:0] WB_WriteReg; // Reg to be written in the register file
    wire [31:0] WB_writeData, WB_MEMReadData, WB_ALUResult; // select write data
    wire WBRegWrite, WBMemRead, WBMemtoReg; // signals


    /* ============================ Modules ========================== */
    // IF stage
    PC_add4 PC_add4(currentPC, IF_PC_p4);
    MUX32 MUX32_IF(PCSrc, PCJumpBranch, IF_PC_p4, nextPC);
    PC_reg PC_reg(nextPC, PCWrite, clk, currentPC);
    instructionMEM instructionMEM(currentPC, IF_instruction);

    // IF_ID reg
    IF_ID IF_ID(clk, IF_Flush, IF_IDWrite, IF_PC_p4, IF_instruction, ID_PC_p4, ID_instruction);

    // ID stage
    assign IDOpcode = ID_instruction[31:26];
    assign ID_instruction_25_21 = ID_instruction[25:21];
    assign ID_instruction_20_16 = ID_instruction[20:16];
    assign ID_instruction_15_11 = ID_instruction[15:11];
    assign ID_instruction_15_0 = ID_instruction[15:0];
    assign ID_instruction_25_0 = ID_instruction[25:0];
    // Get signals
    control control(IDOpcode, RegDst, Jump, Beq, Bne, MemRead, MemtoReg, ALUOp, 
        MemWrite, ALUSrc, RegWrite); 
    hazardUnit hazardUnit(EXMemRead, Beq, Bne, equal, Jump, EXRegisterRt, ID_instruction_25_21, 
        ID_instruction_20_16, PCWrite, IF_IDWrite, IF_Flush, PCSrc, IDMUX_control);
    // 1 bit MUXes
    // RegDst_IDout, MemRead_IDout, MemtoReg_IDout, MemWrite_IDout, ALUSrc_IDout, RegWrite_IDout;
    MUX1 MUX1_1(IDMUX_control, RegDst, czero, RegDst_IDout);
    MUX1 MUX1_2(IDMUX_control, MemRead, czero, MemRead_IDout);
    MUX1 MUX1_3(IDMUX_control, MemtoReg, czero, MemtoReg_IDout);
    MUX1 MUX1_4(IDMUX_control, MemWrite, czero, MemWrite_IDout);
    MUX1 MUX1_5(IDMUX_control, ALUSrc, czero, ALUSrc_IDout);
    MUX1 MUX1_6(IDMUX_control, RegWrite, czero, RegWrite_IDout);
    // Find branchAddr and jumpAddr
    signExtend signExtend(ID_instruction_15_0, ID_signExtend);
    shiftLeft2_32 shiftLeft2_32(ID_signExtend, ID_shifted2);
    add32 add32_branch(ID_PC_p4, ID_shifted2, branchAddr);
    jump_address jump_address(ID_PC_p4, ID_instruction_25_0 ,jumpAddr);
    MUX32 MUX32_branch_jump(Jump, branchAddr, jumpAddr, PCJumpBranch);
    // regFile
    registerFile registerFile(clk, ID_instruction_25_21, ID_instruction_20_16, WB_WriteReg, 
        WB_writeData, WBRegWrite, ID_readData1, ID_readData2, s0, s1, s2, s3, s4, s5, s6, 
        s7, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9);
    assign equal = (ID_readData1 == ID_readData2);

    // ID_EX reg
    ID_EX ID_EX(clk, MemRead_IDout, MemtoReg_IDout, MemWrite_IDout, ALUSrc_IDout, RegWrite_IDout,
        RegDst_IDout, ALUOp, ID_readData1, ID_readData2, ID_signExtend, ID_instruction_25_21,
        ID_instruction_20_16, ID_instruction_15_11, EXReg1, EXReg2, EXImmi, EXRegisterRs, 
        EXRegisterRt, EXRegisterRd, EXMemRead, EXMemtoReg, EXMemWrite, EXALUSrc, EXRegWrite, 
        EXRegDst, EXALUOp);
        
    // EX stage
    MUX32_3to1 MEM_MUX1(ForwardA, EXReg1, WB_writeData, MEMALUResult, ALUin1);
    MUX32_3to1 MEM_MUX2(ForwardB, EXReg2, WB_writeData, MEMALUResult, MUX2_result);
    MUX32 MEM_MUX3 (EXALUSrc, MUX2_result, EXImmi, ALUin2);
    //ALU
    assign funct = EXImmi[5:0];
    ALUControl ALUControl(funct, EXALUOp, ALUControlSig);
    //wire ALU_zero; (ALU_zero removed)
    ALU ALU(clk, ALUControlSig, ALUin1, ALUin2, ALUResult);
    // Choice write back register
    MUX5 MEM_MUX4(EXRegDst, EXRegisterRt, EXRegisterRd, EXWriteReg);
    // forwarding
    forwardingUnit forwardingUnit(MEMRegWrite, MEM_WriteReg, EXRegisterRs, EXRegisterRt, 
        WBRegWrite, WB_WriteReg, ForwardA, ForwardB); 

    // EX_MEM reg
    EX_MEM EX_MEM(clk, ALUResult, MUX2_result, EXWriteReg, EXMemRead, EXMemtoReg,
        EXMemWrite, EXRegWrite, MEMALUResult, MEMWriteData_orig, MEM_WriteReg, MEMMemRead, 
        MEMMemtoReg, MEMMemWrite, MEMRegWrite);
    
    // MEM stage
    // handle hazards like sw after or
    assign select_writeData = (WBRegWrite && MEMMemRead && (MEM_WriteReg == WB_WriteReg));
    MUX32 MUX32_MEM(select_writeData, MEMWriteData_orig, WB_writeData, MEMWriteData);
    dataMemory dataMemory(clk, MEMALUResult, MEMWriteData, MEMMemWrite, MEMMemRead, MEMReadData);

    // MEM_WB reg
    MEM_WB MEM_WB(clk, MEMMemtoReg, MEMRegWrite, MEMMemRead, MEMReadData, MEMALUResult,
        MEM_WriteReg, WBMemtoReg, WBRegWrite, WBMemRead, WB_MEMReadData, WB_ALUResult,
        WB_WriteReg);

    // WB stage
    MUX32 MUX_WB(WBMemtoReg, WB_ALUResult, WB_MEMReadData, WB_writeData);
    
endmodule