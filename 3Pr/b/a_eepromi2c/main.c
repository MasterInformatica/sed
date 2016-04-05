#include "s3cev40.h"
#include "common_types.h"
#include "at24c04.h"
#include "44b.h"
#include "def.h"

extern void DelayMs(int ms_time);
extern void sys_init();
extern void iic_init();
extern void Eint4567_init();
extern void Eint4567_activar();
extern void keyboard_init();
extern void D8Led_symbol(int value);
extern void at24c04_bytewrite( uint16 addr, uint8 data );
extern void at24c04_byteread( uint16 addr, uint8 *data );

int val;
int st;

uint8 dir;
uint8 dato;
int kread;


void practica_init(void){
	rI_ISPC = 0x3ffffff; //borrar interrupciones pendientes

	// Configura las lineas como de tipo IRQ mediante INTMOD
	rINTMOD = 0x0;
	// Habilita int. vectorizadas y la linea IRQ (FIQ no) mediante INTCON
	rINTCON = 0x1;

	// Enmascara todas las lineas excepto Eint4567 y el bit global (INTMSK)
	rINTMSK = ~( BIT_GLOBAL );

	//Iniciamos los distintos componentes

	Eint4567_init();
	Eint4567_activar();
	keyboard_init();

	keyboard_activar();

	//Inicializamos los timers
	//timer1_init();
	//timer23_init();
	//timer4_init();


	//Apagamos todos los leds y 8 segmentos
	//leds_off();
	D8Led_init();

	/* Por precaucion, se vuelven a borrar los bits de INTPND y EXTINTPND */
	rI_ISPC = 0x3ffffff;

	st = 5;

}

void Main( void )
{
    uint8 buffer[AT24C04_DEPTH];
    uint16 i;
    
	sys_init();
	iic_init();
    practica_init();


    //Inicializamos la EEPROM
    for( i=0; i<AT24C04_DEPTH; i++ ){
      val = (uint8)i%16;
      at24c04_bytewrite( i, val );
    }

    for( i=0; i<AT24C04_DEPTH; i++ ){
      at24c04_byteread( i, &buffer[i] );
    }

    DelayMs(100);
/*
    for( i=0; i<AT24C04_DEPTH; i++ ){
      at24c04_byteread( i, &buffer[i] );
      val = buffer[i] & 0xF;
      D8Led_symbol(val);
      DelayMs(100);
    }*/
    int anterior = st;
    uint8 dirtmp;
    while( 1 ){
    	while(anterior == st);
    	switch(st){
		case 0:
			kread=-1;
			break;
		case 1:  // leer mas significativa direccion
			dirtmp = (dirtmp << 4) | (kread & 0xf);
			kread=-1;
			break;
		case 2:  // leer menos significativa direccion
			dirtmp = (dirtmp << 4) | (kread & 0xf);
			kread = -1;

			dir = dirtmp;
			break;
		case 3:  // leer mas significativa dato
		case 4:  // leer menos significativa dato
			dato = (dato << 4) | (kread & 0xf);
			kread = -1;
			break;
		case 5:  // escribir dato
			at24c04_bytewrite( dir, dato );
			kread = -1;
			break;
		case 6:
			at24c04_byteread( dir, &buffer [2] );
			int val = (buffer[2]>>4)&0xF;
			D8Led_symbol(val);
			DelayMs(1000);
			val = buffer[2] & 0xF;
			D8Led_symbol(val);
			DelayMs(1000);
			//D8Led_symbol(anterior);
			kread = -1;
			st = anterior;
					break;
		default: break;
		}
    	anterior = st;
    }
}
