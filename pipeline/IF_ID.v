`timescale 1ns / 1ps

module IF_ID(clk, flush, regWrite, IF_PC_p4, IF_inst, ID_PC_p4, ID_inst);
    // reg IF/ID
    input clk, flush, regWrite;
    input [31:0] IF_PC_p4, IF_inst;
    output [31:0] ID_PC_p4, ID_inst;
    reg [31:0] ID_PC_p4, ID_inst;

    always@ (posedge clk) begin
        // flush register (nop)
        if (flush == 1) begin
            ID_PC_p4 <=32'b0; 
            ID_inst <= 32'b0;
        end
        // pass information normally
        else if (regWrite == 1) begin
            ID_PC_p4 <= IF_PC_p4;
            ID_inst <= IF_inst;
        end
        // hold the data
        else begin
            ID_PC_p4 <= ID_PC_p4;
            ID_inst <= ID_inst;
        end
    end
endmodule