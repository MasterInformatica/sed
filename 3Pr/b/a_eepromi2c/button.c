#include "44b.h"
#include "def.h"
#include "common_types.h"

void Eint4567_ISR(void) __attribute__ ((interrupt ("IRQ")));
void Eint4567_init(void);
extern int button_no_pressed();

extern luz;
extern st;

extern dir;
extern dato;
extern kread;

uint8 dirtmp;

void Eint4567_init(void) {
	/* Configuracion del controlador de interrupciones */
		//Borrar interrupciones pendientes.
		rI_ISPC = BIT_EINT4567;
		rEXTINTPND = 0xf;

		// Establecer la rutina de servicio para Eint4567
	    pISR_EINT4567 = (unsigned)Eint4567_ISR;

	/* Configuracion del puerto G */
		// Establece la funcion de los pines (EINT7-EINT0)
		rPCONG = rPCONG | (0xF000);

		//Habilita las resistencias de pull-up
		rPUPG = 0x0;

		// Configura las lineas de int. como de flanco de bajada mediante EXTINT
		rEXTINT = rEXTINT | 0x33000000;

	/* Por precaucion, se vuelven a borrar los bits de INTPND y EXTINTPND */
	    rEXTINTPND = 0xf;
	    rI_ISPC = BIT_EINT4567;
}


void Eint4567_ISR(void)
{
	while(button_no_pressed() != 0);

	int pulsado = rEXTINTPND & 0xC;


	if(pulsado == 4){ //izq
		if(st==4 || st == 5 || kread!=-1){
			st=(st+1)%6;
		}
	} else if(pulsado==8){ //dcha
		st = 6;
	}
	if(st != 6)
		D8Led_symbol((st+1)%6);

	//Delay para eliminar rebotes
	DelayMs(100);

	/*Atendemos interrupciones*/
	//Borramos EXTINTPND ambas l�neas EINT7 y EINT6
	rEXTINTPND = 0xf; //((1<<2) | (1<<3));

	//Borramos INTPND usando ISPC
	rI_ISPC = BIT_EINT4567;
}


void Eint4567_activar(void){
	//borrar interrupciones pendientes
	rEXTINTPND = 0xf;
	rI_ISPC = BIT_EINT4567;

	//enmascarar la linea de interrupcion
	rINTMSK = rINTMSK & ~( BIT_EINT4567 );

	//borrar interrupciones pendientes
	rEXTINTPND = 0xf;
	rI_ISPC = BIT_EINT4567;
}


void Eint4567_desactivar(void){
	//desenmarcarar la linea de interrupcion
	rINTMSK = rINTMSK | BIT_EINT4567;

	//borrar interrupciones pendientes
	rEXTINTPND = 0xf;
	rI_ISPC = BIT_EINT4567;
}


int button_no_pressed(){
	UINT r = ~ ( rPDATG | ~ 0xC0 );
	DelayMs(100);
	return r;
}
