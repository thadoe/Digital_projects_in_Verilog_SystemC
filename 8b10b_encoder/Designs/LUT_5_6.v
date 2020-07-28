`timescale 1ns / 1ps

//5 bits to 6 bits Encoding Table 

module LUT_5_6(
    input clk,
    input [4:0] i_x,        //  EDCBA
    output [5:0] o_data,    //  abcdei
    input 	    i_disp,
    input [2:0] i_y, 
    input kin
    );
    reg [5:0] o_data_reg;
    assign o_data = o_data_reg;
    
    always @ (i_x) begin 
         if (kin == 0) begin
            casez({i_x,i_disp})
                6'b000000: o_data_reg <= 6'b100111;       //D.00
                6'b000001: o_data_reg <= 6'b011000;       
                6'b000010: o_data_reg <= 6'b011101;       //D.01       
                6'b000011: o_data_reg <= 6'b100010;       
                6'b000100: o_data_reg <= 6'b101101;       //D.02
                6'b000101: o_data_reg <= 6'b010010;       
                6'b00011?: o_data_reg <= 6'b110001;       //D.03
                6'b001000: o_data_reg <= 6'b110101;       //D.04
                6'b001001: o_data_reg <= 6'b001010;
                6'b00101?: o_data_reg <= 6'b101001;       //D.05
                6'b00110?: o_data_reg <= 6'b011001;       //D.06
                6'b001110: o_data_reg <= 6'b111000;       //D.07
                6'b001111: o_data_reg <= 6'b000111;
                6'b010000: o_data_reg <= 6'b111001;       //D.08
                6'b010001: o_data_reg <= 6'b000110;       
                6'b01001?: o_data_reg <= 6'b100101;       //D.09
                6'b01010?: o_data_reg <= 6'b010101;       //D.10
                6'b01011?: o_data_reg <= 6'b110100;       //D.11
                6'b01100?: o_data_reg <= 6'b001101;       //D.12
                6'b01101?: o_data_reg <= 6'b101100;       //D.13
                6'b01110?: o_data_reg <= 6'b011100;       //D.14
                6'b011110: o_data_reg <= 6'b010111;       //D.15
                6'b011111: o_data_reg <= 6'b101000;
                6'b100000: o_data_reg <= 6'b011011;       //D.16
                6'b100001: o_data_reg <= 6'b100100;
                6'b10001?: o_data_reg <= 6'b100011;        //D.17
                6'b10010?: o_data_reg <= 6'b010011;        //D.18 
                6'b10011?: o_data_reg <= 6'b110010;        //D.19
                6'b10100?: o_data_reg <= 6'b001011;        //D.20
                6'b10101?: o_data_reg <= 6'b101010;        //D.21
                6'b10110?: o_data_reg <= 6'b011010;        //D.22
                6'b101110: o_data_reg <= 6'b111010;        //D.23
                6'b101111: o_data_reg <= 6'b000101;        
                6'b110000: o_data_reg <= 6'b110011;        //D.24
                6'b110001: o_data_reg <= 6'b001100;
                6'b11001?: o_data_reg <= 6'b100110;        //D.25
                6'b11010?: o_data_reg <= 6'b010110;        //D.26
                6'b110110: o_data_reg <= 6'b110110;        //D.27
                6'b110111: o_data_reg <= 6'b001001;
                6'b11100?: o_data_reg <= 6'b001110;        //D.28
                6'b111010: o_data_reg <= 6'b101110;        //D.29
                6'b111011: o_data_reg <= 6'b010001;        
                6'b111100: o_data_reg <= 6'b011110;        //D.30
                6'b111101: o_data_reg <= 6'b100001;
                6'b111110: o_data_reg <= 6'b101011;        //D.31 
                6'b111111: o_data_reg <= 6'b010100;
                default: o_data_reg <= 6'b000111; //some balance stream   
            endcase     
         end else begin
            case({i_x,i_disp})
                6'b111000: o_data_reg <= 6'b001111;         //K.28
                6'b111001: o_data_reg <= 6'b110000;
                6'b101110: o_data_reg <= 6'b111010;         //K.23
                6'b101111: o_data_reg <= 6'b000101;
                6'b110110: o_data_reg <= 6'b110110;         //K.27 
                6'b110111: o_data_reg <= 6'b001001;
                6'b111010: o_data_reg <= 6'b101110;         //K.29
                6'b111011: o_data_reg <= 6'b010001;
                6'b111100: o_data_reg <= 6'b011110;         //K.30
                6'b111101: o_data_reg <= 6'b100001;
                default: o_data_reg <= 6'b000111;
            endcase 
         end 
    
 end    
    
endmodule
