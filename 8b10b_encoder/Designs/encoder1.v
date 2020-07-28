`timescale 1ns / 1ps

module encoder1(
  input           clk,
  input   [7:0]  i_data ,
  input 	       i_rdisp ,        //running disparity: RD- = 0,  RD+ = 1
  output  [9:0]  o_en_data,
  output	       o_rdisp,
  input          kin             // char type control:  1=contorl 0=data 
   );
   
reg [2:0] i_y;
reg [4:0] i_x;
wire [5:0] o_6MSB;
wire [3:0] o_4LSB;
wire flip;
reg disp_reg = 0, kin_reg;
wire o_state;

always @ (posedge clk) begin
    i_y      <= i_data [7:5];
    i_x     <= i_data [4:0];
    kin_reg     <= kin;
    disp_reg    <= i_rdisp ;  
end

//Flip Flag Generator 
FLAG_GEN flip_flag(
    .i_y(i_y),
    .i_x(i_x),
    .clk(clk),
    .flip(flip)
    );


//3b/4b encoding table 
LUT_3_4 LUT34 (
    .clk(clk),
    .i_y(i_y),
    .o_data (o_4LSB),
    .i_disp (disp_reg),
    .kin (kin_reg),
    .i_x(i_x),
    .flip(flip),
    .o_state(o_state)    
    );

//5b/6b encoding table
LUT_5_6 LUT56 (
    .clk(clk),
    .i_x(i_x),
    .o_data(o_6MSB),
    .i_disp(disp_reg),
    .i_y (i_y),
    .kin(kin) 
    );


//Running Disparity Generator
DISP_GEN generator(
   .i_rdisp(disp_reg),
   .o_rdisp(o_rdisp),
   .i_stream(o_en_data),
   .o_state (o_state),
   .clk(clk)
    );

 //Concatenation for encoded code group 
assign o_en_data = {o_6MSB,o_4LSB}; 

endmodule
