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


void main(void){

    zeros(zero_vector, 4);

    productoEscalar16(vectorIn16, vectorOut16, 4, 3);

    productoEscalar32(vectorIn32, vectorOut32, 4, 3);

    productoEscalar12 (vectorIn16, vectorOut12, 4, 3000);

 printf("\n\rvector 0\n\r");
 printf("{%d, %d, %d, %d}", zero_vector[0], zero_vector[1], zero_vector[2], zero_vector[3]);

 printf("\n\rvector 16\n\r");
 printf("{%d, %d, %d, %d}", vectorOut16[0], vectorOut16[1], vectorOut16[2], vectorOut16[3]);

 printf("\n\rvector 32\n\r");
 printf("{%d, %d, %d, %d}", vectorOut32[0], vectorOut32[1], vectorOut32[2], vectorOut32[3]);

 printf("\n\rvector 12\n\r");
 printf("{%d, %d, %d, %d}", vectorOut12[0], vectorOut12[1], vectorOut12[2], vectorOut12[3]);
    
}