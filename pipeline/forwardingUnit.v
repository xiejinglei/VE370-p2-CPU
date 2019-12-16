`timescale 1ns / 1ps

module forwardingUnit(MEMRegWrite, MEM_WriteReg, EXRegisterRs, EXRegisterRt, 
    WBRegWrite, WB_WriteReg, ForwardA, ForwardB); 

    // RegWrite signals
    input MEMRegWrite, WBRegWrite;
    // destination registers
    input [4:0] MEM_WriteReg, WB_WriteReg, EXRegisterRs, EXRegisterRt;
    // forwarding signals
    output [1:0] ForwardA, ForwardB;

    reg [1:0] ForwardA, ForwardB;

    always@ (*) begin
        // Forwarding from EX_MEM (EX hazard)
        if(MEMRegWrite == 1'b1 && (MEM_WriteReg != 0) && (MEM_WriteReg == EXRegisterRs)) 
            ForwardA <= 2'b10;
        // Forwarding from MEM_WB (MEM hazard)
        else if(WBRegWrite == 1'b1 && (WB_WriteReg != 0) && (WB_WriteReg == EXRegisterRs))
            ForwardA <= 2'b01;
        // Select current EX registers
        else ForwardA <= 2'b00;
    end

    always@ (*) begin
        // Forwarding from EX_WEM (EX hazard) (including load-use after nop)
        if(MEMRegWrite == 1'b1 && (MEM_WriteReg != 0) && (MEM_WriteReg == EXRegisterRt)) 
           ForwardB <= 2'b10;
        // Forwarding from MEM_WB (MEM hazard) (including load-use after nop)
        else if(WBRegWrite == 1'b1 && (WB_WriteReg != 0) && (WB_WriteReg == EXRegisterRt)) 
            ForwardB <= 2'b01;
        // Select current EX registers
        else ForwardB <= 2'b00;
    end

endmodule
