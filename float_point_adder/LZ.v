`timescale 1ns / 1ps

//leading zeros counter

module LZ #
(
   parameter   N = 2,
   parameter   WI = 2 * N,
   parameter   WO = N + 1
)(
   input clk,
   input wire     [WI-1:0]    d,
   output reg  [WO-1:0]    q
    );
    
   always@(*) begin
      if (d[N - 1 + N] == 1'b0) begin
         q[WO-1] = (d[N-1+N] & d[N-1]);
         q[WO-2] = 1'b0;
         q[WO-3:0] = d[(2*N)-2 : N];
      end else begin
         q[WO-1] = d[N-1+N] & d[N-1];
         q[WO-2] = ~d[N-1];
         q[WO-3:0] = d[N-2 : 0];
      end
   end
   


endmodule 
