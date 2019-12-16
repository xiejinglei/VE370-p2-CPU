`timescale 1ns / 1ps

module hazardUnit(EXMemRead, beq, bne, equal, jump, EXRegisterRt, IDRegisterRs, IDRegisterRt,
    PCWrite, IF_IDWrite, IFFlush, PCSrc, MUX_select);

    // Assume branch not taken

    // Singals related to hazard
    // Load-Use hazard
    input EXMemRead;
    // Branch and jump related
    input beq, bne, equal, jump;
    // Registers for detecting load-use hazard
    input [4:0] EXRegisterRt, IDRegisterRs, IDRegisterRt;

    output PCWrite, IF_IDWrite, IFFlush, PCSrc;
    // If MUX_select = 1, then flush signals in ID/EX
    output MUX_select;

    reg PCWrite, IF_IDWrite, IFFlush, PCSrc, MUX_select;

    initial begin
        MUX_select <= 0;
        PCWrite <= 1;
        IF_IDWrite <= 1;
        IFFlush <= 0;
        PCSrc <= 1;
    end


    always @ (*)
    begin
        // branch (beq & bne)
        if ((beq && equal) || (bne && equal == 0)) begin 
            MUX_select <= 1;
            PCWrite <= 1;
            IF_IDWrite <= 0;
            IFFlush <= 1;
            PCSrc <= 0;    
        end
        // jump
        else if (jump) begin
            MUX_select <= 1;
            PCWrite <= 1;
            IF_IDWrite <= 0;
            IFFlush <= 1;
            PCSrc <= 0; 
        end
        // load-use hazard
        else if (EXMemRead && (EXRegisterRt == IDRegisterRs || 
            EXRegisterRt == IDRegisterRt)) begin
            MUX_select <= 1;
            PCWrite <= 0;
            IF_IDWrite <= 0;
            IFFlush <= 0;
            PCSrc <= 1;
        end
        // No hazard that needs NOP detected
        else begin 
            MUX_select <= 0;
            PCWrite <= 1;
            IF_IDWrite <= 1;
            IFFlush <= 0;
            PCSrc <= 1;         
        end
    end
endmodule
