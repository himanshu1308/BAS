`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 04:00:53 PM
// Design Name: 
// Module Name: lfsr
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

module lfsr(clock,reset,load,seed_x,seed_y,dir_x,dir_y);
input clock,reset,load;
input [8:0] seed_x,seed_y;
output reg [8:0] dir_x,dir_y;


always@(posedge clock)
begin
    if(reset)
    begin
        dir_x<=9'b0;
        dir_y<=9'b0;
    end
    else if(load)
    begin
        dir_x<=seed_x;
        dir_y<=seed_y;
    end
    else
    begin
        dir_x[8:1]<=dir_x[7:0];
        dir_x[0]<= (dir_x[1] ^ dir_x[2]) ^ (dir_x[3] ^ dir_x[7]);
        dir_y[8:1]<=dir_y[8:0];
        dir_y[0]<= (dir_y[1] ^ dir_y[2]) ^ (dir_y[3] ^ dir_y[7]);
    end
 end
 
 endmodule