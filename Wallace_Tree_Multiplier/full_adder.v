`timescale 1ns / 1ps

module full_adder(
    input wire i_A,
    input wire i_B,
    input wire i_C,
    output wire o_sum,
    output wire o_carry
    );
    
    //internal nets
    wire h1_sum,h2_sum, h1_carry, h2_carry;
    
    half_adder h1 (
        .i_A (i_A),
        .i_B (i_B),
        .o_sum (h1_sum),
        .o_carry (h1_carry)
    );
    
     half_adder h2 (
        .i_A (h1_sum),
        .i_B (i_C),
        .o_sum (h2_sum),
        .o_carry (h2_carry)
    );
    
    assign o_carry = h1_carry | h2_carry;
    assign o_sum = h2_sum;
      
    
endmodule
