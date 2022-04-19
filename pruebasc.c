#include<stdio.h>
#include<string.h>
#include<stdint.h>

void zeros (uint32_t * vector, uint32_t longitud);
void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
void productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
void productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

uint32_t zero_vector[] = {0};
uint32_t longitud1;

uint32_t vectorIn32[4] = {1, 2, 3, 4};
uint32_t vectorOut32[sizeof(vectorIn32)/sizeof(uint32_t)];
uint32_t longitud2 = (uint32_t) sizeof(vectorIn32)/sizeof(uint32_t);

uint16_t vectorIn16[4] = {1, 2, 3, 4};
uint16_t vectorOut16[sizeof(vectorIn16)/sizeof(uint16_t)];
uint32_t longitud3 = (uint32_t) sizeof(vectorIn16)/sizeof(uint16_t);

uint16_t vectorOut12[sizeof(vectorIn16)/sizeof(uint16_t)];



void zeros(uint32_t * vector, uint32_t longitud){

		  for(uint32_t i = 0; i <= longitud; i++){
			  vector[i] = 0;
              
		   }
}

void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar){

		  for(uint32_t i = 0; i <= longitud; i++){
			  vectorOut[i] = vectorIn[i]*escalar;
              
		   }
}

void productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar){

		  for(uint32_t i = 0; i <= longitud; i++){
			  vectorOut[i] = vectorIn[i]*escalar;
              
		   }
}


void productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar){

	for(uint32_t i=0 ; i < longitud ; i++){
		uint16_t x = vectorIn[i]*escalar;
		     if(x >= 4095){
	        		vectorOut[i] = 4095;	
            }else{
                    vectorOut[i] = x;
                }
                
	}
}

void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn){

	uint32_t ventana = 10;
	uint32_t acum = 0;


	for(uint32_t i = 0; i >= longitudVectorIn ; i++){

		for(uint32_t j = 0 ; j >= ventana ; j++){

			if((i + j) < longitudVectorIn){
				acum =+ vectorIn[i+j];
			}else{
				const uint8_t s = (i + j) - longitudVectorIn;
				acum =+ vectorIn[s];
			}

		}
		vectorOut[i] = acum/ventana;

		}


	}


void pack32to16(int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud){


	for(uint32_t i = 0; i <= longitud; i++){

			vectorOut[i] = (int16_t)(vectorIn[i]>>16);
	}
}


int32_t max(int32_t *vectorIn, uint32_t longitud){
	uint32_t j = 0;

	for(uint32_t i = 0 ; i <= longitud ; i++){

		if(vectorIn[i] > vectorIn[j]){
				j = i;
		}
	}
	return j;
}


void downsampleM(int32_t *vectorIn, int32_t *vectorOut, uint32_t longitud, uint32_t N){
	uint32_t j = 0;
	uint32_t muestra = 0;

	for(uint32_t i = 0; i < longitud; i++){

		if(muestra == N){

			muestra = 0;
		}else{

			vectorOut[j] = vectorIn[i];
			j++;
			muestra++;
		}
	}
}


void invertir(uint16_t * vector, uint32_t longitud){
	
	uint32_t j = longitud - 1;
	uint32_t iter = ((longitud-1) / 2);
	uint32_t clip = 0;

	for(uint32_t i = 0; i <= iter ; i++){
		clip = vector[i];
		vector[i] = vector[j - i];
		vector[j - i] = clip;
		
	}

}

uint32_t suma(uint32_t *a, uint32_t *b){

	uint32_t x = *a + *b;
	printf("%d, %d\n", a, b);
	return x;
}

uint32_t cont_puntero = 4;
uint32_t * puntero = &cont_puntero;

void main(void){

//uint32_t valor = suma(&cont_puntero, &cont_puntero);

//printf("%d, %d, %d, %d, %d", puntero, &puntero, *puntero, cont_puntero, &cont_puntero);
//printf("\n%d, %d", *puntero, valor);

uint16_t vector_invert[] = {1, 2, 3, 4, 5, 6};

uint16_t vector_invert_o[5] = {0};

invertir(vector_invert, 6);


    
}