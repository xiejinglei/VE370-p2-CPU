`timescale 1ns / 1ps
module control(opcode, RegDst, Jump, BeqSig, BneSig, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite); 
    input [5:0] opcode;
    output RegDst, Jump, BeqSig, BneSig, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    output [2:0] ALUOp;

    reg RegDst, Jump, BeqSig, BneSig, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    reg [2:0]ALUOp; 

    // Initialize all the control signals to 0
    initial begin
        RegDst = 1'b0; 
        Jump = 1'b0;
        BeqSig = 1'b0;
        BneSig = 1'b0;
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        ALUOp = 3'b000;
    end

    always @ (opcode) begin
        case (opcode)
            // R-type
            6'b000000: begin
                RegDst = 1'b1; 
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
                ALUOp = 3'b010;
            end
            // J-type
            6'b000010: begin 
                RegDst = 1'b0;
                Jump = 1'b1;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                ALUOp = 3'b000;
            end
            // beq
            6'b000100: begin
                RegDst = 1'b0;
                Jump = 1'b0;
                BeqSig = 1'b1;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                ALUOp = 3'b001;
            end
            // bne
            6'b000101: begin
                RegDst = 1'b0;
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b1;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                ALUOp = 3'b001;
            end
            // addi
            6'b001000: begin
                RegDst = 1'b0;
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                ALUOp = 3'b011;
            end
            // andi
            6'b001100: begin
                RegDst = 1'b0;
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                ALUOp = 3'b100;
            end
            // lw
             6'b100011: begin
                RegDst = 1'b0;
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b1;
                MemtoReg = 1'b1;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                ALUOp = 3'b000;
            end
            // sw
             6'b101011: begin
                RegDst = 1'b0;
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                RegWrite = 1'b0;
                ALUOp = 3'b000;
            end
            default: begin
                RegDst = 1'b0; 
                Jump = 1'b0;
                BeqSig = 1'b0;
                BneSig = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                ALUOp = 3'b000;
            end
        endcase
    end
endmodule
