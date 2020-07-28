`timescale 1ns / 1ps

//simple testbench for writing a specific stream of data 
//does not cover all possible cases

//`define TestDisp

module tb;
  reg clk;
  reg     [7:0]  test_data;
  reg 	         i_rdisp = 0; 
  wire    [9:0]  encoded_data;       //encoded data       
  wire 	         o_rdisp;
  reg            kin;  
 
 //Create the clock signal 
 always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    end
   
  encoder1 DUT(
    .clk(clk),
    .i_data(test_data),
    .i_rdisp(i_rdisp),
    .o_en_data(encoded_data),
    .o_rdisp(o_rdisp),
    .kin(kin)
   );
   
   always @ (o_rdisp) 
        i_rdisp = o_rdisp;
        
   
   initial begin

   kin = 0;
   test_data = 8'b00100011; 
   #20;
   test_data = 8'b00011111;
   #20;
   test_data = 8'b01100000;
   #20;
   test_data = 8'b01000001;
   #20
   kin = 1;
   test_data = 8'b11011100;   
   #20
   kin = 0;
   test_data = 8'b00000011;
   #20;
   kin = 1;
   test_data = 8'b11111110;
   #20;
   kin = 0;
   test_data = 8'b01100011;
   #20;
   kin = 0;
   test_data = 8'b10000011;
   #40
   test_data = 8'b00000011;

   end 

  `ifdef TestDisp     // IGNORE (for testing disp generator module)  
    reg  test_disp = 0;
    wire run_disp;
    reg [9:0] test_data_1;
    
    DISP_GEN UUT(
    .clk(clk),
    .i_rdisp(test_disp),
    .o_rdisp(run_disp),
    .i_stream(test_data)
    );

    initial begin
    #10;
    test_data_1 = 10'b0010101101;
    #10;
    test_disp_1 = run_disp;
    #30;
    test_data_1 = 10'b1111111111;
    #10;
    test_disp_1 = run_disp;
    #30;
    test_data_1 = 10'b0000111111;
    end
   `endif
    
endmodule
