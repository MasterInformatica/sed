/*--- ficheros de cabecera ---*/
#include "44blib.h"
#include "44b.h"
#include "def.h"
#include "stdio.h"
/*--- funciones externas ---*/
extern void leds_off();
extern void led1_on();
extern void leds_switch();
extern void Eint4567_init(void);
/*--- funciones ---*/
void button_init();
int button_no_pressed();

//extern void sys_init();
/*--- declaracion de funciones ---*/
//void Main(void);
/*--- codigo de funciones ---*/
void Main(void)
{
	/* Inicializar controladores */
	sys_init(); // Inicializacion de la placa, interrupciones y puertos
	button_init();
	/* Establecer valor inicial de los LEDs */
	leds_off();
	led1_on();
	while (1){
		while(button_no_pressed() == 0);
		while(button_no_pressed() != 0);
		leds_switch();
		//DelayMs(1000);
	}
}

void button_init(){
	/* Set 0 bits 6 and 7*/
	rPCONG = rPCONG & (~0xC0);
	/* rPUPG to 0's */
	rPUPG = 0x0;

}

int button_no_pressed(){
	UINT r = ~ ( rPDATG | ~ 0xC0 );
	DelayMs(100);
	return r;

}
