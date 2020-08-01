#include "systemc.h"
#include "half_addr.h"

  void half_addr (sc_bv<1> a, sc_bv<1> b, sc_bv<1>* sum , sc_bv<1>* carry ){
		*sum = a ^ b;
  		*carry = a & b; 

	}
