`timescale 1ns / 1ps

// FIFOs are used for many operations such as crossing clock domains, buffering and aligning data 
// This is a modified hardware implementation of FIFO design by Faraz Khan 
// please visit // www.simplefpga.blogspot.com for full description 
// Revised design source and constraints to work with Blakboard FPGA 


module FIFO # (parameter abit= 3, dbit = 3)(
    input clk,
    input rst,
    input read,
    input write,
    input [dbit-1: 0] din,
    output [dbit-1: 0] dout,
    output empty,
    output full
    );

reg [dbit-1: 0] r_din;
reg [dbit-1: 0] r_dout;
reg msmv1wr ;
reg msmv2wr ; 
reg msmv1rd ;
reg msmv2rd ; 
wire r_wr, r_rd;
reg r_empty, r_full, r_full_next, r_empty_next;
reg [dbit-1: 0]memarray [2**abit-1 :0];                           // 8 bits depth 3 bits width  
reg [abit-1: 0]wr_ptr, rd_ptr, wr_ptr_next, rd_ptr_next; 
reg [abit-1: 0] wr_ptr_buffer, rd_ptr_buffer;                         // address pointers 
// since rd_ptr_next or wr_ptr_next cannot be changed and campared in same cycle...add buffer stages

always @ (posedge clk) r_din<= din;
assign dout = r_dout;
assign empty = r_empty;                                          // empty flag 
assign full = r_full;                                            // full flag 

always @ (posedge clk)  msmv1wr <= write;   
always @ (posedge clk) msmv2wr <= msmv1wr;
assign r_wr = msmv2wr & ~msmv1wr;                               //to detect the one cycle pulse of write upon negative edge of input

always @ (posedge clk)  msmv1rd <= read; 
always @ (posedge clk) msmv2rd <= msmv1rd;
assign r_rd = msmv2rd & ~msmv1rd;                               //to detect the one cycle pulse of read

always @ (posedge clk) begin                                    // write operation
    if (r_wr & ~r_full)
        memarray [wr_ptr] <= r_din;
        end 
        
always @ (posedge clk) begin                                    // read operation
    if (r_rd)                                                   // cannot include ~r_empty since it conflict with r_empty instantiation
        r_dout <= memarray [rd_ptr];
        end 

always @ (posedge clk)                                        
    if (rst) begin
     rd_ptr <= 1'b0;
     wr_ptr <= 1'b0;
     r_full <= 1'b0;
     r_empty <= 1'b1;
     
     //r_dout <= 1'b0;
     end
    
    else begin
     rd_ptr <= rd_ptr_next;
     wr_ptr <= wr_ptr_next;
     r_full <= r_full_next;
     r_empty <=  r_empty_next; end 
        
        
always @ (*) begin                                           
   wr_ptr_buffer <= wr_ptr + 1;
   rd_ptr_buffer <= rd_ptr + 1;
   rd_ptr_next <= rd_ptr;
   wr_ptr_next <= wr_ptr;
   r_full_next <= r_full;
   r_empty_next <= r_empty;
   
    case({r_wr, r_rd})
        2'b01:  
            if (~empty) begin 
                rd_ptr_next <=  rd_ptr_buffer;
                r_full_next <= 1'b0;
                if (rd_ptr_buffer == wr_ptr)
                    r_empty_next <= 1'b1; end
         2'b10:  
               if (~full) begin 
                   wr_ptr_next <= wr_ptr_buffer;
                   r_empty_next <= 1'b0;
                   if (wr_ptr_buffer == rd_ptr)
                      r_full_next <= 1'b1; end
                    
          2'b11: begin 
                   wr_ptr_next <= wr_ptr_buffer;
                   rd_ptr_next <= rd_ptr_buffer; end
     endcase              
end 
       

endmodule
