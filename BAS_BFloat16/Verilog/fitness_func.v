module fitness_func(input [15:0]x, input [15:0]y, output [15:0]out);
    reg [15:0]num2 = 16'h4000;
    reg [15:0]num5 = 16'hC0A0;
    reg [15:0]num7 = 16'hC0E0;
    wire [15:0]w1, w2, w3, w4, w5, w6, w7, w8;
    
    Bfloat16_mul m1(num2, y, w1);
    Bfloat16_mul m2(num2, x, w2);
    Bfloat16_add a3(x, w1, w3);
    Bfloat16_add a4(w2, y, w4);
    Bfloat16_add a5(w3, num7, w5);
    Bfloat16_add a6(w4, num5, w6);
    Bfloat16_mul m7(w5, w5, w7);
    Bfloat16_mul m8(w6, w6, w8);
    Bfloat16_add a9(w7, w8, out);
    
endmodule