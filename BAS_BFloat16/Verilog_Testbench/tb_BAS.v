`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2023 19:59:41
// Design Name: 
// Module Name: tb_BAS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_BAS();
    reg clk, reset;
    reg [8:0]count, seed1, seed2;
    reg [15:0]xi, yi, P, E;
    wire done;
    wire [15:0]xo, yo, fo;
    wire [31:0]clk_cnt;
    
    BAS dut(clk, reset, count, seed1, seed2, xi, yi, P, E, xo, yo, fo, clk_cnt, done);
    
    always #5 clk = ~clk;
        
    initial begin
        #100;
        clk = 0;
        reset = 1;
        count = 9'b011111111;
        xi = 16'h42ca;
        yi = 16'h42fa;
        P = 16'h41c8;
        E = 16'h41c8;
        seed1 = 9'b000100001;
        seed2 = 9'b101001110;
        
        #15; reset = 0;       
        
        #5000 $finish();
    end
endmodule