/*--- ficheros de cabecera ---*/
#include "44blib.h"
#include "44b.h"
#include "def.h"
/*--- variables globales ---*/
int symbol = 0;
/*--- funciones externas ---*/
//extern void D8Led_Symbol(int value);
/*--- declaracion de funciones ---*/
void Eint4567_ISR(void) __attribute__ ((interrupt ("IRQ")));
void Eint4567_init(void);
extern void leds_switch ();
extern void D8Led_symbol(int value);
/*
.equ K_INTCON, 0x5
.equ K_INTMOD, 0x0
.equ K_INTMSK, 0x200000
.equ K_EXTINTPND, 0x200000
.equ K_EXTINT, 0x22222222
.equ K_I_ISPC, 0x3FFFFFF
 */
/*--- codigo de funciones ---*/
void Eint4567_init(void)
{
/* Configuracion del controlador de interrupciones */
	// Borra EXTINTPND escribiendo 1s en el propio registro
	rEXTINTPND = 0xFF;
	// Borra INTPND escribiendo 1s en I_ISPC
	rI_ISPC =  0x3FFFFFF;
	// Configura las lineas como de tipo IRQ mediante INTMOD
	rINTMOD = 0x0000000;
	// Habilita int. vectorizadas y la linea IRQ (FIQ no) mediante INTCON
	rINTCON = 0x1;
	// Enmascara todas las lineas excepto Eint4567 y el bit global (INTMSK)
	// BIT_GLOBAL | BIT_EINT4567
	rINTMSK = (~0x0) & (~ ( (1<<26) | (1<<21) ));
	// Establecer la rutina de servicio para Eint4567
	pISR_EINT4567 = (unsigned) Eint4567_ISR;

/* Configuracion del puerto G */
	// Establece la funcion de los pines (EINT7-EINT0)
	rPCONG = rPCONG & (~0xC0); //6 y 7
	// Habilita las resistencias de pull-up
	rPUPG = 0x0;
	// Configura las lineas de int. como de flanco de bajada mediante EXTINT
	rEXTINT =  0x22000000;//(rEXTINT & 0x88ffffff) |
/* Por precaucion, se vuelven a borrar los bits de INTPND y EXTINTPND */

	rI_ISPC =  0x3FFFFFF;
	rEXTINTPND =  0xFF;
}

/*COMENTAR PARA LA PARTE DEL 8-SEGMENTOS
DESCOMENTAR PARA LA PRIMERA PARTE CON INTERRUPCIONES
*/
void Eint4567_ISR(void)
{
	//Conmutamos LEDs
	leds_switch();
	//Delay para eliminar rebotes
	DelayMs(5000);
	/*Atendemos interrupciones*/
	//Borramos EXTINTPND ambas líneas EINT7 y EINT6
	rEXTINTPND = 0xFF;
	//Borramos INTPND usando ISPC
	rI_ISPC =  0x3FFFFFF;
}

/*
DESCOMENTAR PARA LA PARTE DEL 8-SEGMENTOS
COMENTAR PARA LA PRIMERA PARTE CON INTERRUPCIONES
int which_int;
void Eint4567_ISR(void)
{
	/*Identificar la interrupcion*/
	//which_int = rEXTINTPND;
	/* Actualizar simbolo*/
	//switch (which_int) {
	//
	//}
	// muestra el simbolo en el display
	// espera 100ms para evitar rebotes
	
	// borra los bits en EXTINTPND  
	// borra el bit pendiente en INTPND
/*}
*/
