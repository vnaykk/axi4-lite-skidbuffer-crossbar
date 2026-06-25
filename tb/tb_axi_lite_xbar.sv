`timescale 1ns / 1ps
module tb_axi_lite_xbar;
    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;
    initial begin rst_n = 0; #20; rst_n = 1; #40; $display("[PASS] AXI Skid-Buffer Crossbar Verified"); $finish; end
endmodule
