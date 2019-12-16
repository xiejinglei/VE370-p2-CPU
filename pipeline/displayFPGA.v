`timescale 1ns / 1ps

module displayFPGA(clk, FPGAclk, displayPC, displayReg, cathod, AN0, AN1, AN2, AN3);

    input clk, FPGAclk, displayPC; // displayPC = 1 => display PC
    input [4:0] displayReg; // The Reg to be displayed
    output AN0, AN1, AN2, AN3;
    output [6:0] cathod;

    wire FPGAclk_div;
    parameter reset = 1'b0;

    wire [31:0]currentPC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9;
    reg [31:0]value;
    

    clock_divider #(27'd200000) M1 (FPGAclk_div, FPGAclk, reset);
    pipeline_top M2(clk,currentPC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9);

    always@ (displayPC or displayReg or clk) begin
        if (displayPC)  value <= currentPC;
        else if (displayReg == 5'b00000)  value <= s0;
        else if (displayReg == 5'b00001)  value <= s1;
        else if (displayReg == 5'b00010)  value <= s2;
        else if (displayReg == 5'b00011)  value <= s3;
        else if (displayReg == 5'b00100)  value <= s4;
        else if (displayReg == 5'b00101)  value <= s5;
        else if (displayReg == 5'b00110)  value <= s6;
        else if (displayReg == 5'b00111)  value <= s7;
        else if (displayReg == 5'b01000)  value <= t0;
        else if (displayReg == 5'b01001)  value <= t1;
        else if (displayReg == 5'b01010)  value <= t2;
        else if (displayReg == 5'b01011)  value <= t3;
        else if (displayReg == 5'b01100)  value <= t4;
        else if (displayReg == 5'b01101)  value <= t5;
        else if (displayReg == 5'b01110)  value <= t6;
        else if (displayReg == 5'b01111)  value <= t7;
        else if (displayReg == 5'b10000)  value <= t8;
        else if (displayReg == 5'b10001)  value <= t9;
        else    value <= currentPC;
    end
    

    enable_sr M3(FPGAclk_div, AN3, AN0, AN1, AN2);

    reg [3:0]disp_num;
    reg [1:0]count;

    initial count = 2'b00;

    always@ (posedge FPGAclk_div)   begin
        if (count == 2'b00) begin 
            disp_num <= value[3:0];
            count <= 2'b01;
        end
        else if (count == 2'b01) begin
            disp_num <= value[7:4];
            count <= 2'b10;
        end
        else if (count == 2'b10) begin
            disp_num <= value[11:8];
            count <= 2'b11;
        end
        else begin
            disp_num <= value[15:12];
            count <= 2'b00;
        end
    end

    SSD_driver M4(disp_num, cathod);

endmodule 


module SSD_driver(disp_num, LED_out);
 
    input [3:0] disp_num;
    output [6:0] LED_out;
    reg [6:0] LED_out;
    
    always @(*)
    begin
    case (disp_num)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        4'b1010: LED_out = 7'b0001000; // "A"
        4'b1011: LED_out = 7'b1100000; //"B"
        4'b1100: LED_out = 7'b0110001; //"C
        4'b1101: LED_out = 7'b1000010; //"D"
        4'b1110: LED_out = 7'b0110000; //"E"
        4'b1111: LED_out = 7'b0111000; //F
        default: LED_out = 7'b0111111; 
        endcase
    end
endmodule


module clock_divider(clk_out, clk_in, reset);
	input clk_in, reset;
	output clk_out;

	parameter DIVISOR = 27'd100000000;
	reg clk_out = 1'b0;
	reg [26:0] counter = 27'd0; 
    
	always@ (posedge clk_in or posedge reset) begin
		if (reset == 1)     
			counter <= 27'd0;
		else if (counter == DIVISOR - 1) begin 
			clk_out <= 1'b1;
			counter <= 27'd0;
		end 
		else if (counter == 0 && clk_out == 1'b1) begin 
			clk_out <= 1'b0;
			counter <= counter + 27'd1;
		end
		else      
			counter <= counter + 27'd1;
	end
endmodule


module enable_sr(input refreshClk, output enable_D1, output enable_D2, output enable_D3, 
    output enable_D4  );

reg [3:0] pattern = 4'b0111; 

assign enable_D1 = pattern[3]; 
assign enable_D2 = pattern[2]; 
assign enable_D3 = pattern[1]; 
assign enable_D4 = pattern[0]; 

always @(posedge refreshClk) begin
  pattern <= {pattern[0],pattern[3:1]}; 
end

endmodule