#include "systemc.h"
#include "design.cpp"
#include "bitset"

int sc_main (int argc , char* argv[]){

	  sc_signal <sc_bv<4>> op1;
  	sc_signal <sc_bv<4>> op2;
  	sc_signal <sc_bv<8>> product;
    sc_clock clk ("my_clock", 1 , 0.5, true );
	  int err = 0;
  
  	sc_bv<4> op1_r = op1.read();
    sc_bv<4> op2_r = op2.read();
    sc_bv<8> product_r = product.read();
	
    WT_4 WT("WT");
  	WT.op1(op1);
  	WT.op2(op2);
  	WT.product(product);
  
  	sc_trace_file* wf;
  	wf = sc_create_vcd_trace_file ("WT");
    sc_trace (wf, op1, "op1");
  	sc_trace (wf, op2 , "op2");
    sc_trace (wf, product, "product");
    
    for (int i=0; i <= 15 ; i++){ 
  	  for (int j=0; j <= 15 ; j++){  	
        op1 = i;
      	op2 = j;
        if (product_r.to_uint() != op1_r.to_uint() * op2_r.to_uint()){
        	err++;
        }
       sc_start(1, SC_NS );
  	  }
    }
  
   sc_start(50,SC_NS);
   sc_stop();
   
   cout << "@"<< sc_time_stamp() << " Simulation End\n" <<endl;
   sc_close_vcd_trace_file (wf);
  
   return 0;

} 
