module clock(
					input clk_1s, clk, RST,
					input set,set_hh,set_mm,stop_buzzer,
					input set_btn,
					output reg set_led,
					input [1:0] test_led,
					input [1:0] ps,
					output reg buzzer,
					output reg [6:0] ss7_lsd = 7'b1000000,
					output reg [6:0] ss7_msd = 7'b1000000,
					output reg [6:0] mm7_lsd = 7'b1000000,
					output reg [6:0] mm7_msd = 7'b1000000,
					output reg [6:0] hh7_lsd = 7'b1000000,
					output reg [6:0] hh7_msd = 7'b1000000,
					output reg buzzer_led = 1'b0
				
					);
					
									
/////*****	REG/WIRE Declarations	*****/////
	
/*	 integer count_1s, count_hr, count_min, count_sec;

 */ 
    reg ff1,ff2;
    wire timer_cnt;
	 reg set_btn_n;
	 wire timer_enable;
	 reg clock_E;
	 reg Alarm_E;
	 reg Timer_E;
	 reg stopwatch_E;
	 assign timer_enable = ({t_hr, t_min, t_sec} == 0)? 1'b0 : 1'b1;
    // catch neg edge of timer_enable 
	 
    always @ (posedge clk)  ff1 <= timer_enable;   
    always @ (posedge clk)  ff2 <= ff1;
    assign timer_cnt = ff2 & ~ff1;       
	 
	 // regs to clock values 
	 reg [5:0] c_hr,c_min,c_sec;
	 wire [3:0] c_hr1,c_hr0,c_min1,c_min0,c_sec1,c_sec0;	 
	 // regs to alarm values 
	 reg [5:0] a_hr,a_min,a_sec;
	 wire [3:0] a_hr1,a_hr0,a_min1,a_min0,a_sec1,a_sec0;
	 // regs to timer values 
	 reg [5:0] t_hr,t_min,t_sec;
	 wire [3:0] t_hr1,t_hr0,t_min1,t_min0,t_sec1,t_sec0;
     // regs to stopwatch values   
	 reg [5:0] s_hr,s_min,s_sec;
	 wire [3:0] s_hr1,s_hr0,s_min1,s_min0,s_sec1,s_sec0;
	 
	 
/////*****	Integration with state machine	*****/////	 
		always @(*) begin
			if (ps == 2'b00) begin
				clock_E <= 1'b1;
				stopwatch_E <= 1'b0;
				Alarm_E <= 1'b0;
				Timer_E <= 1'b0; end
			else if (ps == 2'b01) begin
				stopwatch_E <= 1'b0;
				clock_E <= 1'b0;
				Alarm_E <= 1'b1;
				Timer_E <= 1'b0;	end		
			else if (ps == 2'b10) begin
				stopwatch_E <= 1'b0;
				clock_E <= 1'b0;
				Alarm_E <= 1'b0;
				Timer_E <= 1'b1;	end 
			else if (ps == 2'b11) begin
				stopwatch_E <= 1'b1;
				clock_E <= 1'b0;
				Alarm_E <= 1'b0;
				Timer_E <= 1'b1; end
			end

/////*****	Button Active-Low to Active-High Conversion	*****/////			
always @ (posedge clk or posedge set_btn)
		begin	
			set_btn_n <= ~set_btn;
			set_led <= set_btn_n;
		end	

		
///////////////////////////////////////////////////////	
/////*****	Basic Clock Alarm Mode Operation	*****/////	
///////////////////////////////////////////////////////

	always @ (posedge clk_1s or posedge RST)
		begin	
			if (RST) begin
					{a_hr, a_min, a_sec} <= 0;  
					{c_hr, c_min, c_sec} <= 0;
					{t_hr, t_min, t_sec} <= 0;
			end
/////////////////// Set Clock Time ///////////////////
			else begin
					if (clock_E && set) begin			
						if (set_hh) begin
							if(set_btn_n)	begin
								c_hr <= c_hr + 1;
								c_sec <= 0; end						
						 end 
						 else if (set_mm) begin
							if(set_btn_n)	begin
								c_min <= c_min + 1;
								c_sec <= 0; end
						 end
					end
/////////////////// Set Alarm Time ///////////////////
					if (Alarm_E && set) begin			
						if (set_hh) begin
							if(set_btn_n)	begin
								a_hr <= a_hr + 1;
								a_sec <= 0; end						
						 end 
						 else if (set_mm) begin
							if(set_btn_n)	begin
								a_min <= a_min + 1;
								a_sec <= 0; end
						 end
					end				
/////////////////// Set Timer ///////////////////
					if (Timer_E && set) begin			
						if (set_hh) begin
							if(set_btn_n)	begin
								t_hr <= t_hr + 1;
								t_sec <= 0; end						
						 end 
						 else if (set_mm) begin
							if(set_btn_n)	begin
								t_min <= t_min + 1;
								t_sec <= 0; end
						 end
					end
/////////////////// Run main clock during all states ///////////////////
					else if(clock_E || Alarm_E || Timer_E || stopwatch_E)begin	//run main clock in all modes
						c_sec  <= c_sec + 1;
							if (c_sec >= 59) begin
								c_min <= c_min+1;
								c_sec <= 0;
								end
							if (c_min >= 59) begin
								c_hr <= c_hr+1;
								c_min <= 0;
								end
							if (c_hr >= 23) begin
								 c_hr <= 0;
								end
							if (timer_enable)
								begin
									t_sec <= t_sec -1;
									if (t_sec <= 0) 
										begin
										if (t_min <= 0) 
											begin
											if (t_hr <= 0) 
												begin
												t_hr <= 0;
												t_min <= 0;
												t_sec <= 0;
												end
											else
												begin
												t_hr <= t_hr -1;
												t_min <= 59;
												t_sec <= 59;
												end
											end
										else
											begin
											t_min <= t_min - 1;
											t_sec <= 59;
											end
										end
								end 
						end
							end								
							
					end

					

///////////////////////////////////////////////			
/////*****	Stopwatch operation Mode *****/////	
///////////////////////////////////////////////

    always @ (posedge clk_1s or posedge RST)
		begin	
			  if (RST) 
						{s_hr, s_min, s_sec} = 0;
				else if (set_mm && stopwatch_E) begin
					s_sec  <= s_sec + 1;
						if (s_sec >= 59) begin
							s_min <= s_min+1;
							s_sec <= 0;
							end
						if (s_min >= 59) begin
							s_hr <= s_hr+1;
							s_min <= 0;
							end
						if (s_hr >= 24) begin
							 s_hr <= 0;
							end
				end
    end	
	 
///////////////////////////////////////////	
////////******* Buzzer Logic *******///////
///////////////////////////////////////////

     always @ (posedge clk or posedge RST or posedge stop_buzzer) begin
			if(RST || stop_buzzer) begin
            buzzer <= 0;
				buzzer_led <= 0; end
			else begin
				if(timer_cnt) begin
					buzzer <= 1;
					buzzer_led <= 1; end				
				if({a_hr,a_min,a_sec} == {c_hr,c_min, c_sec}) begin
					if ({a_hr,a_min,a_sec} == 000000) begin
						buzzer <= 0;
						buzzer_led <= 0; end
					else begin
						buzzer <= 1;
						buzzer_led <= 1; end
				end
     end  
     end 	 
	 	
////////////////////////////////////////////////////////////////////	
////////******* Decimal to 7segment conversion module *******///////
////////////////////////////////////////////////////////////////////

		function [6:0] ss;
			input [3:0] din;
				begin
					case(din)
						0: ss = 7'b1000000;
						1: ss = 7'b1111001;
						2: ss = 7'b0100100;
						3: ss = 7'b0110000;
						4: ss = 7'b0011001;
						5: ss = 7'b0010010;
						6: ss = 7'b0000010;
						7: ss = 7'b1111000;
						8: ss = 7'b0000000;
						9: ss = 7'b0010000;
						default: ss = 7'b1000000; //default is zero 
					endcase
				end
		endfunction 

		always @(*) begin
			if (clock_E) begin
						ss7_lsd <= ss(c_sec0);   
						ss7_msd <= ss(c_sec1); 
						mm7_lsd <= ss(c_min0); 
						mm7_msd <= ss(c_min1); 
						hh7_lsd <= ss(c_hr0); 
						hh7_msd <= ss(c_hr1);
					end
			else if (Alarm_E) begin
						ss7_lsd <= ss(a_sec0);   
						ss7_msd <= ss(a_sec1); 
						mm7_lsd <= ss(a_min0); 
						mm7_msd <= ss(a_min1); 
						hh7_lsd <= ss(a_hr0); 
						hh7_msd <= ss(a_hr1);
					end
			else if (Timer_E) begin
						ss7_lsd <= ss(t_sec0);   
						ss7_msd <= ss(t_sec1); 
						mm7_lsd <= ss(t_min0); 
						mm7_msd <= ss(t_min1); 
						hh7_lsd <= ss(t_hr0); 
						hh7_msd <= ss(t_hr1);
					end	
			 if (stopwatch_E) begin
						ss7_lsd <= ss(s_sec0);   
						ss7_msd <= ss(s_sec1); 
						mm7_lsd <= ss(s_min0); 
						mm7_msd <= ss(s_min1); 
						hh7_lsd <= ss(s_hr0); 
						hh7_msd <= ss(s_hr1);
					end
				end		
		
		
////////////////////////////////////////////////////////////////////////		
///////******* Task to store a value to 2 digit-registers *******///////
////////////////////////////////////////////////////////////////////////
    always @ (*) begin
        convert (c_min, c_min1, c_min0);
        convert (c_sec, c_sec1, c_sec0);
        convert (t_sec, t_sec1, t_sec0);
        convert (t_min, t_min1, t_min0);
        convert (a_min, a_min1, a_min0);
        convert (a_sec, a_sec1, a_sec0);
        convert (a_hr, a_hr1, a_hr0);
        convert (c_hr, c_hr1, c_hr0);
		  convert (t_hr, t_hr1, t_hr0);
        convert (s_hr, s_hr1, s_hr0);
        convert (s_min, s_min1, s_min0); 
        convert (s_sec, s_sec1, s_sec0);    
	 end 

	task convert;
		 input [5:0] value_in;
		 output [3:0] msb, lsb;
		 begin 
			  msb = value_in / 10;
			  lsb = value_in % 10; 
		 end
	endtask 	

	

endmodule
