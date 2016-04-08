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

/*--- codigo de la funcion ---*/
int Main(void){

	char *pt_str = str;

	sys_init(); // inicializacion de la placa, interrupciones, puertos

	Uart_Init(115200); // inicializacion de la Uart
	Uart_Config(); // configuración de interrupciones y buffers
//	Uart_Printf(str_send); // mostrar cabecera

	initPractica();
	Eint4567_activar();


	char c;
	while(1){
		c = Uart_Getch1();
		if(c == 'I'){
			led1_off();
			led2_on();
		} else if(c=='D'){
			led1_on();
			led2_off();
		} else {
			led1_off();
			led2_off();
		}
	};
/*		*pt_str = Uart_Getch(); // leer caracter
		Uart_SendByte(*pt_str); // enviar caracter
		if (*pt_str == CR_char){ // retorno de carro?
			if (pt_str != str) { // si cadena no vacia, mostrar
				*(++pt_str) = '\0'; // terminar cadena antes
				Uart_Printf("\n");
				Uart_Printf(str);
			}
			Uart_Printf(str_send); // preparar siguiente
			pt_str = str;
		}
		else if (++pt_str == str + 255){ // desbordamiento?
			Uart_Printf(str_error); // avisar del desbordamiento
			pt_str = str;
		}
	}
*/
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
