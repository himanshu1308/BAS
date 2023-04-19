`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2023 19:58:24
// Design Name: 
// Module Name: BAS
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


module BAS(input clk, input reset, input [8:0]count, input [8:0]seed1, input [8:0]seed2, input [15:0]xi, input [15:0]yi, input [15:0]P, input [15:0]E, output [15:0]xo, output [15:0]yo, output [15:0]fo, output reg [31:0]clk_cnt, output reg done);
    reg [8:0]counter;
    reg [15:0]x, y, f, x_temp, y_temp, r1, x1, y1;
    wire [15:0]dx, dy, xr, yr, xl, yl, dfx, dfy;
    wire [15:0]w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, fr, fl, f_temp, p_t, e_t;
    reg sign;
   
    reg [15:0]p, e, tt;
    
    twin_lfsr i1(clk, reset, seed1, seed2, dx, dy);
    
    assign w1 = {~dx[15], dx[14:0]};
    assign w2 = {~dy[15], dy[14:0]};
    
    Bfloat16_mul i2(p, dx, w3);
    Bfloat16_mul i3(p, dy, w4);
    Bfloat16_add i4(w3, x, xr);
    Bfloat16_add i5(w4, y, yr);
    
    Bfloat16_mul i6(p, w1, w5);
    Bfloat16_mul i7(p, w2, w6);
    Bfloat16_add i8(w5, x, xl);
    Bfloat16_add i9(w6, y, yl);
    
    fitness_func i10(xr, yr, fr);
    fitness_func i11(xl, yl, fl);
    
    fitness_func i12(x_temp, y_temp, f_temp);
    
    Bfloat16_mul i13(dfx, e, w7);
    Bfloat16_mul i14(dfy, e, w8);
    Bfloat16_add i15(x, w7, w9);
    Bfloat16_add i16(y, w8, w10);
    
    assign dfx = {sign, dx[14:0]};
    assign dfy = {sign, dy[14:0]};
    
    always@(posedge clk)
    begin
        if(reset) begin
            counter <= count;
            clk_cnt <= 0;
            done <= 0;
            x <= xi;
            y <= yi;
            p <= P;
            e <= E;
            f <= f_temp;
        end
        else begin
            counter <= (counter != 0)?(counter-1'b1):(counter);
            if(counter == 0)
            begin
                clk_cnt <= clk_cnt;
                done <= 1'b1;
                x <= x;
                y <= y;
                f <= f;
            end
            else
            begin
                clk_cnt <= clk_cnt + 1;
                done <= 0;
                x <= x1;
                y <= y1;
                f <= r1;
            end
        end
    end
    
    
    always@(*)
    begin
        if(fr[15] == 1'b1 & fl[15] == 1'b0)         sign = 1'b1;
        else if(fr[15] == 1'b0 & fl[15] == 1'b1)    sign = 1'b0;
        else
        begin
            if(fr[14:10] > fl[14:10])               sign = fr[15]?1'b1:1'b0;
            else if(fr[14:10] < fl[14:10])          sign = fr[15]?1'b0:1'b1;
            else
            begin
                if(fr[9:0] > fl[9:0])               sign = fr[15]?1'b1:1'b0;
                else                                sign = fr[15]?1'b0:1'b1;
            end
        end 
        
        if(reset) begin
            x_temp <= xi;
            y_temp <= yi;
        end
        
        else begin
            x_temp <= w9;
            y_temp <= w10;
        end            
        
        
        
        if(f_temp[15] == 1'b1 & f[15] == 1'b0) begin
            r1 <= f_temp;
            x1 <= x_temp;
            y1 <= y_temp;
        end
        
        else if(f_temp[15] == 1'b0 & f[15] == 1'b1) begin   
            r1 <= f;
            x1 <= x;
            y1 <= y;
        end
        
        else
        begin
            if(f_temp[14:10] > f[14:10]) begin
                r1 <= f[15]?f_temp:f;
                x1 <= f[15]?x_temp:x;
                y1 <= f[15]?y_temp:y;
            end
            
            else if(f_temp[14:10] < f[14:10]) begin          
                r1 <= f[15]?f:f_temp;
                x1 <= f[15]?x:x_temp;
                y1 <= f[15]?y:y_temp;
            end
            
            else
            begin
                if(f_temp[9:0] > f[9:0]) begin
                    r1 <= f[15]?f_temp:f;
                    x1 <= f[15]?x_temp:x;
                    y1 <= f[15]?y_temp:y;
                 end
                else begin                                 
                    r1 <= f[15]?f:f_temp;
                    x1 <= f[15]?x:x_temp;
                    y1 <= f[15]?y:y_temp;
                end
            end
        end           
    end
    
    assign xo = x;
    assign yo = y;
    assign fo = f;
endmodule

