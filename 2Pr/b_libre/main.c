/*--- ficheros de cabecera ---*/
#include "44blib.h"
#include "44b.h"
#include "stdio.h"


/*--- funciones externas ---*/
//TODO

/*--- declaracion de funciones ---*/
void Main(void);
void game_init(void);

/*--- Variables globales del juego ---*/
int st; //Estado actual del juego.
int luz; //1 = izq, 2 = dcha
int cuenta;

void Main(void)
{
	/* Inicializacion */
	sys_init();
	game_init();

	//Inicio de la ejecucion
	st = 1;
	timer4_activar();

	while (1){};
}



void game_init(void){
	rI_ISPC = 0x3ffffff; //borrar interrupciones pendientes

	// Configura las lineas como de tipo IRQ mediante INTMOD
	rINTMOD = 0x0;
	// Habilita int. vectorizadas y la linea IRQ (FIQ no) mediante INTCON
	rINTCON = 0x1;

	// Enmascara todas las lineas excepto Eint4567 y el bit global (INTMSK)
	rINTMSK = ~( BIT_GLOBAL );

	//Iniciamos los distintos componentes
	Eint4567_init();
	keyboard_init();

	//Inicializamos los timers
	timer1_init();
	timer23_init();
	timer4_init();


	//Apagamos todos los leds y 8 segmentos
	leds_off();
	D8Led_init();

	/* Por precaucion, se vuelven a borrar los bits de INTPND y EXTINTPND */
	rI_ISPC = 0x3ffffff;
}
