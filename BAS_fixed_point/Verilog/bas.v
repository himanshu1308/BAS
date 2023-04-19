`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 06:55:29 PM
// Design Name: 
// Module Name: bas
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

module bas(clock,reset,load, seed_x,seed_y,iterations,x,y,x_extreme,y_extreme,out_value,done );

    input clock,reset,load;
    input [8:0] seed_x,seed_y;
    input [8:0] iterations;
    input [15:0] x,y;
    output signed [15:0] x_extreme,y_extreme;
    output signed [39:0] out_value;
    output reg done;
    
    wire signed [15:0] x_l,y_l,x_r,y_r;
    wire signed [8:0] dir_x,dir_y;
    reg signed [13:0] sense,move;
    reg  [9:0] count;
    wire signed [8:0] sense_c,move_c;
    wire signed [39:0] odour_left;
    wire signed [39:0] odour_right;
    wire signed [39:0] value;
    reg signed [39:0] value_best;
    reg signed [15:0] x_curr,y_curr,x_best,y_best;
    wire signed[15:0] x_updated,y_updated;
    
    wire signed [22:0] temp_sense,temp_move;
    assign sense_c=9'h0FF; //0.99609375
    assign move_c=9'h0FF;  //0.99609375
    assign temp_sense= (sense*sense_c);
    assign temp_move= (move*move_c);
    
    wire [39:0] temp_value_left1,temp_value_left2,temp_value_left4,temp_value_left5 ;
    wire [39:0] temp_value_left3,temp_value_left6 ;
    
    assign temp_value_left1=16'sh0200 * y_l;
    assign temp_value_left2=(x_l + (temp_value_left1 >>> 8)-16'sh0700) ;
    assign temp_value_left3= temp_value_left2 * temp_value_left2;
    assign temp_value_left4= 16'sh0200*x_l;
    assign temp_value_left5= ((temp_value_left4>>>8) + y_l -16'sh0500) ;
    assign temp_value_left6= temp_value_left5*temp_value_left5;
    
    assign odour_left= (temp_value_left3>>>8)  + (temp_value_left6>>>8);
    
    wire [39:0] temp_value_right1,temp_value_right2,temp_value_right4,temp_value_right5 ;
    wire [39:0] temp_value_right3,temp_value_right6 ;
    
    assign temp_value_right1=16'sh0200 * y_r;
    assign temp_value_right2=(x_r + (temp_value_right1 >>> 8)-16'sh0700) ;
    assign temp_value_right3= temp_value_right2 * temp_value_right2;
    assign temp_value_right4= 16'sh0200*x_r;
    assign temp_value_right5= ((temp_value_right4>>>8) + y_r -16'sh0500) ; 
    assign temp_value_right6= temp_value_right5*temp_value_right5;

    assign odour_right= (temp_value_right3>>>8)  + (temp_value_right6>>>8);
    
    wire [39:0] temp_value1,temp_value2,temp_value4,temp_value5;
    wire [39:0] temp_value3,temp_value6 ;
    
    assign temp_value1= 16'sh0200 * y_curr;
    assign temp_value2= (x_curr + (temp_value1 >>> 8)-16'sh0700) ;
    assign temp_value3= temp_value2*temp_value2;
    assign temp_value4= 16'sh0200*x_curr;
    assign temp_value5= ((temp_value4>>>8) + y_curr -16'sh0500) ;
    assign temp_value6= temp_value5*temp_value5;

    assign value= (temp_value3>>>8)  + (temp_value6>>>8);
    //assign value= ( ((x + ((17'sh00200 * y)>>>8)-17'sh00700)**2)>>>8) + ((( ((17'sh00200*x)>>>8) + y -17'sh00500)**2)>>>8);
    
        
   // assign odour_right=( ((x_r + ((17'sh00200 * y_r)>>>8)-17'sh00700)**2)>>>8) + ((( ((17'sh00200*x_r)>>>8) + y_r -17'sh00500)**2)>>>8);
  
    assign x_extreme=x_best;
    assign y_extreme=y_best;
    assign out_value=value_best;
    
    
    always@(posedge clock)
    begin
        if(reset)
        begin
             
            sense<=14'b0;
            move<=14'b0;
            count<=10'b0;
            value_best<=39'h0FFFFFFFFF;
            x_curr<=x; 
            y_curr<=y; 
            x_best<=0;
            y_best<=0;
            done<=0;
        end
        else if(load)
        begin
            sense<=14'h1F00; //31
            move<=14'h1F00;  //31
            count<=10'b0;
            value_best<=32'h0FFFFFFF; //initially considering a maximum value
        end
        else
        begin
            if(count<iterations)
            begin
                
                sense <= (temp_sense >>>8);
                
                move <= (temp_move >>> 8);
                count<=count+1;
                x_curr<=x_updated;
                y_curr<=y_updated;
                
                if(value<value_best)
                begin
                    value_best<=value;
                    x_best<=x_curr;
                    y_best<=y_curr;
                end
                
            end
            else
            begin
                sense<=14'b0;
                move<=14'b0;
                done<=1'b1;
            end
        end
    end    
        
    lfsr lfsr1(clock,reset,load,seed_x,seed_y,dir_x,dir_y);
    beetle_left_antenna bla1(dir_x,dir_y,x_curr,y_curr,sense,x_l,y_l);
    beetle_right_antenna bra1(dir_x,dir_y,x_curr,y_curr,sense,x_r,y_r);
    beetle_position bp1 (move,dir_x,dir_y,odour_left,odour_right,x_updated,y_updated,x_curr,y_curr);
    
endmodule