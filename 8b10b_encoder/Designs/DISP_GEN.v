`timescale 1ns / 1ps

module DISP_GEN(
    input               i_rdisp,              // current running disparity  
    output reg          o_rdisp = 0,         // disparity for next code group
    input       [9:0]   i_stream,
    output              o_state,
    input               clk
    );
    
   integer i;
   reg [3:0] o_count;
   integer curr_disp;           // disparity of generated 10 bits (signed)
    
    //calculate current disparity 
    always @(i_stream or i_rdisp ) begin
        o_count = 0;
        for(i =0; i<10 ; i = i + 1 )
            o_count = o_count + i_stream[i];
         curr_disp = o_count - (10 - o_count);
    end 
    
    // runnin disparity state machine
    localparam RD_minus = 1'b0, RD_plus= 1'b1;
    reg state = RD_minus;
    
    always @(curr_disp or posedge clk) begin
        state = i_rdisp;
        case(state)
            RD_minus: begin

                if (curr_disp == 0)
                    state = RD_minus;
                 else 
                    state = RD_plus;
            end
            RD_plus: begin
                
                if (curr_disp == 0)
                    state = RD_plus;
                else 
                    state = RD_minus;
            end
           
 
        endcase 
    end
    
    // output logic 
    always @ (state) begin
        if (state == RD_minus)
            o_rdisp <= 1'b0;
        else
            o_rdisp <= 1'b1;
    end 

    assign o_state = state;
    
endmodule
