#ifndef SRC_FIR_H_
#define SRC_FIR_H_

#define N 7
#define M 7
#define N_o 5
#define M_o 5
#define num_h 4 // number hidden neurons
#define num_o 3 // number output neurons

typedef int coef_t;
typedef int data_t;
typedef int acc_t;



/*void fir (

		data_t *y,
		coef_t c[N+1],
		data_t x

);*/

const void mac (

		float *y,
		const float c[N],
		const float x[M],
		 int n

);

const void mac_o (

		float *y,
		const float c[N_o],
		const float x[M_o],
		 int n

);

void relu (
		float *y,
		float x
);

#endif /* SRC_FIR_H_ */
