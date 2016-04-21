/*--- ficheros de cabecera ---*/
#include "44b.h"
#include "44blib.h"
/*--- definicion de macros ---*/
/* Mapa de bits de cada segmento
(valor que se debe escribir para que se ilumine el segmento) */
#define SEGMENT_A 0x7F
#define SEGMENT_B 0xBF
#define SEGMENT_C 0xDF 
#define SEGMENT_D 0xF7 
#define SEGMENT_E 0xFB 
#define SEGMENT_F 0xFD 
#define SEGMENT_G 0xFE 
#define SEGMENT_P 0xEF 

#define DIGIT_F (SEGMENT_A & SEGMENT_G & SEGMENT_E & SEGMENT_F)
#define DIGIT_E (SEGMENT_A & SEGMENT_G & SEGMENT_E & SEGMENT_F & SEGMENT_D)
#define DIGIT_D (SEGMENT_B & SEGMENT_C & SEGMENT_D & SEGMENT_F & SEGMENT_E)
#define DIGIT_C (SEGMENT_A & SEGMENT_D & SEGMENT_E & SEGMENT_G)
#define DIGIT_B (SEGMENT_C & SEGMENT_D & SEGMENT_F & SEGMENT_E & SEGMENT_G)
#define DIGIT_A (SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_F & SEGMENT_E & SEGMENT_G)
#define DIGIT_9 (SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_F & SEGMENT_G)
#define DIGIT_0 (SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_G)
#define DIGIT_1 (SEGMENT_B & SEGMENT_C)
#define DIGIT_2 (SEGMENT_A & SEGMENT_B & SEGMENT_F & SEGMENT_E & SEGMENT_D)
#define DIGIT_3 (SEGMENT_A & SEGMENT_B & SEGMENT_F & SEGMENT_C & SEGMENT_D)
#define DIGIT_4 (SEGMENT_B & SEGMENT_C & SEGMENT_F & SEGMENT_G)
#define DIGIT_5 (SEGMENT_A & SEGMENT_C & SEGMENT_D & SEGMENT_F & SEGMENT_G)
#define DIGIT_6 (SEGMENT_A & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_F & SEGMENT_G)
#define DIGIT_7 (SEGMENT_A & SEGMENT_B & SEGMENT_C)
#define DIGIT_8 (SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_F & SEGMENT_G)

/*--- variables globales ---*/
/* tabla de segmentos */
int Symbol[] = {
	SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_G, 					//0
	SEGMENT_B & SEGMENT_C,																	//1
	SEGMENT_A & SEGMENT_B & SEGMENT_F & SEGMENT_E & SEGMENT_D,								//2
	SEGMENT_A & SEGMENT_B & SEGMENT_F & SEGMENT_C & SEGMENT_D,								//3
	SEGMENT_G & SEGMENT_F & SEGMENT_B & SEGMENT_C,											//4
	SEGMENT_A & SEGMENT_G & SEGMENT_F & SEGMENT_C & SEGMENT_D,								//5
	SEGMENT_A & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_F & SEGMENT_G, 					//6
	SEGMENT_A & SEGMENT_B & SEGMENT_C ,												 		//7
	SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_F & SEGMENT_G, 		//8
	SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_F & SEGMENT_G, 								//9
	SEGMENT_A & SEGMENT_B & SEGMENT_C & SEGMENT_E & SEGMENT_F & SEGMENT_G, 					//A
	SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_F & SEGMENT_G, 								//B
	SEGMENT_D & SEGMENT_E & SEGMENT_F,												 		//C
	SEGMENT_B & SEGMENT_C & SEGMENT_D & SEGMENT_E & SEGMENT_F, 								//D
	SEGMENT_A & SEGMENT_D & SEGMENT_E & SEGMENT_F & SEGMENT_G, 								//E
	SEGMENT_A & SEGMENT_E & SEGMENT_F & SEGMENT_G									 		//F
};

/*--- declaracion de funciones ---*/
void D8Led_init(void);
void D8Led_symbol(int value);


void D8Led_init(void) {
	LED8ADDR = 0xFF;
}

void D8Led_symbol(int value)
{
	if(value < 0)
		LED8ADDR = 0xFF;
	else
		LED8ADDR=Symbol[value]; // muestra Symbol[value] en el display
}
