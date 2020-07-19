`timescale 1ns / 1ps

// simple D-Flip_Flop 
module DFF(
    input wire clk,
    input wire clk_en,
    input wire D,
    output reg Q = 0
    );
    
    always @(posedge clk) begin 
        if(clk_en)
            Q <= D;
    end
    
endmodule
