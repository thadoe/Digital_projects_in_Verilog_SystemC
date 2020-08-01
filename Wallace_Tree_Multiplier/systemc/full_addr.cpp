#include "systemc.h"
#include "half_addr.h"
#include "full_addr.h"


  void full_addr (sc_bv<1> A, sc_bv<1>B, sc_bv<1> C, sc_bv<1>* SUM , sc_bv<1>* CARRY ){
		sc_bv<1> h1_sum = 0;
        sc_bv<1> h2_sum = 0; 
    	sc_bv<1> h1_carry = 0; 
    	sc_bv<1> h2_carry = 0;
  		
  		half_addr (A, B, &h1_sum, &h1_carry);
  		half_addr (h1_sum, C, &h2_sum, &h2_carry);
  
  		*CARRY = h1_carry | h2_carry;
  		*SUM = h2_sum;

	}
