`timescale 1ns / 1ps

module Float_Pt_Mul(
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
    
    //------------------------STAGE 1---------------------------- 
    wire [4:0] added_E91;     
    wire sign91;

    assign  added_E91 = E191 + E291 - 15;  
    assign sign91  = S191^S291; 
    
    reg [4:0] r1_E91;
    reg [10:0] r1_M191, r1_M291;
    reg r1_sign91;
    
    always @ (posedge clk) begin            // first pipeline
        r1_E91    <=  added_E91;
        r1_M191   <=  {1'b1,M191};          // concat 1 hidden bit
        r1_M291   <=  {1'b1,M291};
        r1_sign91 <=  sign91;    
    end 
    
    //------------------------STAGE 2---------------------------- 
    wire [21:0] ip_out91; 
    // (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved
    mult_gen_0 xilinx_mul (
        .CLK(clk),                  // input wire CLK
        .A(r1_M191),                // input wire [10 : 0] A
        .B(r1_M291),                // input wire [10 : 0] B
        .P(ip_out91)                // output wire [21 : 0] P
        );
        
    reg [4:0] r2_E;
    reg [11:0]r2_P;
    reg r2_sign;
    wire [11:0] ip_out_r;
    assign ip_out_r = ip_out91 [21:10];
    always @ (posedge clk) begin            // second pipeline
        r2_P    <=  ip_out91 [21:10];       // just a test.. not required 
        r2_E    <=  r1_E91; 
        r2_sign <=  r1_sign91; 
        end 
     //------------------------STAGE 2----------------------------    
     // Binary tree for detecting leading zeros 
     wire [1:0] sum_10_9;
     wire [1:0] sum_8_7;
     wire [1:0] sum_6_5;
     wire [1:0] sum_4_3;
     wire [1:0] sum_2_1;
     wire [1:0] LSB;
     assign sum_10_9   =    (ip_out_r[11:10]==00)?2'b10:(ip_out_r[11:10]==01)?2'b01:2'b00;  // Encode 
     assign sum_8_7    =    (ip_out_r[9:8]==00)?2'b10:(ip_out_r[9:8]==01)?2'b01:2'b00;      // Encode 
     assign sum_6_5    =    (ip_out_r[7:6]==00)?2'b10:(ip_out_r[7:6]==01)?2'b01:2'b00;      // Encode 
     assign sum_4_3    =    (ip_out_r[5:4]==00)?2'b10:(ip_out_r[5:4]==01)?2'b01:2'b00;      // Encode 
     assign sum_2_1    =    (ip_out_r[3:2]==00)?2'b10:(ip_out_r[3:2]==01)?2'b01:2'b00;      // Encode 
     assign LSB        =    (ip_out_r[1:0]==00)? 2'b10:(ip_out_r[1:0]==01)?2'b01:2'b00;     // Encode 
     wire [2:0] q_10_7;
     LZ LZ1 ( .clk(clk), .d({sum_10_9, sum_8_7 }), .q(q_10_7));     //Assemble
     wire [2:0] q_6_3;
     LZ LZ2 ( .clk(clk), .d({sum_6_5, sum_4_3 }), .q(q_6_3));       //Assemble
     wire [2:0] q_2_1;
     LZ LZ3 ( .clk(clk), .d({sum_2_1, LSB}), .q(q_2_1));            //Assemble   
     wire [3:0] q_10_3;
     LZ LZ4 ( .clk(clk), .d({q_10_7, q_6_3}), .q(q_10_3));          //Assemble    
     defparam LZ4.N = 3;
     wire [3:0] q_2_0;
     LZ LZ5 ( .clk(clk), .d({q_2_1, 3'b000}), .q(q_2_0));           //Assemble     
     defparam LZ5.N = 3;
     wire [4:0] LZ;
     LZ LZ6 ( .clk(clk), .d({q_10_3, q_2_0}), .q(LZ));              //Assemble
     defparam LZ6.N = 4;
     // End of binary tree 
     
      reg [9:0] algn_M;
      reg [4:0] algn_E;
      reg G, R, Sy;                  // Guard, Round, Sticky 
      reg r3_sign;
      
      always @ (posedge clk) begin   // third pipiline + shifting 
        r3_sign <=r2_sign;
        if (LZ == 0 || LZ == 1) begin
            if (ip_out91 [21:20] == 2'b10) begin
               algn_M <= ip_out91[19:10] >> 1; 
               algn_E <= r2_E [4:0]+1;
             
            end else if (ip_out91 [21:20] == 2'b11) begin
               algn_M <= (ip_out91[19:10] >> 1)+ 10'b1000000000; 
               algn_E <= r2_E [4:0]+1;
            
             end else begin
                algn_M <= ip_out91[19:10];
                algn_E <= r2_E [4:0];
            end
       end else begin
            algn_M <= ip_out91[19:10] << (LZ+1);
            algn_E <= r2_E [4:0] - LZ-1;
         end  
           {G,R} <= ip_out91 [9:8];
              Sy    <= |ip_out91 [7:0];
     end 
     //------------------------STAGE 3----------------------------    
      reg round_up;  // flag to round up 
   // Guard/ Round/ Sticky
   always @ (*) begin
    casex({G,R,Sy}) 
        3'b0xx:  round_up = 1'b0;
        3'b100:  round_up = (algn_M [0])?1'b1: 1'b0;
        3'b101:  round_up = 1'b1;
        3'b110:  round_up = 1'b1;
        3'b111:  round_up = 1'b1;
     endcase
    end   
    
    reg cout;
    reg [9:0]algn_2M;
    
    always @(*) begin
        S91 = r3_sign; 
        if (round_up)begin
           {cout, algn_2M}  = algn_M + 1'b1;
           if (cout == 1 ) begin
              M91 = algn_M >> 1;
              E91 = algn_E + 1;
            end else begin  
             M91 = algn_M;
             E91 = algn_E;
            end
       end else begin
            M91 = algn_M;  // no rounding needed
            E91 = algn_E;
        end
    end 
