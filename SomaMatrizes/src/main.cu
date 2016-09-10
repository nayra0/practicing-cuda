#include<stdio.h>
#include<cuda.h>


#define MAX 10

void teste(){
	printf("hello world!");
}

void populaVetor(int * x, int tamanho){
	int i;
	for(i = 0; i < tamanho; i++){
		x[i] = rand() % tamanho;
	}
}

void exibeVetor(int * x, int tamanho){
	int i;
	for(i = 0; i < tamanho; i++){
		printf("%d : %d\n", i, x[i]);
	}
}


__global__ void kernelSoma(int * J, int * K, int * L, int tamanho){
	int indice = blockDim.x * blockIdx.x + threadIdx.x;
	if(indice < tamanho){
		L[indice] = J[indice] + K[indice];
	}
}

int main(){
//	teste();

	int tamanhoBytes = MAX * sizeof(int);

	int * h_J = (int * )malloc(tamanhoBytes);
	int * h_K = (int * )malloc(tamanhoBytes);
	int * h_L = (int * )malloc(tamanhoBytes);
	int * d_J;
	int * d_K;
	int * d_L;

	cudaMalloc((void **) &d_J, tamanhoBytes);
	cudaMalloc((void **) &d_K, tamanhoBytes);
	cudaMalloc((void **) &d_L, tamanhoBytes);

	populaVetor(h_J, MAX);
	populaVetor(h_K, MAX);

	exibeVetor(h_J, MAX);
	exibeVetor(h_K, MAX);

	cudaMemcpy(d_J, h_J, tamanhoBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_K, h_K, tamanhoBytes, cudaMemcpyHostToDevice);

	dim3 grid, block;
	grid.x = 2;
	grid.y = 1;
	grid.z = 1;
	block.x = 5;
	block.y = 1;
	block.z = 1;

	kernelSoma<<<grid, block>>>(d_J, d_K, d_L, MAX);


	cudaMemcpy(h_L, d_L, tamanhoBytes, cudaMemcpyDeviceToHost);

	exibeVetor(h_L, MAX);

	cudaFree(d_J);
	cudaFree(d_K);
	cudaFree(d_L);

	free(h_J);
	free(h_K);
	free(h_L);

	cudaDeviceReset();
	return 0;
}



