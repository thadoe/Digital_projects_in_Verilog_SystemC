// Thadoe Swan Yi   ID:012560691 
`timescale 1ns / 1ps
module Float_Pt_Addr(
    input clk,
    input S191,
    input S291,
    input [4:0] E191,
    input [4:0] E291,
    input [9:0] M191,
    input [9:0] M291,
    output reg S91,
    output reg [4:0] E91,
    output reg [9:0] M91
    );
    
    localparam [4:0] bias = 5'b01111;    // bias = 15 
           
    reg [4:0] algn;                     // alignment amount 
    reg E1_G , E2_G ;                   // greater flags
    wire sign_diff;                
    
    assign sign_diff = (S191 == S291)? 0:1;
    
    //------------------------STAGE 1---------------------------- 
     always@ (posedge clk) begin   
        if ( E191 == E291) begin    
            algn = 4'b0000;
            {E1_G, E2_G} = 2'b00;      // same exponent 
        end else if (E191 > E291) begin 
            algn = E191-E291;           
            {E1_G, E2_G} = 2'b10;      // E1 is greater 
        end else begin
            algn = E291-E191;
            {E1_G, E2_G} = 2'b01;      // E2 is greater 
         end      
     end
  
     reg r1_E1_G, r1_E2_G;              // pipilne regs 
     reg [4:0] r1_algn;  
     reg [4:0] r1_E1, r1_E2;           
     reg [9:0] r1_M1, r1_M2;  
     reg r1_sign_diff;
     reg [9:0] offset;
     reg [1:0] r1_sign;
    
     always@ (posedge clk) begin        // first pipeline
        r1_E1_G <= E1_G;
        r1_E2_G <= E2_G;
        r1_algn <= algn;
        r1_E1 <= E191;
        r1_E2 <= E291;
        r1_M1 <= M191;
        r1_M2 <= M291;
        r1_sign_diff<= sign_diff;
        offset <= 2**(10-algn);         // offset calculate value need to add to shifted mantissa to include hidden bit
        r1_sign <= {S291,S191};      
     end
    
    //------------------------STAGE 2---------------------------- 
     wire [4:0] algn_E1, algn_E2;
     wire [10:0] algn_M1, algn_M2;
     assign algn_M2 = (r1_E1_G && ~r1_E2_G)? (r1_M2 >> r1_algn) + offset : {1'b1,r1_M2}; // if E1 is greater, shift M2 
     assign algn_M1 = (r1_E2_G && ~r1_E1_G)? (r1_M1 >> r1_algn) + offset : {1'b1,r1_M1}; // if E2 is greater, shift M1
     assign algn_E1 = (r1_E1_G && ~r1_E2_G)?  r1_E1  : r1_E2; 
     assign algn_E2 = (r1_E2_G && ~r1_E1_G)?  r1_E2  : r1_E1;
     
     reg [4:0] r2_algn_E1, r2_algn_E2; // pipilne regs 
     reg [4:0] r2_algn;
     reg [10:0] r2_algn_M2, r2_algn_M1;
     reg r2_sign_diff;
     reg [1:0]r2_sign;
     
      always@ (posedge clk) begin  // second pipeline
        r2_algn_M2      <= algn_M2;
        r2_algn_M1      <= algn_M1;
        r2_algn         <= r1_algn;
        r2_sign_diff    <= r1_sign_diff;
        r2_algn_E1      <= algn_E1;
        r2_algn_E2      <= algn_E2;
        r2_sign         <= r1_sign;
      end
     
     //------------------------STAGE 3---------------------------- 
     reg [10:0] opp1, opp2;                                                                                 
     wire [4:0] w_E;
     wire sign;
  
     always@ (*) begin 
        if (r2_sign_diff == 1) begin
            if (r2_algn_M2 >= r2_algn_M1) begin
                opp1 = ~r2_algn_M1 + 10'b0000000001;
                opp2 = r2_algn_M2;
            end else begin
                opp2 = ~r2_algn_M2 + 10'b0000000001;
                opp1 = r2_algn_M1;
            end
        end else begin
            opp1 = r2_algn_M1;
            opp2 = r2_algn_M2;
        end  
     end 
     
     assign w_E = ( r2_algn_E1 ==  r2_algn_E2)? r2_algn_E1: 1'b0;                                           // 0 is error 
     assign sign = (~r2_sign_diff)? r2_sign[1] : (r2_algn_M2 > r2_algn_M1)? r2_sign[1] : r2_sign[0];        // sign logic 
     
     reg [10:0] r3_opp1, r3_opp2;
     reg cin;
     wire [11:0] sum;   // 12 bit sum 
     wire cout, ovfl;
     reg [4:0] r3_E; 
     reg [4:0] r3_algn;
     reg r3_sign;
     reg r3_sign_diff;
     
     always@ (posedge clk) begin  // Third pipeline
         r3_opp1<= opp1;
         r3_opp2<= opp2;
         r3_E <= w_E;
         r3_algn<=r2_algn;
         r3_sign <= sign;
         r3_sign_diff<= r2_sign_diff;
     end
     
     //------------------------STAGE 4---------------------------- 
     
     adder addr(.op1(r3_opp1), .op2(r3_opp2),.cin(1'b0),.sum(sum));
     defparam addr.BUS_WIDTH = 11;
     
     wire [1:0] sum_10_9;
     wire [1:0] sum_8_7;
     wire [1:0] sum_6_5;
     wire [1:0] sum_4_3;
     wire [1:0] sum_2_1;
     wire [1:0] LSB;
          
     assign sum_10_9   =    (sum[9:8]==00)?2'b10:(sum[9:8]==01)?2'b01:2'b00;     // binary tree for detecting leading zero
     assign sum_8_7    =    (sum[7:6]==00)?2'b10:(sum[7:6]==01)?2'b01:2'b00;
     assign sum_6_5    =    (sum[5:4]==00)?2'b10:(sum[5:4]==01)?2'b01:2'b00;
     assign sum_4_3    =    (sum[3:2]==00)?2'b10:(sum[3:2]==01)?2'b01:2'b00;
     assign sum_2_1    =    (sum[1:0]==00)?2'b10:(sum[1:0]==01)?2'b01:2'b00;
     //assign LSB        =    (sum[1:0]==0)? 2'b01:(sum[3:2]==01)?2'b01:2'b00;
     wire [2:0] q_10_7;
     LZ LZ1 ( .clk(clk), .d({sum_10_9, sum_8_7 }), .q(q_10_7));
     
     wire [2:0] q_6_3;
     LZ LZ2 ( .clk(clk), .d({sum_6_5, sum_4_3 }), .q(q_6_3));
    
     wire [2:0] q_2_1;
     LZ LZ3 ( .clk(clk), .d({sum_2_1, 2'b00}), .q(q_2_1));       

     wire [3:0] q_10_3;
     LZ LZ4 ( .clk(clk), .d({q_10_7, q_6_3}), .q(q_10_3));     
     defparam LZ4.N = 3;
     
     wire [3:0] q_2_0;
     LZ LZ5 ( .clk(clk), .d({q_2_1, 3'b000}), .q(q_2_0));       
     defparam LZ5.N = 3;
    
     wire [4:0] LZ;
     LZ LZ6 ( .clk(clk), .d({q_10_3, q_2_0}), .q(LZ));
     defparam LZ6.N = 4;
     
     reg underflow =0;                             // Exception flags 
     reg overflow = 0;
     reg NaN = 0;
     reg infinity = 0;
     
     always @ (posedge clk) begin  
        S91 <= r3_sign;
         if (r3_sign_diff) begin
            if (sum[11:10] == 2'b11 || sum[11:10] == 2'b01 ) begin
                M91 <= sum[9:0];
                E91 <= r3_E; 
            end else begin
                M91 <= sum[9:0] << LZ+1;    
                E91 <= r3_E - (LZ + 1);              
                underflow <= (E91 < 1)? 1'b1: 1'b0;
            end 
         end else
                if (sum[11:10] == 2'b01 ) begin
                    M91 <= sum[9:0];
                    E91 <= r3_E; 
                end else if (sum[11:10] == 2'b11) begin
                    M91 <=  (sum[9:0] >> 1) + 10'b1000000000;
                    E91 <= r3_E+1;
                    overflow <= (E91 > 254)? 1'b1: 1'b0;
                end else if (sum[11:10] == 2'b10) begin
                    M91 <=  sum[9:0] >> 1;
                    E91 <= r3_E+1;
                    overflow <= (E91 > 254)? 1'b1: 1'b0;       
                end else begin
                    M91 <= sum[9:0] << LZ+1;    
                    E91 <= r3_E - (LZ + 1);             
                    underflow <= (E91 < 1)? 1'b1: 1'b0;
            end 
    end 
        
        always @(*) begin
            if (r3_E == 255 && r3_opp1 == 0 && r3_opp2 == 0) begin
                if (r3_sign_diff == 1'b1 )
                    NaN = 1'b1;
                 else 
                    infinity = 1'b1;
            end 
         end
    endmodule
