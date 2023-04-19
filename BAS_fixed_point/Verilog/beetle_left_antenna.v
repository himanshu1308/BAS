`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 06:36:30 PM
// Design Name: 
// Module Name: beetle_left_antenna
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


module beetle_left_antenna(dir_x,dir_y,x,y,sense,x_l,y_l);
input signed [8:0] dir_x,dir_y;
input signed [15:0] x,y;
input signed [13:0] sense; //keep it positive always
output signed [15:0] x_l,y_l; 

wire  signed [22:0] temp_x,temp_y;

assign temp_x=dir_x*sense;
assign temp_y=dir_y*sense;

assign x_l= x + (temp_x>>>8);
assign y_l= y + (temp_y>>>8);


endmodule

