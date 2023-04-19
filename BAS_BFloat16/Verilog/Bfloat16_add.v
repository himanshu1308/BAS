module Bfloat16_add(
    input [15:0]c,
    input [15:0]d,
    output reg [15:0]sum);
    
    wire [7:0]e1, e2;
    wire s1, s2;
    reg C, sign;
    reg [2:0]position;
    reg [7:0]n1, n2;    
    reg [7:0]exponent, S;
    reg [6:0]mantissa;
    
    assign e1 = c[14:7];
    assign e2 = d[14:7];
    assign s1 = c[15];
    assign s2 = d[15];
    
    always@(*)
    begin
        if(e1>e2)
        begin
            n1 = {1'b1, c[6:0]}; 
            n2 = {1'b1, d[6:0]}>>(e1-e2);
            sign = s1;
            if(~(s1^s2))
            begin
                {C, S} = n1+n2;
                if(C)
                begin
                    mantissa = S[7:1];
                    exponent = e1+1;
                end
                else
                begin
                    mantissa = S[6:0];
                    exponent = e1;
                end
            end
            else
            begin
                S = n1-n2;
                position = S[7]?0:(S[6]?1:(S[5]?2:(S[4]?3:(S[3]?4:(S[2]?5:S[1]?6:7)))));
                exponent = e1-position;
                case(position)
                    3'd0: mantissa = S[6:0];
                    3'd1: mantissa = {S[5:0], 1'd0};
                    3'd2: mantissa = {S[4:0], 2'd0};
                    3'd3: mantissa = {S[3:0], 3'd0};
                    3'd4: mantissa = {S[2:0], 4'd0};
                    3'd5: mantissa = {S[1:0], 5'd0};
                    3'd6: mantissa = {S[0], 6'd0};
                    3'd7: mantissa = 0;
                    default: mantissa = 0;               
                endcase
            end            
        end       
        
        else if(e2>e1)
        begin
            n1 = {1'b1, c[6:0]}>>(e2-e1); 
            n2 = {1'b1, d[6:0]};
            sign = s2;
            if(~(s1^s2))
            begin
                {C, S} = n1+n2;
                if(C)
                begin
                    mantissa = S[7:1];
                    exponent = e2+1;
                end
                else
                begin
                    mantissa = S[6:0];
                    exponent = e2;
                end
            end
            else
            begin
                S = n2-n1;
                position = S[7]?0:(S[6]?1:(S[5]?2:(S[4]?3:(S[3]?4:(S[2]?5:S[1]?6:7)))));
                exponent = e2-position;
                case(position)
                    3'd0: mantissa = S[6:0];
                    3'd1: mantissa = {S[5:0], 1'd0};
                    3'd2: mantissa = {S[4:0], 2'd0};
                    3'd3: mantissa = {S[3:0], 3'd0};
                    3'd4: mantissa = {S[2:0], 4'd0};
                    3'd5: mantissa = {S[1:0], 5'd0};
                    3'd6: mantissa = {S[0], 6'd0};
                    3'd7: mantissa = 0;
                    default: mantissa = 0;               
                endcase
            end            
        end
    
    else
    begin
         n1 = {1'b1, c[6:0]}; 
         n2 = {1'b1, d[6:0]};
         if(~(s1^s2))
         begin
            sign = s1;
            {C, S} = n1+n2;
            if(C)
            begin
                 mantissa = S[7:1];
                 exponent = e1+1;
            end
            else
            begin
                 mantissa = S[6:0];
                 exponent = e1;
            end
         end
         else
         begin
            if(n1>n2)
            begin
                S = n1-n2;
                position = S[6]?1:(S[5]?2:(S[4]?3:(S[3]?4:(S[2]?5:S[1]?6:7))));
                //position = S[7]?3'd0:(S[6]?3'd1:(S[5]?3'd2:(S[4]:3'd3:(S[3]?3'd4:(S[2]?3'd5:(S[1]?3'd6:3'd7))))));
                case(position)
                    3'd0: mantissa = S[6:0];
                    3'd1: mantissa = {S[5:0], 1'd0};
                    3'd2: mantissa = {S[4:0], 2'd0};
                    3'd3: mantissa = {S[3:0], 3'd0};
                    3'd4: mantissa = {S[2:0], 4'd0};
                    3'd5: mantissa = {S[1:0], 5'd0};
                    3'd6: mantissa = {S[0], 6'd0};
                    3'd7: mantissa = 7'd0;              
                endcase
                exponent = e1 - position;
                sign = s1;
            end
            else if(n2>n1)
            begin
                S = n2-n1;
                position = S[6]?1:(S[5]?2:(S[4]?3:(S[3]?4:(S[2]?5:S[1]?6:7))));
                case(position)
                    3'd0: mantissa = S[6:0];
                    3'd1: mantissa = {S[5:0], 1'd0};
                    3'd2: mantissa = {S[4:0], 2'd0};
                    3'd3: mantissa = {S[3:0], 3'd0};
                    3'd4: mantissa = {S[2:0], 4'd0};
                    3'd5: mantissa = {S[1:0], 5'd0};
                    3'd6: mantissa = {S[0], 6'd0};
                    3'd7: mantissa = 0;               
                endcase
                exponent = e2 - position;
                sign = s2;
            end
            else
            begin
                {sign, exponent, mantissa} = 0;
            end
         end
      end
      sum = {sign, exponent, mantissa};           
    end   
endmodule
