`timescale 1ns / 1ps

//signed addition with overflow 

module Full_Addr #(BUS_WIDTH = 3)(
    input [BUS_WIDTH-1 : 0] op1,
    input [BUS_WIDTH-1 : 0] op2,
    input cin,
    output[BUS_WIDTH-1 : 0] sum
    );
    
    wire [BUS_WIDTH:0] ss ;
    assign ss = op1 + op2+ cin;
    assign sum = ss[BUS_WIDTH-1:0];
    assign cout = ss[BUS_WIDTH];
    assign ovfl = ( op1[BUS_WIDTH-1]& op2[BUS_WIDTH-1] & ~sum[BUS_WIDTH-1] ) | (~op1[BUS_WIDTH-1] & ~op2[BUS_WIDTH-1] & sum[BUS_WIDTH-1]);
    // ovrflow condt: when 2 operands have + sign but sum has - sign 
    //or when 2 operands have - sign but sum has + 
endmodule
