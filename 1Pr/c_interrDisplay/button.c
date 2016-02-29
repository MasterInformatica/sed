/*--- ficheros de cabecera ---*/
#include "44blib.h"
#include "44b.h"
#include "def.h"
#define N 16
/*--- variables globales ---*/
int symbol = 0;
/*--- funciones externas ---*/
//extern void D8Led_Symbol(int value);
/*--- declaracion de funciones ---*/
void Eint4567_ISR(void) __attribute__ ((interrupt ("IRQ")));
void Eint4567_init(void);
extern void leds_switch ();
extern int button_no_pressed();
extern void D8Led_symbol(int value);

/*--- codigo de funciones ---*/
void Eint4567_init(void) {
	/* Configuracion del controlador de interrupciones */
		// Borra EXTINTPND escribiendo 1s en el propio registro
		rEXTINTPND = 0xf;
		// Borra INTPND escribiendo 1s en I_ISPC
		rI_ISPC = 0x3ffffff;
		// Configura las lineas como de tipo IRQ mediante INTMOD
		rINTMOD = 0x0;
		// Habilita int. vectorizadas y la linea IRQ (FIQ no) mediante INTCON
		rINTCON = 0x1;

		// Enmascara todas las lineas excepto Eint4567 y el bit global (INTMSK)
		rINTMSK = ~( BIT_GLOBAL | BIT_EINT4567 );

		// Establecer la rutina de servicio para Eint4567
	    pISR_EINT4567 = (unsigned)Eint4567_ISR;
	/* Configuracion del puerto G */
		// Establece la funcion de los pines (EINT7-EINT0)
		rPCONG = rPCONG & (~0xC0);

		//Habilita las resistencias de pull-up
		rPUPG = 0x0;

		// Configura las lineas de int. como de flanco de bajada mediante EXTINT
		rEXTINT = (rEXTINT & 0x88ffffff) | 0x22000000;

	/* Por precaucion, se vuelven a borrar los bits de INTPND y EXTINTPND */
	    rEXTINTPND = 0xf;
	    rI_ISPC = 0x3ffffff;
}

/*COMENTAR PARA LA PARTE DEL 8-SEGMENTOS
DESCOMENTAR PARA LA PRIMERA PARTE CON INTERRUPCIONES
*//*
void Eint4567_ISR(void)
{
	while(button_no_pressed() != 0);
	//Conmutamos LEDs
	leds_switch();

	//Delay para eliminar rebotes
	DelayMs(100);
*/
	/*Atendemos interrupciones*/
	//Borramos EXTINTPND ambas líneas EINT7 y EINT6
/*  rEXTINTPND = ((1<<2) | (1<<3));

	//Borramos INTPND usando ISPC
	rI_ISPC = BIT_EINT4567;
}
*/
/*
DESCOMENTAR PARA LA PARTE DEL 8-SEGMENTOS
COMENTAR PARA LA PRIMERA PARTE CON INTERRUPCIONES */

int which_int;
void Eint4567_ISR(void)
{
	/*Identificar la interrupcion*/
	which_int = rEXTINTPND;
	unsigned short borrar;
	leds_off();
	/* Actualizar simbolo*/
	switch (which_int) {
	case 0x4://linea 6
		symbol = (symbol + N - 1)%N;
		borrar = (1<<2);

		led1_on();
		break;
	case 0x8://linea 7
		symbol = (symbol + 1)%N;
		borrar = (1<<3);
		led2_on();
			break;
	default:
			break;
	}
	// muestra el simbolo en el display
	D8Led_symbol(symbol);
	// espera 100ms para evitar rebotes
	DelayMs(100);
	
	// borra los bits en EXTINTPND  
	// borra el bit pendiente en INTPND

	rEXTINTPND = borrar;

	//Borramos INTPND usando ISPC
	rI_ISPC = BIT_EINT4567;
}

