`timescale 1ns / 1ps

//3 bits to 4 bits Encoding Table 

module LUT_3_4(
    input           clk,
    input   [2:0]   i_y,        //  HGF
    output  [3:0]   o_data,     //  fghi
    input 	        i_disp,
    input           kin,
    input   [4:0]   i_x,
    input           flip,
    input           o_state

    );
    
    reg [3:0] o_data_reg;
    assign o_data = kin? o_data_reg: (flip? ~o_data_reg : o_data_reg);
     
    always @ (i_y or o_state) begin 
        casez({kin,i_y,i_disp})
            5'b?0000: o_data_reg <= 4'b0100;       //D.x.0 or K.x.0
            5'b?0001: o_data_reg <= 4'b1011;
            5'b0001?: o_data_reg <= 4'b1001;       //D.x.1
            5'b0010?: o_data_reg <= 4'b0101;       //D.x.2
            5'b?0110: o_data_reg <= 4'b0011;       //D.x.3 or K.x.3
            5'b?0111: o_data_reg <= 4'b1100;
            5'b?1000: o_data_reg <= 4'b0010;       //D.x.4  or K.x.4
            5'b?1001: o_data_reg <= 4'b1101;
            5'b0101?: o_data_reg <= 4'b1010;       //D.x.5
            5'b0110?: o_data_reg <= 4'b0110;       //D.x.6
            5'b01110: o_data_reg <= (i_x == 17)||(i_x == 18) ||(i_x == 20)?4'b1000: 4'b0001;   //D.x.7
            5'b01111: o_data_reg <= (i_x == 11)||(i_x == 13) ||(i_x == 14)?4'b0111: 4'b1110;           
            5'b10010: o_data_reg <= 4'b1001;     //K.x.1
            5'b10011: o_data_reg <= 4'b0110;
            5'b10100: o_data_reg <= 4'b0101;      //K.x.2
            5'b10101: o_data_reg <= 4'b1010;         
            5'b11010: o_data_reg <= 4'b1010;     //K.x.5
            5'b11011: o_data_reg <= 4'b0101;            
            5'b11100: o_data_reg <= 4'b0110;      //K.x.6
            5'b11101: o_data_reg <= 4'b1001;
            5'b11110: o_data_reg <= 4'b1000;       //K.x.7
            5'b11111: o_data_reg <= 4'b0111;           
            default: o_data_reg <= 4'b0011;         // some balance string (could use for invalid input err) 
        endcase
    end    
    
    
endmodule
