module Bfloat16_mul(
    input [15:0]a, 
    input [15:0]b, 
    output reg [15:0]product);
    
    reg sign, carry;
    reg [15:0] mul, inter;
    reg [1:0]temp, position;
    reg [7:0]exponent, n1, n2;
    reg [6:0]mantissa;
    reg [7:0]roundoff;
    wire [4:0] point;
    wire [2:0]count1, count2;
    
    // To keep a track of the decimal point.
    assign count1 = a[0]?3'd7:(a[1]?3'd6:(a[2]?3'd5:(a[3]?3'd4:(a[4]?3'd3:(a[5]?3'd2:(a[6]?3'd1:3'd0))))));
    assign count2 = b[0]?3'd7:(b[1]?3'd6:(b[2]?3'd5:(b[3]?3'd4:(b[4]?3'd3:(b[5]?3'd2:(b[6]?3'd1:3'd0))))));
    assign point = count1+count2;
    
    always@(*)
    begin
        if(count1 == 3'd7)
            n1 = {1'b1, a[6:0]};
        else if(count1 == 3'd6)
            n1 = {1'b0, 1'b1, a[6:1]};
        else if(count1 == 3'd5)
            n1 = {2'b0, 1'b1, a[6:2]};
        else if(count1 == 3'd4)
            n1 = {3'b0, 1'b1, a[6:3]};
        else if(count1 == 3'd3)
            n1 = {4'b0, 1'b1, a[6:4]};
        else if(count1 == 3'd2)
            n1 = {5'b0, 1'b1, a[6:5]};
        else if(count1 == 3'd1)
            n1 = {6'b0, 1'b1, a[6]};
        else
            n1 = {7'b0, 1'b1};
            
        if(count2 == 3'd7)
            n2 = {1'b1, b[6:0]};
        else if(count2 == 3'd6)
            n2 = {1'b0, 1'b1, b[6:1]};
        else if(count2 == 3'd5)
            n2 = {2'b0, 1'b1, b[6:2]};
        else if(count2 == 3'd4)
            n2 = {3'b0, 1'b1, b[6:3]};
        else if(count2 == 3'd3)
            n2 = {4'b0, 1'b1, b[6:4]};
        else if(count2 == 3'd2)
            n2 = {5'b0, 1'b1, b[6:5]};
        else if(count2 == 3'd1)
            n2 = {6'b0, 1'b1, b[6]};
        else
            n2 = {7'b0, 1'b1};
    end
    
    always@(*)
    begin
        if(a[14:0] == 0 | b[14:0] ==0)
        begin
            product = 0;
        end
        else if(a[14:7] == 255 | b[14:7] == 255)
        begin
            sign = a[15]^b[15];
            product = {sign, 8'd255, 7'b0};
        end
        else
        begin
            sign = a[15]^b[15];
            mul = n1*n2;
            temp = mul >> point;
            position = temp[1]?2'd2:(temp[0]?2'd1:2'd0);
            
            inter = mul[15]?mul:(mul[14]?(mul<<1):(mul[13]?(mul<<2):(mul[12]?(mul<<3):(mul[11]?(mul<<4):(mul[10]?(mul<<5):(mul[9]?(mul<<6):(mul[8]?(mul<<7):(mul[7]?(mul<<8):(mul[6]?(mul<<9):(mul[5]?(mul<<10):(mul[4]?(mul<<11):(mul[3]?(mul<<12):(mul[2]?(mul<<13):(mul[1]?(mul<<14):(mul<<15)))))))))))))));
            if(inter[7])
            begin
                {carry, roundoff} = inter[15:8]+1;
                if(carry)
                begin
                    mantissa = roundoff[7:1];
                    exponent = a[14:7] + b[14:7] - 127 + position;
                end
                else
                begin
                    mantissa = roundoff[6:0];
                    exponent = a[14:7] + b[14:7] - 127 + position - 1;
                end
            end
            else
            begin
                mantissa = inter[14:8]; 
                exponent = a[14:7] + b[14:7] - 127 + position - 1;
            end
            product = {sign, exponent, mantissa};
        end 
    end          
endmodule

