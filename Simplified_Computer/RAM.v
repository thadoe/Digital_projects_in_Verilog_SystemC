`timescale 1ns / 1ps


module RAM(
    input wire clk,
    input wire [7:0] addr,
    input wire [15:0] din,
    input wire write,
    output wire [15:0] dout
    );
    
    // 16x 256 mem array
    reg [15:0] mem [0:255];
    
    // write operation 
    always @ (posedge clk) begin
        if (write)
            mem [addr]  <= din;
    end 
    
    // read operation
    assign  dout = mem [addr];
    
endmodule
