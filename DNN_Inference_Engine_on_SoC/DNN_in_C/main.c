
#include <stdio.h>
#include "fir.h"
#include "platform.h"
#include "xil_printf.h"
#include <math.h>

/*
void fir ( data_t *y, coef_t c[N], data_t x){
	static data_t shift_reg[N]; //N taps
	acc_t acc;
	data_t data;
	int i;

	acc=0;
	Shift_Accum_Loop: for (i = N-1; i>=0; i--){
		if (i ==0){
				shift_reg[0] = x;
				data = x;
		} else {
				shift_reg[i] = shift_reg[i-1];
				data = shift_reg[i];
		}
		acc+=data*c[i];
	}
	*y = acc;
} */


const void mac ( float *y, const float c[N], const float x[M],  int n) {
	 //static double coeff[N];
	 double acc = 0;
	 for (int i = 0; i < N; i++ ){
		acc+=  x[i]* c[i];
		printf("\n Hidden MAC %u: %.4f , %.4f, %.4f \n", n, c[i], x[i], acc );
	 }
	 *y = acc;
}

const void mac_o ( float *y, const float c[N_o], const float x[M_o],  int n) {
	 //static double coeff[N];
	 float acc = 0;
	 for (int i = 0; i < N; i++ ){
		acc+=  x[i]* c[i];
		printf("\n Output MAC %u: %.4f , %.4f, %.4f \n", n, c[i], x[i], acc );
	 }
	 *y = acc;
}

void relu (float *y, float x) {
		*y = (x>0)? x : 0;
}

int main()
{
   const int index [4] = {1,2,3,4};
   int column =  1;
   float output_h[num_h]; 		// 	output of hidden layer
   float output_h_a[num_h+1]; 	//  output of hidden layer after activation + bias
   float output_o[num_o];  		// 	output of output layer
   float output_o_a[num_o];     //  output of ouput layer after activation + bias
   
   
   //----------TAPs for each hidden layer neuron----------
   const float taps_h1[7] =	{0.2890, 0.0077, -0.0003, -0.0843, -0.3052, -0.3977, -0.2209};
   const float taps_h2[7] =	{-0.1427, -0.0016, -0.0055, 0.0455, -0.0680, -0.4722, -0.2556};
   const float taps_h3[7] =	{0.1375, 0.0247, 0.0009,0.0487,-0.0472,-0.3125,-0.1011 };
   const float taps_h4[7] =	{-0.0402, 0.0127, -0.0009,0.1000,0.3983,-0.0184,-0.2383 };

   //----------TAPs for each output layer neuron----------
   const float taps_o1[5] =	{-0.8861	, -1.8118	, -1.5205 	, 2.7008 	, -1.0033};
   const float taps_o2[5] =	{-0.3545 	, 0.6085 	, 1.9607	, 1.1139	, -0.8877};
   const float taps_o3[5] =	{1.3471		, 3.5054	, -2.1386	,-1.0623	,-0.8463 };

   //const float input [7]  =	{1, 0, 0, 0.0010, -0.0076, -0.0419, -0.0413}; 	// input row 0
   //const float input [7]  =	{1, 0, 0, 0.0006, -0.0189,  0.1693, 0.8295};	// input row 1
   //const float input [7]  =	{1, 0, 0, 0.0007, -0.0049,  -0.0324, 0.0219};	// input row 2
   const float input [7]  =	{1, 0, 0, 0, 0,  0, 0};								// input row 3
   
     //----------hidden layer neuron operations----------

   	   mac (&output_h, taps_h1, input, index[0]);
   	   mac (&(*(output_h+1)), taps_h2, input, index[1]);
   	   mac (&(*(output_h+2)), taps_h3, input, index[2]);
   	   mac (&(*(output_h+3)), taps_h4, input, index[3]);

   	   for (int x = 0; x <num_h; x++ ){
   		   printf("\nHidden MAC %u output: %.6f\n", index[x], output_h[x]);
   	   }

   	   output_h_a[0] = 1;
   	   for (int x = 0; x <num_h; x++ ){           	// assign out from hidden layer to input to out layer arrays
   		   	   relu (&(*(output_h_a+x+1)), output_h[x]);
   	   	   }

   	   for (int x= 0; x<num_h+1; x++){
   		   printf("\nInput to output layer index %u: %.6f\n", index[x], output_h_a[x]);
   	   }

   //----------output layer neuron operations----------

   	 mac_o (&output_o, taps_o1, output_h_a, 1);
   	 mac_o (&(*(output_o+1)), taps_o2, output_h_a, 2);
   	 mac_o (&(*(output_o+2)), taps_o3, output_h_a, 3);

   	for (int x = 0; x <num_o; x++ ){
   	   		   printf("\n Output MAC %u output: %.6f\n", index[x], output_o[x]);
   	   	   }

   	 for (int x = 0; x <num_o; x++ ){           	// assign out from out layer to input to relu
   	   		   	   relu (&(*(output_o_a+x)), output_o[x]);
   	   		   	   printf("\n Output MAC %u output after relu: %.6f\n", index[x], output_o_a[x]);
   	 	 	}

   return 0;

  }
   
