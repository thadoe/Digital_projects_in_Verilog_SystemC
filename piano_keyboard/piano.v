`timescale 1ns / 1ps
//Vitual keyboard that can play 16 notes to output speaker 

module piano(
    input wire [3:0]note,
    input wire hush,
    input wire clk,
    output wire speaker
    );
    
    reg  [17:0] half_period;
    reg [17:0] counter;
    reg spkr = 0;
    
    assign speaker = spkr;

    always @(posedge clk) begin    // PWM to create output waveform based on specified clock period 
        if ((counter == half_period)&&(hush==0)) begin
            counter <= 0;
            spkr <= ~spkr;
        end else begin
            counter <= counter + 1;
        end
    end
 
//mux for frequencies
//refer to the attached table for frequency values of each note
    always @(*) begin 
        case (note)
            4'h0: half_period <= 113635;
            4'h1: half_period <= 107257;
            4'h2: half_period <= 101237;
            4'h3: half_period <= 95555;
            4'h4: half_period <= 90192;
            4'h5: half_period <= 85130;
            4'h6: half_period <= 80352;
            4'h7: half_period <= 75842;
            4'h8: half_period <= 71585;
            4'h9: half_period <= 67568;
            4'hA: half_period <= 63775;
            4'hB: half_period <= 60196;
            4'hC: half_period <= 56817;
            4'hD: half_period <= 53628;
            4'hE: half_period <= 50618;
            4'hF: half_period <= 47777;
        endcase
    end
 
    
endmodule
