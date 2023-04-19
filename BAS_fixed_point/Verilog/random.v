`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 05:16:30 PM
// Design Name: 
// Module Name: random
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



module random;
  
 // reg signed [11:0] a = 5.55*(2**8);
  reg signed [11:0] a = -5.555*(2**8);
  reg signed [11:0] b = 4.444*(2**8);
  wire signed [15:0] c;
  //wire signed [23:0]
 wire signed [23:0] d;
 assign d=(a*b);
  assign c = d >>> 8;
  
  initial
  begin
    #1 $display("b= %h", b);
        $display("a= %h", a);
   //     $display("d= %b", d);
        $display("c= %b", c);
        $finish;
        
  end
  
endmodule
