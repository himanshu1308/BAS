module twin_lfsr(input clk, input reset, input [8:0]seed1, input [8:0]seed2, output [15:0]n1, output [15:0]n2);
    reg [8:0]N1, N2;
    
    always @(posedge clk)
    begin
        if(reset)
        begin
            N1 <= seed1;
            N2 <= seed2;
        end
        
        else 
        begin
            N1[8] <= N1[7];             N2[8] <= N2[7];
            N1[7] <= N1[6];             N2[7] <= N2[6];
            N1[6] <= N1[5]^N1[8];       N2[6] <= N2[5]^N2[8];
            N1[5] <= N1[8];             N2[5] <= N2[8];
            
            N1[4] <= N1[0];             N2[4] <= N2[0];
            N1[3] <= N1[4];             N2[3] <= N2[4];
            N1[2] <= N1[3]^N1[0];       N2[2] <= N2[3]^N2[0];
            N1[1] <= N1[2];             N2[1] <= N2[2];
            N1[0] <= N1[1];             N2[0] <= N2[1];
        end
    end
    
    assign n1 = {N1[8], 5'b01111, N1[7], 1'b1, 1'b0, N1[6:0]};
    assign n2 = {N2[8], 5'b01111, N2[7], 1'b1, 1'b0, N2[6:0]};
endmodule