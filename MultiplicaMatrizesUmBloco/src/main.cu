#include<stdio.h>
#include<cuda.h>
#include "lib.c"

__global__ void kernelMulti(int * a, int * b, int * c, int tamanho){
	int tx = threadIdx.x;
	int ty = threadIdx.y;
	int value = 0;
	int indice = tx * blockDim.x + ty;

	if(indice <= tamanho){
		for(int i = 0; i< blockDim.x; i++){
			int x = a[tx * blockDim.x + i] ;
			int y = b[i * blockDim.x + ty] ;
			value += x * y;
		}
		c[indice] = value;
	}
}

int main(){
	dim3 a(2,3),b(3,4),c;
	c.x = a.x;
	c.y = b.y;

	int t_a = a.x * a.y;
	int t_b = b.x * b.y;
	int t_c = c.x * c.y;

	int tamA = t_a * sizeof(int);
	int tamB = t_b * sizeof(int);
	int tamC = t_c * sizeof(int);

	int * h_a = (int *) malloc(tamA);
	int * h_b = (int *) malloc(tamB);
	int * h_c = (int *) malloc(tamC);
	int * d_a;
	int * d_b;
	int * d_c;

	cudaMalloc(&d_a, tamA);
	cudaMalloc(&d_b, tamB);
	cudaMalloc(&d_c, tamC);

	populaVetor(h_a, t_a);
	populaVetor(h_b, t_b);

	exibeVetor(h_a, t_a);
	printf("------------------\n");
	exibeVetor(h_b, t_b);
	printf("------------------\n");

	cudaMemcpy(d_a,h_a,tamA,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,h_b,tamB,cudaMemcpyHostToDevice);

	dim3 grid(1,1,1), block(c.x,c.y,1);
	kernelMulti<<<grid, block>>>(d_a, d_b, d_c, t_c);

	cudaMemcpy(h_c,d_c, tamC, cudaMemcpyDeviceToHost);

	printf("\n");
	exibeVetor(h_c, t_c);

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	free(h_a);
	free(h_b);
	free(h_c);

	cudaDeviceReset();

	return 0;
}
