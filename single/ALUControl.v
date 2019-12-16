`timescale 1ns / 1ps
module ALUControl(funct, ALUOp, out);
    input [5:0] funct;
    input [2:0] ALUOp;
    output [3:0] out;

    reg [3:0] out;

    initial out = 4'b0000;
    always @ (funct or ALUOp)   begin
        case (ALUOp)
            // lw sw
            3'b000: out <= 4'b0010; //add
            // beq bne
            3'b001: out <= 4'b0110; //sub
            // R-type
            3'b010: begin
                case (funct)
                    6'b100000: out <= 4'b0010;  //add
                    6'b100010: out <= 4'b0110;  //sub
                    6'b100100: out <= 4'b0000;  //and
                    6'b100101: out <= 4'b0001;  //or
                    6'b101010: out <= 4'b0111;  //sll
                    default: out <= 4'b0010;
                endcase
            end
            // addi
            3'b011: out <= 4'b0010; //add
            // andi
            3'b100: out <= 4'b0000; //and
            default: out <= 4'b0010;    //add
        endcase
    end
endmodule  