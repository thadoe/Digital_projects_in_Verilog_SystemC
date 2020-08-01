#include "systemc.h"
 #include "full_addr.h"
 #include "half_addr.h"

SC_MODULE (WT_4) {
	sc_in<sc_bv<4>> op1;
  	sc_in<sc_bv<4>> op2;
  	sc_out<sc_bv<8>> product;
  
  void multiplier (){
  	sc_bv<4> row0;
    sc_bv<4> row1;
    sc_bv<4> row2;
    sc_bv<4> row3;
    sc_bv<4> op2_r = op2.read();
    sc_bv<8> p;
    
    // partial product 
    row0 = op1.read() & (0xF * op2_r.get_bit(0) );
    row1 = op1.read() & (0xF * op2_r.get_bit(1) );
    row2 = op1.read() & (0xF * op2_r.get_bit(2) );
    row3 = op1.read() & (0xF * op2_r.get_bit(3) );

    // internal buses
    sc_bv<1> S_h1, S_f1, S_f2, S_h2, S_h3, S_f3, S_f4, S_f5, S_h4, S_f6, S_f7, S_f8;
    sc_bv<1> C_h1, C_f1, C_f2, C_h2, C_h3, C_f3, C_f4, C_f5, C_h4, C_f6, C_f7, C_f8;
    
    // stage 1 
    half_addr (row0.get_bit(1), row1.get_bit(0), &S_h1, &C_h1);
    full_addr (row0.get_bit(2), row1.get_bit(1), row2.get_bit(0), &S_f1, &C_f1);
    full_addr (row0.get_bit(3), row1.get_bit(2), row2.get_bit(1), &S_f2, &C_f2);
    half_addr (row1.get_bit(3), row2.get_bit(2), &S_h2, &C_h2); 
    
    //stage 2
    half_addr (S_f1, C_h1, &S_h3, &C_h3);
    full_addr (S_f2, C_f1, row3.get_bit(0), &S_f3, &C_f3);
    full_addr (S_h2, C_f2, row3.get_bit(1), &S_f4, &C_f4);
    full_addr (row2.get_bit(3), C_h2, row3.get_bit(2), &S_f5, &C_f5);
    
    // stage 3
    half_addr (S_f3, C_h3, &S_h4, &C_h4);
    full_addr (S_f4, C_f3, C_h4, &S_f6, &C_f6);
    full_addr (S_f5, C_f4, C_f6, &S_f7, &C_f7);
    full_addr (row3.get_bit(3), C_f5, C_f7, &S_f8, &C_f8);
    
    
    p = (C_f8,S_f8,S_f7,S_f6,S_h4,S_h3,S_h1,row0.get_bit(0)); // concatenation of sc_bv
    
    product.write (p);
   
  }
  
  SC_CTOR (WT_4){    
  	SC_METHOD (multiplier);
    sensitive << op1;
    sensitive << op2;
  
  }

};
