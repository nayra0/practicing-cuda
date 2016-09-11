#include "lib.h"

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


