/*--- Ficheros de cabecera ---*/
#include "44b.h"
#include "44blib.h"
#include "def.h"

/*--- Definición de macros ---*/
#define KEY_VALUE_MASK 0xF

/*--- Variables globales ---*/
volatile UCHAR *keyboard_base = (UCHAR *)0x06000000;
int key;

/*--- Funciones externas ---*/
void D8Led_symbol(int value);

/*--- Declaracion de funciones ---*/
void keyboard_init();
void Keyboard_ISR(void) __attribute__ ((interrupt ("IRQ")));



/*--- Codigo de las funciones ---*/
void keyboard_init()
{
	/* Configurar el puerto G (si no lo estuviese ya) */	
		// Establece la funcion de los pines (EINT0-7)
		rPCONG = rPCONG | 0xC;

		// Habilita el "pull up" del puerto
		rPUPG = 0x0;

		// Configura las lineas de int. como de flanco de bajada mediante EXTINT
		rEXTINT = rEXTINT | 0x00000030;

		/* Establece la rutina de servicio para EINT1 */
		pISR_EINT1 = (unsigned) Keyboard_ISR;

		// Borra INTPND escribiendo 1s en I_ISPC
		rI_ISPC = BIT_EINT1;

}

void keyboard_activar(){
	//borrar interrupciones pendientes
	rI_ISPC = BIT_EINT1;

	// Habilitar linea EINT1
	rINTMSK = rINTMSK & ~( BIT_EINT1 );

	//borrar interrupciones pendientes
	rI_ISPC = BIT_EINT1;
}

void keyboard_desactivar(){
	// Desabilitar linea EINT1
	rINTMSK = rINTMSK | BIT_EINT1;

	//borrar interrupciones pendientes
	rI_ISPC = BIT_EINT1;
}


void Keyboard_ISR(void)
{
	/* Esperar trp mediante la funcion DelayMs()*/
	DelayMs(20);//trp=20ms

	/* Identificar la tecla */
	int pulsado = key_read();

		if (pulsado > 9){
			pulsado = pulsado - 10;
			Uart_SendByte1(pulsado +'A');
			Uart_SendByte0(pulsado +'A');

		}else{
			Uart_SendByte1(pulsado +'0');
			Uart_SendByte0(pulsado +'0');
		}

	/* Esperar a se libere la tecla: consultar bit 1 del registro de datos del puerto G */
	while (!(rPDATG & 0x2)){}

	/* Esperar trd mediante la funcion Delay() */
	DelayMs(100);//trd=100ms
	/* Borrar interrupción de teclado */
	rI_ISPC = BIT_EINT1;
}

int key_read()
{
	short int i=0;

	int value= -1;
	char temp;
	// Identificar la tecla mediante ''scanning''
	// Para el juego solo es necesario detectar las dos primeras teclas.

	unsigned int offset[4] = {0xFD,0xFB,0xF7,0xEF};

	for(i=0; i<4; i++){
		temp = *(keyboard_base + (offset[i])) & KEY_VALUE_MASK;

		switch (temp) {
			case 0x7:  value = 0 + (i*4); break;
			case 0xB:  value = 1 + (i*4); break;
			case 0xD:  value = 2 + (i*4); break;
			case 0xE:  value = 3 + (i*4); break;
		}
	}

	return value;


}
