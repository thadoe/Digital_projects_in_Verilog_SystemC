#include "systemc.h"

SC_MODULE(syn_counter) {
	  sc_in <bool> clk;
  	sc_in <bool> Ep;
  	sc_in <bool> Et;
  	sc_in <bool> CLEAR;	 	// active low
  	sc_in <bool> LOAD;		// active low 
  	sc_in <sc_uint<4>> i_preset;
  	sc_out <sc_uint<4>> o_Q;
  	sc_out <sc_uint<1>> RCO;
    
    sc_uint<4> Q;
    sc_int<16> counter = 0;
  
  	void syncmain () {
      bool enable;
      bool e;
      bool r; 
      bool qbits [4]; 
      e = Et.read();
      r = 0;
      enable = (Ep.read()) & (Et.read());
      
      if (CLEAR.read() == 0) {
      	o_Q.write (0);
        Q = 0;
      } else {

        //while (true) {
          
          if (LOAD.read() == 0) {
            Q = i_preset.read();
          } else {
            if (enable){
              if (counter == 4){
                counter = 0;
                Q = Q +1;
                cout << "counter values is " << Q << endl;
              }else{
                counter++;
              }
             // Q = Q +1;
             
          }
          
          o_Q.write(Q);
          cout << "@" << sc_time_stamp() <<" counter values is " << Q<< endl;

          qbits [0]= ((Q)>>(0)) & 1;
          qbits [1]= ((Q)>>(1)) & 1;
          qbits [2]= ((Q)>>(2)) & 1;
          qbits [3]= ((Q)>>(3)) & 1;
          r= qbits[0] & qbits[1] & qbits[2] & qbits[3] & e;
          RCO.write(r);
    
      	}
      }
}
  SC_CTOR ( syn_counter ){
    	cout <<"Executing new" << endl;
  		SC_METHOD ( syncmain );
    	sensitive << CLEAR; 
    	sensitive << clk.pos();
  		//reset_signal_is (CLEAR , false);   	
   }

};

