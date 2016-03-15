/*
 * system.c

 *
 *  Created on: 14/03/2014
 *      Author: Alberto
 */

//#include "s3c44b0x.h"
#include "s3cev40.h"
#include "common_types.h"
#include "44b.h"
#include "system.h"

static uint32 clk_normal = CLKIN;  // Frecuencia en modo normal (Hz)
static uint32 clk_slow = CLKIN;	   // Frecuencia en modo slow (Hz)
uint32 mclk = CLKIN;			   // Frecuencia actual del reloj (Hz)

void DelayMs(int ms_time)
{
	int i;

	for( i = 0 ; i < 1000*ms_time ; i++ )
		;
}

void sys_init( void )
{
	rWTCON  = 0;				// deshabilita el watchdog
	rINTMSK = ~0;			// enmascara todas las interrupciones

	// Configuracion del gestor de reloj
	rLOCKTIME   = 0xfff;		// estabilización del PLL = 512 us
	rPLLCON     = 0x38021;	// MCLK = 64MHz
	clk_normal = 64000000;
	rCLKSLOW    = 0x8;		// MCLK_SLOW = 500 KHz
	clk_slow   = 500000;
	rCLKCON     = (1<<10) | (1<<7); 	// modo NORMAL y todos los controladores desactivados menos el BDMA y GPIO (para poder acceder a todos lo perifericos y a los puertos)
	mclk       = clk_normal;

	// Configuracion del arbitro de bus
	rSBUSCON = 0x8000001b;	// prioridad fija por defecto LCD > ZDMA > BDMA > IRQ

	// Configuracion de cache
	rSYSCFG = 0;				// deshabilitada

	// Configuacion del controlador de interrupciones
	rI_PMST = 0x1f1b;		// prioridades fijas por defecto
	rI_PSLV = 0x1b1b1b1b;
	rINTMOD = 0;				// todas las interrupciones en modo IRQ
	rEXTINTPND = ~0;			// borra las interrupciones externas pendientes por linea EINT7..4
    rI_ISPC = ~0;			// borra todas las interrupciones pendientes
	rINTCON = 1;				// IRQ vectorizadas, linea IRQ activada, linea FIQ desactivada

	// Configuracion de puertos
	port_init();
}


inline void port_init( void )
{

	rPDATA = ~0;
	rPCONA = (0x7f<<1);		// PA[7:1] = ADDR[22:16], resto = out

	rPDATB = ~0;
	rPCONB = (1<<8) | (1<<6) | (0xf);	// PA[8] = nGCS3, PA[6] = nGCS1, PA[3:0] = (nSRAS, nSCAS, SCLK, SCKE), resto = out

	rPDATC = ~0;
	rPCONC = 0x55555555;		// PC[x] = out
	rPUPC  = ~0;		 		// Pull-up disable

	rPDATD = ~0;
	rPCOND = 0x5555;			// PD[x] = out
	rPUPD  = ~0;				// Pull-up disable

	rPDATE = ~0;
	rPCONE = 0x15555; 		// PE[x] = out
	rPUPE  = ~0;		 		// Pull-up disable

	rPDATF = ~0;
	rPCONF = 0x002555; 		// PF[8] = in, PF[7] = in, resto = out
	rPUPF  = ~0;			 	// Pull-up disable

	rPDATG = ~0;
	rPCONG = 0x5555;			// PG[x] = out
	rPUPG  = ~0;		 		// Pull-up disable

	rSPUCR = 0x7;			// DATA[15:0] Pull-up disable

	rEXTINT = 0x22222222;	// Falling edge triggered
}


