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

/*--- codigo de la funcion ---*/
int Main(void){

	char *pt_str = str;

	sys_init(); // inicializacion de la placa, interrupciones, puertos

	Uart_Init(115200); // inicializacion de la Uart
	Uart_Config(); // configuración de interrupciones y buffers
	Uart_Printf(str_send); // mostrar cabecera

	while(1){
		*pt_str = Uart_Getch(); // leer caracter
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
}
