/*********************************************************************************************
* Fichero:	uart.h
* Autor:	
* Descrip:	cabecera de las funciones de UART
* Version: <P5-ARM-simple>	
*********************************************************************************************/

#ifndef __UART_H__
#define __UART_H__

#ifdef __cplusplus
extern "C" {
#endif

/*--- definicón de constantes ---*/
#define LF_char 0x0A	/* Caracter de salto de línea */
#define CR_char 0x0D    /* Caracter de retorno de carro */

/*--- prototipos de funciones ---*/
void Uart0_Init(int baud);
void Uart1_Init(int baud);
void Uart_Config(void);
void Uart_TxEmpty0(void);
char Uart_Getch0(void);
void Uart_SendByte0(int data);
void Uart_SendString0(char *pt);
void Uart_Printf0(char *fmt,...);
void Uart_TxEmpty1(void);
char Uart_Getch1(void);
void Uart_SendByte1(int data);
void Uart_SendString1(char *pt);
void Uart_Printf1(char *fmt,...);


void Uart_Process(void);
void Uart_Process1(char c);
void Uart_Process0(char c);


#ifdef __cplusplus
}
#endif

#endif /* __UART_H__ */
