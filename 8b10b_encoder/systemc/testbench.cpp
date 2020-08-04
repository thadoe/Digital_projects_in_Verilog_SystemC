#include "systemc.h"
#include "design.cpp"

int sc_main (int argc, char* argv[]){
  	
  	//sc_set_time_resolution(1, SC_PS);
  	//sc_set_default_time_unit (1, SC_NS);
	
  	sc_signal <bool> i_rdisp;
  	sc_signal <bool> o_rdisp;
  	sc_signal <bool> o_state;
  	sc_signal <sc_bv<10>> i_stream;
  	sc_signal <sc_uint<10>> o_count;
  	sc_clock clk ("my_clk", 1, 0.5,true);
  
  	sc_signal <sc_uint<10>>test_count ;
  		 
  	DISP_GEN *disp_gen0;
  	disp_gen0 = new DISP_GEN("disp_gen0"); 
  		disp_gen0->i_rdisp(i_rdisp);
  		disp_gen0->o_rdisp(o_rdisp);
  		disp_gen0->o_state(o_state);
  		disp_gen0->i_stream(i_stream);
  		disp_gen0->o_count(o_count);
  		disp_gen0->clk(clk);
  		disp_gen0->test_count(test_count);
  
  	sc_trace_file* wf;
  	wf = sc_create_vcd_trace_file("disp_gen0");
      sc_trace(wf,clk,"clk");
      sc_trace(wf, i_rdisp, "i_rdisp");
      sc_trace(wf, o_rdisp, "o_rdisp");
      sc_trace(wf, o_state, "o_state");
      sc_trace(wf, i_stream, "i_stream");
  	  sc_trace(wf, o_count, "o_count");
      sc_trace(wf, test_count, "test_count");
   
   // create test strings and running disparity loopback 
    i_rdisp = 0;
    i_stream = 992;
    sc_start(1, SC_NS);
    i_stream = 15;
    sc_start(5, SC_NS);
    i_rdisp = o_rdisp;
    i_stream = 992;
    sc_start(5, SC_NS);
    i_rdisp = o_rdisp;
    i_stream = 682;
    sc_start(5, SC_NS);
    i_rdisp = o_rdisp;
    i_stream = 1008;
    sc_start(5, SC_NS);
    i_rdisp = o_rdisp;
    i_stream = 1008;
    sc_start(5, SC_NS);
    i_rdisp = o_rdisp;
    i_stream = 992;
    sc_start(5, SC_NS);
    i_rdisp = o_rdisp;
    i_stream = 15;
    sc_start(5, SC_NS);

    sc_stop();

    delete disp_gen0;
  	
	return 0;
}
