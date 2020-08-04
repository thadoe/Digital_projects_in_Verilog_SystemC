#include "systemc.h"

enum disp_state {
	RD_minus , RD_plus 
};

	
SC_MODULE (DISP_GEN){
	sc_in <bool> clk;
	sc_in <bool> i_rdisp;
	sc_out <bool> o_rdisp;
	sc_out <bool> o_state;
	sc_out <sc_uint<10>> o_count; 			// uint in 10 binary bit 
	sc_in <sc_bv<10>> i_stream;	
	sc_out <sc_uint<10>>test_count ;
	signed int curr_disp = 0; 
	int count_r;
 	
  	disp_state curr_state = RD_minus; 		// state var init	
    
 
	int tc = 0;
	void count ();
	void FSM ();
	void FSM_out ();


	SC_CTOR (DISP_GEN): clk("clk"), i_rdisp("i_rdisp"), o_rdisp("o_rdisp"),o_state("o_state"),i_stream("i_stream"){   // name ports for debug	
  	 
     	// concurrent threads
  	 
	SC_METHOD (count);
	sensitive << i_rdisp;
	sensitive << i_stream;

	SC_CTHREAD (FSM, clk.pos());  

	SC_CTHREAD (FSM_out, clk.pos());
  	}
  

};
