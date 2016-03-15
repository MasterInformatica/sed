/*--- ficheros de cabecera ---*/
#include "44b.h"
#include "44blib.h"
#include "stdlib.h"


extern cuenta;
extern st;
extern luz;
extern D8Led_symbol(int);
extern led1_on(void);
extern led2_on(void);
extern leds_off(void);




//----------------------------------------------------------
void timer1_init(void);

void timer1_activar(void);
void timer1_desactivar(void);

void timer1_ISR(void) __attribute__ ((interrupt ("IRQ")));
//----------------------------------------------------------
void timer23_init(void);

void timer2_activar(void);
void timer2_desactivar(void);
void timer3_activar(void);
void timer3_desactivar(void);

void timer2_ISR(void) __attribute__ ((interrupt ("IRQ")));
void timer3_ISR(void) __attribute__ ((interrupt ("IRQ")));
//----------------------------------------------------------
void timer4_init(void);

void timer4_activar(void);
void timer4_desactivar(void);

void timer4_ISR(void) __attribute__ ((interrupt ("IRQ")));
//----------------------------------------------------------



//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------
void timer1_init(void)
{
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER1;

	/* Establece la rutina de servicio para TIMER1 */
	pISR_TIMER1=(unsigned)timer1_ISR;

	/* Configurar el Timer1 */
	rTCFG0 = rTCFG0 | 0xFF;// pre-escalado = 255
	rTCFG1 = rTCFG1 & (~0x00000F0) ;// reset divisor 1
	rTCFG1 = rTCFG1 | 0x0000010 ;// divisor = 1/4

	// 1- Establece cuenta
	rTCNTB1=65535;
	rTCMPB1=12800;
}


void timer1_activar(void){
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER1;

	//Enmascaramos
	rINTMSK = rINTMSK & ~( BIT_TIMER1 );

	// 2- Manual update
	rTCON = rTCON |  (0x01<<9);// establecer manual_update
	rTCON = rTCON & ~(0x01<<9);// DESACTIVA manual_update
	// 3- Autoreload y Activar
	rTCON = rTCON |  (0x01<<11);//activar modo auto-reload
	rTCON = rTCON |  (0x01<<8);// iniciar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER1;

	cuenta = 0xf;
	D8Led_symbol(cuenta);
}

void timer1_desactivar(void){
	//Desenmascarar
	rINTMSK = rINTMSK | BIT_TIMER1;

	rTCON = rTCON & ~(0x01<<8);// parar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER1;
}

void timer1_ISR(void){
	cuenta --;
	D8Led_symbol(cuenta);

	if(cuenta==0){ //La cuenta ha llegado a 0. Mostramos que no hay ganador
		st = 4;
		timer1_desactivar();
		led1_on();
		led2_on();
		timer2_activar();
	}

	rI_ISPC = BIT_TIMER1;
}

//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------
void timer23_init(void)
{
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = ( BIT_TIMER2 | BIT_TIMER3 );

	/* Establece la rutina de servicio para TIMER2 y TIMER3 */
	pISR_TIMER2=(unsigned)timer2_ISR;
	pISR_TIMER3=(unsigned)timer3_ISR;

	/* Configurar el Timer23 */
	rTCFG0 = rTCFG0 | 0xFF00;// pre-escalado = 255
	rTCFG1 = rTCFG1 & (~0x000FF00) ;// reset divisor 2 y 3
	rTCFG1 = rTCFG1 | 0x0002200 ;// divisor = 1/8

	// 1- Establece cuenta
	rTCNTB2=65535;
	rTCMPB2=12800;
	rTCNTB3=65535;
	rTCMPB3=12800;
}


void timer2_activar(void){
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER2;

	//Enmascaramos
	rINTMSK = rINTMSK & ~( BIT_TIMER2 );

	// 2- Manual update
	rTCON = rTCON |  (0x01<<13);// establecer manual_update
	rTCON = rTCON & ~(0x01<<13);// DESACTIVA manual_update
	// 3- Autoreload y Activar
	rTCON = rTCON & ~(0x01<<15);//activar modo one-shot
	rTCON = rTCON |  (0x01<<12);// iniciar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER2;
}

void timer2_desactivar(void){
	//Desenmascarar
	rINTMSK = rINTMSK | BIT_TIMER2;

	rTCON = rTCON & ~(0x01<<12);// parar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER2;
}

void timer3_activar(void){
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER3;

	//Enmascaramos
	rINTMSK = rINTMSK & ~( BIT_TIMER3 );

	// 2- Manual update
	rTCON = rTCON |  (0x01<<17);// establecer manual_update
	rTCON = rTCON & ~(0x01<<17);// DESACTIVA manual_update
	// 3- Autoreload y Activar
	rTCON = rTCON & ~(0x01<<19);//activar modo one-shot
	rTCON = rTCON |  (0x01<<16);// iniciar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER3;
}

void timer3_desactivar(void){
	//Desenmascarar
	rINTMSK = rINTMSK | BIT_TIMER3;

	rTCON = rTCON & ~(0x01<<16);// parar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER3;

}

void timer2_ISR(void){
	timer2_desactivar();

	st = 6;							//Cambiar al siguiente estado.

	leds_off(); 					//Apagamos todas las luces para empezar la siguiente ronda.
	//D8Led_symbol(-1);
	timer3_activar();

	rI_ISPC = BIT_TIMER2;
}

void timer3_ISR(void){
	D8Led_symbol(3);
	timer3_desactivar();

	st = 2;                 //Cambiar al siguiente estado

	luz = (rand() % 2) + 1; //Encender una luz aleatoria.
	if(luz==1)
		led1_on();
	else
		led2_on();
	timer4_activar();       //iniciar el temporizador 4

	rI_ISPC = BIT_TIMER3;

}

//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------
void timer4_init(void)
{
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER4;

	/* Establece la rutina de servicio para TIMER0 */
	pISR_TIMER4=(unsigned)timer4_ISR;

	/* Configurar el Timer01 */
	rTCFG0 = rTCFG0 | 0xFF0000;// pre-escalado = 255
	rTCFG1 = rTCFG1 & (~0x00F0000) ;// reset divisor 4
	rTCFG1 = rTCFG1 | 0x0010000 ;// divisor = 1/8

	// 1- Establece cuenta
	rTCNTB4=65535;
	rTCMPB4=12800;
}


void timer4_activar(void){
	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER4;

	//Enmascaramos
	rINTMSK = rINTMSK & ~( BIT_TIMER4 );

	// 2- Manual update
	rTCON = rTCON |  (0x01<<21);// establecer manual_update
	rTCON = rTCON & ~(0x01<<21);// DESACTIVA manual_update
	// 3- Autoreload y Activar
	rTCON = rTCON & ~(0x01<<23);//activar modo one-shot
	rTCON = rTCON |  (0x01<<20);// iniciar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER4;
}

void timer4_desactivar(void){
	//Desenmascarar
	rINTMSK = rINTMSK | BIT_TIMER4;

	rTCON = rTCON & ~(0x01<<20);// parar timer

	/* Borrarmos las interrupciones pendientes */
	rI_ISPC = BIT_TIMER4;
}

void timer4_ISR(void){
	timer4_desactivar();

	if(st == 1){
		st = 2;                 //Cambiar al siguiente estado

		luz = (rand() % 2) + 1; //Encender una luz aleatoria.
		if(luz==1)
			led1_on();
		else
			led2_on();
		timer4_activar();       //iniciar el temporizador 4
	}
	else if(st == 2){
		st = 3;					//Cambiar al siguiente estado

		leds_off();				//apagar las luces
		timer1_activar();		//iniciar el temporizador 1

		Eint4567_activar();
		keyboard_activar();
	}

	rI_ISPC = BIT_TIMER4;
}
