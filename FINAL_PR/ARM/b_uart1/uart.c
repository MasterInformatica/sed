/*********************************************************************************************
* Fichero:	uart.c
* Autor:	
* Descrip:	funciones de UART
* Version: <P6-ARM-simple>	
*********************************************************************************************/

/*--- ficheros de cabecera ---*/
#include "44b.h"
#include "uart.h"
#include <stdarg.h>
#include <stdio.h>

/*--- implementación de las funciones ---*/
void Uart0_Init(int baud)
{
    /* UART0 */
    rULCON0=0x3;     // Modo normal, no paridad, 1b stop, 8b char
    rUCON0=0x205;    // tx=nivel, rx=flanco, no rx-timeout ni rx-error, normal, int/polling 
    rUBRDIV0=( (int)(MCLK/16./baud + 0.5) -1 ); // formula division de frecuencia
    rUFCON0=0x0;     // Desactivar FIFO
    rUMCON0=0x0;	 // Desactivar control de flujo
}

void Uart1_Init(int baud)
{
    /* UART1 */
    rULCON1=0x3;     // Modo normal, no paridad, 1b stop, 8b char
    rUCON1=0x205;    // tx=nivel, rx=flanco, no rx-timeout ni rx-error, normal, int/polling
    rUBRDIV1=( (int)(MCLK/16./baud + 0.5) -1 ); // formula division de frecuencia
    rUFCON1=0x0;	// Desactivar FIFO
    rUMCON1=0x0;	// Desactivar control de flujo
}

void Uart_Config(void)
{
    // Si no se usan interrupciones, no es necesario hacer nada
}

inline void Uart_TxEmpty0(void)
{
    while (!(rUTRSTAT0 & 0x4)); 	     // esperar a que el shifter de TX se vacie
}

char Uart_Getch0(void)
{
    while (!(rUTRSTAT0 & 0x1));        // esperar a que el buffer contenga datos
	return RdURXH0();		   		   // devolver el caracter
}

void Uart_SendByte0(int data)
{
    char localBuf[2] = {'\0','\0'};

    if(data == '\n')		
	{
	   while (!(rUTRSTAT0 & 0x2));     // esperar a que THR se vacie
	   WrUTXH0('\r');			       // escribir retorno de carro (utilizar macro)
	}
	while (!(rUTRSTAT0 & 0x2)); 	   // esperar a que THR se vacie
	WrUTXH0(data);				       // escribir data (utilizar macro)
}

void Uart_SendString0(char *pt)
{
    while (*pt)						    // mandar byte a byte hasta completar string
	Uart_SendByte0(*pt++);
}

void Uart_Printf0(char *fmt,...)
{
    va_list ap;
    char string[256];

    va_start(ap,fmt);
    vsprintf(string,fmt,ap);
    Uart_SendString0(string);
    va_end(ap);
}

inline void Uart_TxEmpty1(void)
{
    while (!(rUTRSTAT1 & 0x4)); 	     // esperar a que el shifter de TX se vacie
}

char Uart_Getch1(void)
{
    while (!(rUTRSTAT1 & 0x1));        // esperar a que el buffer contenga datos
	return RdURXH1();		   		   // devolver el caracter
}

void Uart_SendByte1(int data)
{
    char localBuf[2] = {'\0','\0'};

  /*  if(data == '\n')
	{
	   while (!(rUTRSTAT1 & 0x2));     // esperar a que THR se vacie
	   WrUTXH1('\r');			       // escribir retorno de carro (utilizar macro)
	}*/
	while (!(rUTRSTAT1 & 0x2)); 	   // esperar a que THR se vacie
	WrUTXH1(data);				       // escribir data (utilizar macro)
}

void Uart_SendString1(char *pt)
{
    while (*pt)						    // mandar byte a byte hasta completar string
	Uart_SendByte1(*pt++);
}

void Uart_Printf1(char *fmt,...)
{
    va_list ap;
    char string[256];

    va_start(ap,fmt);
    vsprintf(string,fmt,ap);
    Uart_SendString1(string);
    va_end(ap);
}

void Uart0_Process(char c){
  int ps = (int) c;
  int ps_me = ps & 0x0F;
  D8Led_symbol(ps_me);
  ps = (ps >> 4);
  Uart_SendByte1(ps);
}

void Uart1_Process(char c){
  if(c == '1'){
    led1_on();
    led2_off();
    Uart_SendByte0('3');
  }else  if(c == '2'){
    led1_off();
    led2_on();
    Uart_SendByte0('4');
  }else{
    led1_on();
    led2_on();
  }
}

void Uart_Process(void)
{
  while(!(rUTRSTAT0 & 0x1) || !(rUTRSTAT1 & 0x1));
  if(!(rUTRSTAT0 & 0x1)){
    Uart0_Process(RdURXH0());
  }
  if(!(rUTRSTAT1 & 0x1)){
    Uart1_Process(RdURXH1());
  }
}
