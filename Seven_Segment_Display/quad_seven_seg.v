//this is the design source 

`timescale 1ns / 1ps

//Implemented on Xilinx ZYNQ Soc
// 4x 4 bit inputs will be displayed on the quad seven segment display on board

module quad_seven_seg(
input wire clk,
input wire [3:0] val3,
input wire [3:0] val2,
input wire [3:0] val1,
input wire [3:0] val0,
output wire an3,
output wire an2,
output wire an1,
output wire an0,
output wire caw,
output wire cbw,
output wire ccw,
output wire cdw,
output wire cew,
output wire cfw,
output wire cgw,
output wire dpw 
    );
    
reg ca;
reg cb;
reg cc;
reg cd;
reg ce;
reg cf;
reg cg;
reg dp;
reg [3:0] mux_out;
reg[1:0] step=0;
reg[15:0]counter=0;

//Register Declarations

assign {caw,cbw,ccw,cdw,cew,cfw,cgw,dpw} ={ca,cb,cc,cd,ce,cf,cg,dp};

 always@(posedge clk)
 begin
 case(step)
     0:mux_out=val0;
     1:mux_out=val1;
     2:mux_out=val2;
     3:mux_out=val3;    
     endcase
end

 
 always @ (posedge clk)
 begin
 if (counter==6000) begin
        counter <= 0;
        step <= step + 1; end 
  else counter <= counter + 1;
 end
 


// 2 to 4 Encoder
assign an0 = !(step == 2'b00);
assign an1 = !(step == 2'b01);
assign an2 = !(step == 2'b10);
assign an3 = !(step == 2'b11);
  


// 4 to 7 Decoder
always@(*)
begin
  dp = 1'b1;
 case(mux_out) 
  4'h0 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0000001};
  4'h1 : {ca,cb,cc,cd,ce,cf,cg} = {7'b1001111}; 
  4'h2 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0010010}; 
  4'h3 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0000110}; 
  4'h4 : {ca,cb,cc,cd,ce,cf,cg} = {7'b1001100}; 
  4'h5 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0100100}; 
  4'h6 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0100000}; 
  4'h7 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0001111}; 
  4'h8 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0000000}; 
  4'h9 : {ca,cb,cc,cd,ce,cf,cg} = {7'b0000100};
  4'hA: {ca,cb,cc,cd,ce,cf,cg} = {7'b0001000};
  4'hB: {ca,cb,cc,cd,ce,cf,cg} = {7'b1100000};
  4'hC: {ca,cb,cc,cd,ce,cf,cg} = {7'b0110001};
  4'hD: {ca,cb,cc,cd,ce,cf,cg} = {7'b1000010};
  4'hE: {ca,cb,cc,cd,ce,cf,cg} = {7'b0110000};
  4'hF: {ca,cb,cc,cd,ce,cf,cg} = {7'b0111000};
  
 endcase
end
        
endmodule
