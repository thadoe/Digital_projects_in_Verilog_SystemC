`timescale 1ns / 1ps

module delay_timer(
    input wire clk,
    input wire RESET,
    input wire [7:0] i_wb,
    input wire i_TRIG,
    input wire i_A,             // A and B mode select pins 
    input wire i_B,
    output wire o_delay_out     // Active low 
     );

reg [7:0] Pulse_width;
reg [7:0] Delay; 
reg [7:0] Timer=0; 
reg  [1:0] mode= 0; 
reg out = 0, timer_start =0;    
wire TRIG_rise, TRIG_fall;
reg TRIG_DFF1 = 0, TRIG_DFF2 = 0;               
wire rst_fall;
reg rst_DFF1 = 0, rst_DFF2 = 0;
reg rst_timer = 0;                              
reg rst_timer_DFF1= 0, rst_timer_DFF2= 0;
wire timer_clear_DD,timer_clear;

always @ (posedge clk) begin
    TRIG_DFF1 <= i_TRIG;
    TRIG_DFF2 <= TRIG_DFF1;
    rst_DFF1 <= RESET;
    rst_DFF2 <= rst_DFF1;
    rst_timer_DFF1 <= rst_timer;
    rst_timer_DFF2 <= rst_timer_DFF1; 
end 

assign TRIG_rise = ~TRIG_DFF2 & TRIG_DFF1;             
assign TRIG_fall = ~TRIG_DFF1 & TRIG_DFF2;
assign rst_fall = ~rst_DFF1 & rst_DFF2;                     
assign rst_timer_rise = ~rst_timer_DFF2 & rst_timer_DFF1;  

always @ (*) begin  // sample inputs 
        Pulse_width <= i_wb;
        Delay <= (2*i_wb + 1)/2;
        mode <= {i_A, i_B};
end 

always @ (*) begin
    if (RESET) begin
        out <= 0;
        timer_start <= 0;
        rst_timer <= 1;
    end
    else begin
        case (mode)
            2'b00: begin //OS
               if (TRIG_rise == 1) begin
                out <= 1;
                timer_start <= 1; // flag 
                rst_timer <= 0; // pulse 
                end
               else if (Timer >= Pulse_width) begin
                   out <= 0;  
                   timer_start <= 0;  
                   rst_timer <= 1;
               end   
            end
            2'b01: begin //DO
                if ( (rst_fall == 1 && i_TRIG == 1) || TRIG_rise == 1) begin 
                    timer_start <= 1;
                    rst_timer <= 0;
                end
                else if (Timer >= Delay ) begin
                    out <= 1;
                    timer_start <= 0;
                    rst_timer <=1;
                end 
                else if (TRIG_fall == 1 || i_TRIG == 0) begin
                    out <= 0;
                    timer_start <= 0;
                    rst_timer <= 1 ;
                end 
            end
            2'b10: begin  //DR
                if ( i_TRIG ==1 || TRIG_rise == 1)   //(rst_fall ==1 && i_TRIG == 1 ) condition can be omitted 
                    out <= 1;
                else if (TRIG_fall == 1) begin
                    timer_start <= 1;
                    rst_timer <= 0;
                end
                else if (Timer >= Delay) begin
                    out <= 0;
                    timer_start <= 0;
                    rst_timer <= 1;
                end 
            end 
            2'b11: begin //DD
                if ( (rst_fall == 1 && i_TRIG == 1) || TRIG_rise == 1 || TRIG_fall == 1) begin 
                    timer_start <= 1;
                    rst_timer <= 0;
                end
                else if (Timer >= Delay) begin
                     out <= i_TRIG;
                     timer_start <= 0;
                     rst_timer <= 1; 
                end 
            end 
            default: begin 
                    out <= 0;
                    timer_start <= 0;
                    rst_timer <= 1;
            end 
        endcase 
    end
end

assign timer_clear_DD = ((TRIG_rise == 1) | (TRIG_fall == 1)) & (mode == 2'b11);    //auto timer reset for delayed dual mode  
assign  timer_clear = timer_clear_DD | TRIG_rise | rst_timer_rise;                  //rise of rst_timer pulse 

always @(posedge clk or posedge timer_clear) begin
 if(timer_clear)   
      Timer <= 0;  
 else if (timer_start)
      Timer <= Timer + 1;  
end
        
assign o_delay_out = ~out; //active low output 
        
endmodule

// THis is the modified version of verilog model at fpga4student.com. 
// Debugged and revised to result more precise reponse without delay.
