`timescale 1ns / 1ps

// Flip Flag generator module

module FLAG_GEN(
    input [2:0] i_y,
    input [4:0] i_x,
    input clk,
    output reg flip = 0
    );
    always @ (i_y or i_x) begin
      if (i_y == 0 || i_y == 3 || i_y == 4 || i_y ==7) begin 
          flip = (i_x == 3) | (i_x == 5) | (i_x == 6) | (i_x == 7) 
                  | (i_x == 9) | (i_x == 10) | (i_x == 11) | (i_x == 12) | (i_x == 13)
                  | (i_x == 14) | (i_x == 17) | (i_x == 18) | (i_x == 19) | (i_x == 20)
                  | (i_x == 21) | (i_x == 22) | (i_x == 25) | (i_x == 26) | (i_x == 28);
       end else 
                flip = 0;
    end    
endmodule
