`timescale 1ns / 1ps

module pipeline_sim;
reg clk;
wire [31:0]PC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9;

pipeline_top UUT(clk,PC,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9);
initial begin
    #0 clk = 0;
end
always #0.5 begin
    clk = ~clk;
    #0.5 begin
    $display("Time: %t, CLK = %b, PC = %h\n", $time, clk, PC);
    $display("[$s0] = %h, [$s1] = %h, [$s2] = %h\n", s0, s1,s2);
    $display("[$s3] = %h, [$s4] = %h, [$s5] = %h\n", s3, s4, s5);
    $display("[$s6] = %h, [$s7] = %h, [$t0] = %h\n", s6, s7, t0);
    $display("[$t1] = %h, [$t2] = %h, [$t3] = %h\n", t1, t2, t3);
    $display("[$t4] = %h, [$t5] = %h, [$t6] = %h\n",t4, t5, t6);
    $display("[$t7] = %h, [$t8] = %h, [$t9] = %h\n",t7, t8, t9);
    end
end
initial #78 $stop;
endmodule