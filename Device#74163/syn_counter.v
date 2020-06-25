`timescale 1ns/1ps 

// Verilog model of device #74163, a synchronus counter
// Tested and synthesised on Vivado 2020.1 

module syn_counter # (parameter [7:0] count_in = 1 )(
    input wire clk,                                 // 100 MHz clock 
    input wire Ep,                                   
    input wire Et,                                  
    input wire CLEAR,                               // Active_low
    input wire LOAD,                                // Active_low
    input wire [3:0] i_preset,                      //  A , B , C, D
    output wire [3:0] o_Q,                          //  QA , QB, QC, QD
    output wire RCO
);

wire enable;
reg [3:0] Q;
reg[15:0]counter=0;

assign o_Q = Q;
assign RCO = Q[0] & Q[1] & Q[2] & Q[3] & Et;        // RCO = ripple carry output 
assign enable = Ep & Et; 
     
always @(posedge clk) begin
    if (~CLEAR) 
        Q = 4'b0000;
    else begin
        if (~LOAD) 
            Q = i_preset;
         else begin
            if (enable) begin
                     if(counter == 999) begin       // counter period is 10000ns (Arbitrary) 
                        counter = 0;
                        Q = Q +1; 
                      end
                      else 
                       counter = counter + count_in;  
            end
            else 
                     Q = Q;
          end
     end
end                            
endmodule 
