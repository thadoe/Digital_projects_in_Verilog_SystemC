#include "design.cpp"
#ifndef disp_gen_FSM
#define disp_gen_FSM 

void DISP_GEN :: count (void){
  sc_bv<10> i_stream_r= i_stream.read();
  count_r = 0;
  for (int i =0 ; i < 10 ; i++){
  	count_r = count_r + i_stream_r.get_bit(i);
  }
  curr_disp = count_r - (10 - count_r );
  o_count.write(count_r);
  cout<< "@" << sc_time_stamp() <<" disp  " <<curr_disp<<endl; // ignore.for debug
  
}

void DISP_GEN :: FSM (void){
  //wait (SC_ZERO_TIME);
  while (true){
  curr_state = (i_rdisp == 1)? RD_plus : RD_minus;
    
    cout<< "@" << sc_time_stamp() <<" curr state ini " <<curr_state<<endl;
  
  switch (curr_state){
  	
    case RD_minus:
    	if (curr_disp == 0){
    		curr_state = RD_minus;
    	} else {
    		curr_state = RD_plus;
    	}
    	
    	break;
    
    case RD_plus:
    	if (curr_disp == 0){
    		curr_state = RD_plus; 	
    	} else {
    		curr_state = RD_minus;
    	}
    	
    	break;
  
  }
    tc++;
    test_count.write(tc );                 						          // ignore.for debug
    
    cout<< "@" << sc_time_stamp() <<" " <<curr_state<<endl;   	// ignore.for debug
    
   wait(); // suspend process untill next event 
   
  }
   
}
//output logic 
void DISP_GEN :: FSM_out (void){	                           
  while (true) {
    if (curr_state == RD_minus) {
          o_rdisp.write(0);
      	  o_state.write(0);
    } else {  	
          o_rdisp.write(1);   	 
      	  o_state.write(1);
    }
    wait();
    
  }
}

#endif 
