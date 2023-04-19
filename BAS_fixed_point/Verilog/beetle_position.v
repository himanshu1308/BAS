`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 06:51:11 PM
// Design Name: 
// Module Name: beetle_position
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


module beetle_position(move,dir_x,dir_y,odour_left,odour_right,updated_x,updated_y,x,y);
input signed [13:0] move; //must be positive
input signed [8:0] dir_x,dir_y;
input signed [15:0] x,y;
input signed [31:0] odour_left,odour_right;
output signed [15:0] updated_x,updated_y;
wire signed [13:0] move_x,move_y;
wire signed [22:0] temp_x,temp_y;
assign temp_x= move*dir_x;
assign temp_y= move*dir_y;
assign move_x= (temp_x>>> 8);
assign move_y=(temp_y >>> 8);

assign updated_x= (odour_left>odour_right)?(x-move_x):(x+move_x);
assign updated_y= (odour_left>odour_right)?(y-move_y):(y+move_y);

endmodule
