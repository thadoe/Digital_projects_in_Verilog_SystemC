`timescale 1ns / 1ps

module half_adder (
    input wire i_A,
    input wire i_B,
    output wire o_sum,
    output wire o_carry
);

assign o_sum = i_A ^ i_B;
assign o_carry = i_A & i_B;

endmodule 
