// Top level module
// Given by the project instructor  

`timescale 1 ns / 1 ps

module narrator (
  input  wire        clk,
  output wire        speaker
  );
  // Create a test circuit to exercise the chatter
  // module, rather than using switches and a
  // button.
  
  reg   [9:0] counter = 0;
  reg   [6:0] data;
  wire        write;
  wire        busy;

  always @(posedge clk) if (!busy) counter <= counter + 1;
  
  always @*
  begin
    case (counter[9:2])      // data corresopnds to addresses in ROM which store sampled Phonemes
      0: data = 6'h1d;       // change the sequence to output any speech (refer to chatter.v) 
      1: data = 6'h3b;
      2: data = 6'h21;
      3: data = 6'h35;
      default: data = 6'h02;
    endcase
  end

  assign write = (counter[1:0] == 2'b00);
  
  // Instantiate the chatter module, which is
  // driven by the test circuit.
  
  chatter chatter_inst (
    .data(data),
    .write(write),
    .busy(busy),
    .clk(clk),
    .speaker(speaker)
  );

endmodule
