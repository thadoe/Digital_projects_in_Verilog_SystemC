
`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.
// This is the converter module to drive speaker 

module dac (
  input  wire  [7:0] sample,
  input  wire        hush,
  output wire        speaker,
  input  wire        clk
  );

  //******************************************************************//
  // Implement the delta-sigma converter.                             //
  //******************************************************************//

  wire  [7:0] unsignedsample;
  wire  [9:0] deltaadder;
  wire  [9:0] sigmaadder;
  wire  [9:0] deltab;
  reg   [9:0] sigma = 1'b1 << 8;

  assign unsignedsample = (hush ? 8'h00 : sample) + 128;
  assign deltab = {sigma[9], sigma[9]} << 8;
  assign sigmaadder = deltaadder + sigma;
  assign deltaadder = unsignedsample + deltab;

  always @(posedge clk) sigma <= sigmaadder;

  assign speaker = sigma[9];

  //******************************************************************//
  //                                                                  //
  //******************************************************************//

endmodule
