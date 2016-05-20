/*--- ficheros de cabecera ---*/
#include "44blib.h"
#include "44b.h"
#include "uart.h"
/*--- declaracion de funciones ---*/
int Main(void);

/*--- variables globales ---*/
char str_send[10] = "\nSED-P4 >\0";
char str_error[50] = "\nSe ha producido un desbordamiento!\n\0";
char str[256];

void initPractica();
extern int key;
/*--- codigo de la funcion ---*/
int Main(void){

	char *pt_str = str;

	sys_init(); // inicializacion de la placa, interrupciones, puertos
	key = 0;
	Uart0_Init(115200); // inicializacion de la Uart
	Uart1_Init(115200); // inicializacion de la Uart
	Uart_Config(); // configuración de interrupciones y buffers

	initPractica();
	Eint4567_activar();
	keyboard_activar();

	char c;
	int k;
	while(1){
	  Uart_Process();
	}
}


void initPractica(){
	rI_ISPC = 0x3ffffff; //borrar interrupciones pendientes

	// Configura las lineas como de tipo IRQ mediante INTMOD
	rINTMOD = 0x0;
	// Habilita int. vectorizadas y la linea IRQ (FIQ no) mediante INTCON
	rINTCON = 0x1;

	// Enmascara todas las lineas excepto el bit global (INTMSK)
	rINTMSK = ~( BIT_GLOBAL );

	//Iniciamos los distintos componentes
	Eint4567_init();
	keyboard_init();


	//Apagamos todos los leds y 8 segmentos
	leds_off();
	D8Led_init();

	/* Por precaucion, se vuelven a borrar los bits de INTPND y EXTINTPND */
	rI_ISPC = 0x3ffffff;
}
