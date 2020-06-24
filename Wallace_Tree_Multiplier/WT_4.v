`timescale 1ns / 1ps

module WT_4(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [7:0] product
   
    );
    
// result of partial products 
wire [3:0] row0,row1,row2,row3;         

assign row0 = A & {4{B[0]}};        
assign row1 = A & {4{B[1]}}; 
assign row2 = A & {4{B[2]}}; 
assign row3 = A & {4{B[3]}}; 

// internal nets 
wire S_h1 , S_f1, S_f2, S_h2, S_h3, S_f3, S_f4, S_f5, S_h4, S_f6, S_f7, S_f8 ;
wire C_h1, C_f1, C_f2, C_h2, C_h3, C_f3, C_f4, C_f5, C_h4, C_f6, C_f7, C_f8;

// Stage 1 
half_adder h1 ( row0[1], row1[0], S_h1, C_h1 );
full_adder f1 ( row0[2], row1[1], row2[0], S_f1, C_f1 );
full_adder f2 ( row0[3], row1[2], row2[1], S_f2, C_f2 );
half_adder h2  ( row1[3], row2[2], S_h2, C_h2 );

// Stage 2 
half_adder h3 ( S_f1, C_h1, S_h3, C_h3 );
full_adder f3 ( S_f2, C_f1, row3[0], S_f3, C_f3 );
full_adder f4 ( S_h2, C_f2, row3[1], S_f4, C_f4 );
full_adder f5 ( row2[3], C_h2, row3[2], S_f5, C_f5 );

// final addition
 half_adder h4 ( S_f3, C_h3, S_h4, C_h4 );
 full_adder f6 ( S_f4, C_f3, C_h4, S_f6, C_f6 );
 full_adder f7 ( S_f5, C_f4, C_f6, S_f7, C_f7 );
 full_adder f8 ( row3[3], C_f5, C_f7, S_f8, C_f8 );

// final product 
assign  product[7] = C_f8;
assign  product[6] = S_f8;
assign  product[5] = S_f7;
assign  product[4] = S_f6;
assign  product[3] = S_h4;
assign  product[2] = S_h3;
assign  product[1] = S_h1;
assign  product[0] = row0[0];


endmodule
