`timescale 1 ns / 1 ps
module chatter (
  input  wire  [5:0] data,
  input  wire        write,
  output wire        busy,
  input  wire        clk,
  output wire        speaker
  );

  //******************************************************************//
  // Create a periodic interval timer.  This will generate a single   //
  // cycle pulse on the output, period_expired, approximately 8000    //
  // times a second, given a 100 MHz clock.                           //
  //******************************************************************//

  reg  [13:0] period_counter = 0;
  wire        period_expired;

  always @(posedge clk)
  begin
    if (period_expired) period_counter <= 0;
    else period_counter <= period_counter + 1;
  end

  assign period_expired = (period_counter == 14'd12499);

  //******************************************************************//
  // Create an 8-bit data holding register and a data arrived strobe. //
  //******************************************************************//

  reg   [5:0] data_register = 0;
  reg         data_arrived = 0;

  always @(posedge clk)
  begin
    if (write) data_register <= data;
    data_arrived <= write;
  end

  //******************************************************************//
  // Implement the loadable data pointer with increment capability    //
  // as well as the ending pointer value for the current waveform.    //
  //******************************************************************//

  reg  [15:0] pointer = 0;
  reg  [15:0] end_val = 0;
  reg         hush = 1;
  wire        load_ptrs;
  wire        increment;
  wire        val_match;

  always @(posedge clk)
  begin
	if (load_ptrs)
	begin
	  case (data_register)
        6'h00:   {hush,pointer,end_val} <= {1'b1, 16'd0    , 16'd72   }; // PA1
        6'h01:   {hush,pointer,end_val} <= {1'b1, 16'd0    , 16'd216  }; // PA2
        6'h02:   {hush,pointer,end_val} <= {1'b1, 16'd0    , 16'd360  }; // PA3
        6'h03:   {hush,pointer,end_val} <= {1'b1, 16'd0    , 16'd720  }; // PA4
        6'h04:   {hush,pointer,end_val} <= {1'b1, 16'd0    , 16'd1440 }; // PA5
        6'h05:   {hush,pointer,end_val} <= {1'b0, 16'd0    , 16'd2303 }; // OY
        6'h06:   {hush,pointer,end_val} <= {1'b0, 16'd2304 , 16'd3711 }; // AY
        6'h07:   {hush,pointer,end_val} <= {1'b0, 16'd3712 , 16'd4287 }; // EH
        6'h08:   {hush,pointer,end_val} <= {1'b0, 16'd4288 , 16'd4991 }; // KK3
        6'h09:   {hush,pointer,end_val} <= {1'b0, 16'd4992 , 16'd6207 }; // PP
        6'h0a:   {hush,pointer,end_val} <= {1'b0, 16'd6208 , 16'd7103 }; // JH
        6'h0b:   {hush,pointer,end_val} <= {1'b0, 16'd7104 , 16'd8511 }; // NN1
        6'h0c:   {hush,pointer,end_val} <= {1'b0, 16'd8512 , 16'd8959 }; // IH
        6'h0d:   {hush,pointer,end_val} <= {1'b0, 16'd8960 , 16'd9791 }; // TT2
        6'h0e:   {hush,pointer,end_val} <= {1'b0, 16'd9792 , 16'd11071}; // RR1
        6'h0f:   {hush,pointer,end_val} <= {1'b0, 16'd11072, 16'd11711}; // AX
        6'h10:   {hush,pointer,end_val} <= {1'b0, 16'd11712, 16'd13183}; // MM
        6'h11:   {hush,pointer,end_val} <= {1'b0, 16'd13184, 16'd13887}; // TT1
        6'h12:   {hush,pointer,end_val} <= {1'b0, 16'd13888, 16'd15039}; // DH1
        6'h13:   {hush,pointer,end_val} <= {1'b0, 16'd15040, 16'd16447}; // IY
        6'h14:   {hush,pointer,end_val} <= {1'b0, 16'd16448, 16'd18047}; // EY
        6'h15:   {hush,pointer,end_val} <= {1'b0, 16'd18048, 16'd18495}; // DD1
        6'h16:   {hush,pointer,end_val} <= {1'b0, 16'd18496, 16'd19199}; // UW1
        6'h17:   {hush,pointer,end_val} <= {1'b0, 16'd19200, 16'd20095}; // AO
        6'h18:   {hush,pointer,end_val} <= {1'b0, 16'd20096, 16'd20927}; // AA
        6'h19:   {hush,pointer,end_val} <= {1'b0, 16'd20928, 16'd22079}; // YY2
        6'h1a:   {hush,pointer,end_val} <= {1'b0, 16'd22080, 16'd22911}; // AE
        6'h1b:   {hush,pointer,end_val} <= {1'b0, 16'd22912, 16'd23679}; // HH1
        6'h1c:   {hush,pointer,end_val} <= {1'b0, 16'd23680, 16'd24063}; // BB1
        6'h1d:   {hush,pointer,end_val} <= {1'b0, 16'd24064, 16'd25151}; // TH
        6'h1e:   {hush,pointer,end_val} <= {1'b0, 16'd25152, 16'd25855}; // UH
        6'h1f:   {hush,pointer,end_val} <= {1'b0, 16'd25856, 16'd27263}; // UW2
        6'h20:   {hush,pointer,end_val} <= {1'b0, 16'd27264, 16'd29247}; // AW
        6'h21:   {hush,pointer,end_val} <= {1'b0, 16'd29248, 16'd29887}; // DD2
        6'h22:   {hush,pointer,end_val} <= {1'b0, 16'd29888, 16'd30783}; // GG3
        6'h23:   {hush,pointer,end_val} <= {1'b0, 16'd30784, 16'd31807}; // VV
        6'h24:   {hush,pointer,end_val} <= {1'b0, 16'd31808, 16'd32447}; // GG1
        6'h25:   {hush,pointer,end_val} <= {1'b0, 16'd32448, 16'd34047}; // SH
        6'h26:   {hush,pointer,end_val} <= {1'b0, 16'd34048, 16'd35199}; // ZH
        6'h27:   {hush,pointer,end_val} <= {1'b0, 16'd35200, 16'd36159}; // RR2
        6'h28:   {hush,pointer,end_val} <= {1'b0, 16'd36160, 16'd37055}; // FF
        6'h29:   {hush,pointer,end_val} <= {1'b0, 16'd37056, 16'd38207}; // KK2
        6'h2a:   {hush,pointer,end_val} <= {1'b0, 16'd38208, 16'd39167}; // KK1
        6'h2b:   {hush,pointer,end_val} <= {1'b0, 16'd39168, 16'd40383}; // ZZ
        6'h2c:   {hush,pointer,end_val} <= {1'b0, 16'd40384, 16'd41983}; // NG
        6'h2d:   {hush,pointer,end_val} <= {1'b0, 16'd41984, 16'd42687}; // LL
        6'h2e:   {hush,pointer,end_val} <= {1'b0, 16'd42688, 16'd43839}; // WW
        6'h2f:   {hush,pointer,end_val} <= {1'b0, 16'd43840, 16'd45759}; // XR
        6'h30:   {hush,pointer,end_val} <= {1'b0, 16'd45760, 16'd47103}; // WH
        6'h31:   {hush,pointer,end_val} <= {1'b0, 16'd47104, 16'd47871}; // YY1
        6'h32:   {hush,pointer,end_val} <= {1'b0, 16'd47872, 16'd49087}; // CH
        6'h33:   {hush,pointer,end_val} <= {1'b0, 16'd49088, 16'd50047}; // ER1
        6'h34:   {hush,pointer,end_val} <= {1'b0, 16'd50048, 16'd51711}; // ER2
        6'h35:   {hush,pointer,end_val} <= {1'b0, 16'd51712, 16'd53055}; // OW
        6'h36:   {hush,pointer,end_val} <= {1'b0, 16'd53056, 16'd54463}; // DH2
        6'h37:   {hush,pointer,end_val} <= {1'b0, 16'd54464, 16'd55039}; // SS
        6'h38:   {hush,pointer,end_val} <= {1'b0, 16'd55040, 16'd56191}; // NN2
        6'h39:   {hush,pointer,end_val} <= {1'b0, 16'd56192, 16'd57215}; // HH2
        6'h3a:   {hush,pointer,end_val} <= {1'b0, 16'd57216, 16'd59071}; // OR
        6'h3b:   {hush,pointer,end_val} <= {1'b0, 16'd59072, 16'd60671}; // AR
        6'h3c:   {hush,pointer,end_val} <= {1'b0, 16'd60672, 16'd62591}; // YR
        6'h3d:   {hush,pointer,end_val} <= {1'b0, 16'd62592, 16'd63167}; // GG2
        6'h3e:   {hush,pointer,end_val} <= {1'b0, 16'd63168, 16'd64255}; // EL
        6'h3f:   {hush,pointer,end_val} <= {1'b0, 16'd64256, 16'd65535}; // BB2
		default: {hush,pointer,end_val} <= {1'b1, 16'd0    , 16'd0    };
	  endcase
	end
	else if (increment) pointer <= pointer + 1;
  end
  
  assign val_match = (pointer == end_val);

  //******************************************************************//
  // Implement the ROM and registers surrounding it.                  //
  //******************************************************************//

  reg  [15:0] rom_address = 0;
  wire  [7:0] rom_data;

  always @(posedge clk) rom_address <= pointer;

  // Begin INSTANTIATION Template from VEO or VHO File
  // This is instantiation of ROM which is BRAM (8 bits width and 65536 depth bit depth) created using IP generator of Vivado
  // BRAM is also initialized with the .coe file containing sample phonemes 
  
   phonemes my_phonemes (
    .clka(clk),                    // input wire clka
    .addra(rom_address),           // input wire [15 : 0] addra
    .douta(rom_data)               // output wire [7 : 0] douta
  );
  // End INSTANTIATION Template from VEO or VHO File

  reg   [7:0] sample = 0;
  wire        sample_capture;

  always @(posedge clk) if (sample_capture) sample <= rom_data;

  //******************************************************************//
  // Instantiate the PWM audio DAC.                                   //
  //******************************************************************//

  dac dac_inst (
    .sample(sample),
    .hush(hush),
    .speaker(speaker),
    .clk(clk)
  );

  //******************************************************************//
  // Instantiate the FSM that controls this.                          //
  //******************************************************************//

  fsm1 fsm_inst (
    .busy(busy),
    .period_expired(period_expired),
    .data_arrived(data_arrived),
    .val_match(val_match),
    .load_ptrs(load_ptrs),
    .increment(increment),
    .sample_capture(sample_capture),
    .clk(clk)
  );

  //******************************************************************//
  //                                                                  //
  //******************************************************************//

endmodule
