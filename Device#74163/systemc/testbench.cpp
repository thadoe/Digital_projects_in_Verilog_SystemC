#include "systemc.h"
#include "design.cpp"


//SYSTEM *top = NULL;

int sc_main (int argc, char* argv[]){
  
    sc_signal <bool>	Ep;	 	
  	sc_signal <bool>	Et;
  	sc_signal <bool> CLEAR;
  	sc_signal <bool> LOAD;
  	sc_signal <sc_uint<4>> i_preset;
  	sc_signal <sc_uint<4>>  o_Q;
  	sc_signal <sc_uint<1>>  RCO;
  	//sc_signal <bool> clk;
    sc_clock clk ("my_clock",1,0.5, true);
  	int i = 0;
  	 
	syn_counter syn_counter0 ("SYN_COUNTER");
  		syn_counter0.clk(clk);
  		syn_counter0.Ep(Ep);
  		syn_counter0.Et(Et);
        syn_counter0.CLEAR(CLEAR);
        syn_counter0.LOAD(LOAD);
        syn_counter0.i_preset(i_preset);
        syn_counter0.o_Q(o_Q);
  		syn_counter0.RCO(RCO);	
  
    
  	sc_trace_file* wf;
  	
  	wf = sc_create_vcd_trace_file("syn_counter0");
  
  	sc_trace(wf, clk, "clk");
    sc_trace(wf, Ep, "Ep");
    sc_trace(wf, Et, "Et");
    sc_trace(wf, CLEAR, "CLEAR");
    sc_trace(wf, LOAD, "LOAD");
    sc_trace(wf, i_preset, "i_preset");
    sc_trace(wf, o_Q, "o_Q");
    sc_trace(wf, RCO, "RCO");
  
   
  
  // reset pulse 

  Ep = 0;
  Et = 0;
  LOAD  = 1;
  CLEAR = 0;
  sc_start(5, SC_NS);

  CLEAR = 1;
  sc_start(5, SC_NS);

  LOAD = 0;
  Ep = 1;
  Et = 1;
  i_preset = 9;
  sc_start(1, SC_NS);

  LOAD = 1;
  sc_start(50, SC_NS);
  
  i_preset = 4;
  LOAD = 0;
  sc_start(1, SC_NS);
  
  LOAD = 1;
  sc_start(50, SC_NS);
  
  cout << "@" << sc_time_stamp() << " De-assert enable\n" <<endl;
  Et= 0;
  Ep = 0;
  sc_stop();
  
  cout << "@" << sc_time_stamp() << " Simulation End\n" <<endl;
  sc_close_vcd_trace_file(wf);
    
      
      return 0; 
}
