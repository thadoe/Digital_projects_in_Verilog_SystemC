`timescale 1ns / 1ps

//Top layer 

module button_debounce #(parameter slow_clk_half_period = 19)(
    input wire button_in,
    input wire clk,  // clk on board is 100Mhz
    output wire button_out
    );
    
reg clk_en = 0;
reg [31:0] counter = 0;
wire Q0 , Q1; 

always @ (posedge clk) begin
    if (counter == slow_clk_half_period) begin    // counter value was intentionally kept low (about 2.5MHz here) for simulation with testbench from 
        clk_en <= 1'b1;                           // https://www.fpga4student.com/2017/04/simple-debouncing-verilog-code-for.html
        counter <= 0;
    end else begin
        clk_en <= 1'b0;
        counter <= counter +1;
    end
end 

DFF DFF0 (
    .clk(clk),
    .clk_en(clk_en),
    .D (button_in),
    .Q (Q0)
);

DFF DFF1 (
    .clk(clk),
    .clk_en(clk_en),
    .D (Q0),
    .Q (Q1)
);

assign button_out = Q0 & (~Q1); 
endmodule
