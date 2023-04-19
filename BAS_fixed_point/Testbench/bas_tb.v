`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 07:18:16 PM
// Design Name: 
// Module Name: bas_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:x,
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bas_tb(

    );
    
    bas bas1(clock,reset,load, seed_x,seed_y,iterations,x,y,x_extreme,y_extreme,out_value,done );
    
    reg clock,reset,load;
    reg [8:0] seed_x,seed_y;
    reg [8:0] iterations;
    reg [15:0] x,y;
    wire [15:0] x_extreme,y_extreme;
    wire [39:0] out_value;
    wire done;
    initial
    begin
            clock=0;
            reset=1;
            load=0;
            iterations=255;
            x=16'h6500; //initial position 101
            y=16'h7D00; //initial position 125
            seed_x=9'b010101010;
            seed_y=9'b001100111;
        #10 reset=0;
            load=1;
        #10 load=0;
    end
    
    always 
        #5 clock=~clock;
           
endmodule
