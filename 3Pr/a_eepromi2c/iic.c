#include "44b.h"
#include "iic.h"

extern uint32 mclk;			   // Frecuencia actual del reloj (Hz)

extern void DelayMs(int ms_time);

void iic_init( void )
{
	// Enable IIC & GPIO & BDMA blocks (si no se activa BDMA, el controlador IIC no es accesible)
	rCLKCON = rCLKCON | (1<<13) 	// IIC
					  | (1<<10)		// GPIO
					  | (1<<7);		// BDMA
	
	// PF[1] = IICSDA, PF[0] = IICSCL
	rPCONF = (rPCONF & ~0xF) | 0x2  // IICSCL
							 | 0x8; // IICSDA
	// Pull-up enable
	rPUPF = 0x0;
    //Configurar la dirección del slave
	rIICADD = S3C44B0X_SLAVE_ADDRESS;
    //Generación ACK habilitada, interrupciones habilitadas
	rIICCON = rIICCON | (1<<5)		// interrupciones
					  | (1<<7);		// ACK
	
    rIICCON = rIICCON | ((mclk / 4000000 - 1) & 0xf); 	//Valor de preescalado, PREESCALER = mclk/16/250000 -1
	
    // Activa Tx/Rx
    rIICSTAT = rIICSTAT | (1<<4);
}
/*
 * When a master initiates a Start condition, it should send a slave address to notify the slave device.
 *  The one byte of address field consist of a 7-bit address and a 1-bit transfer direction indicator (that is, write or read).
 *  If bit 8 is 0, it indicates a write operation(transmit operation);
 *  if bit 8 is 1, it indicates a request for data read(receive operation).
 */
void iic_putByte_start( uint8 byte )
{
	// Escribe el dato
	// Máster Tx, start condition, Tx/Rx habilitada
	// Comienza la transmisión (borrando pending bit del IICCON)
    // Espera la recepción de ACK  
}

void iic_putByte( uint8 byte )
{
    // Escribe el dato
	// Comienza la transmisión del dato (borrando pending bit del IICCON)
    // Espera la recepción de ACK  
};

void iic_putByte_stop( uint8 byte )
{
    // Escribe el dato
	// Comienza la trasmisión del dato (borrando pending bit del IICCON)
    // Espera la recepción de ACK  
    
    // Máster Tx, stop condition, Tx/Rx habilitada
    // Comienza la trasmisión de STOP (borrando pending bit del IICCON)
    // Espera a que la stop condition tenga efecto (5 ms para la at24c04)
}

void iic_getByte_start( uint8 byte )
{
	// Escribe el dato
    // Máster Rx, start condition, Tx/Rx habilitada
    // Comienza la transmisión (borrando pending bit del IICCON)
    // Espera la rececpión de ACK
}

uint8 iic_getByte( void )
{
    // Reanuda la recepción (borrando pending bit del IICCON)
	// Espera la recepción del dato
    return rIICDS;// Lee el dato
}

uint8 iic_getByte_stop( int8 ack )
{
	uint8 byte;

    rIICCON = (rIICCON & ~(1 << 7)) | (ack << 7); // Habilita/deshabilita la generación de ACK

    // Reanuda la recepción (borrando pending bit del IICCON)
	
	// Espera la recepción del dato
	
    byte = rIICDS;	// Lee el dato

   	// Máster Rx, stop condition, Tx/Rx habilitada
   	// Comienza la trasmisión de STOP (borrando pending bit del IICCON)
   	// Espera a que la stop condition tenga efecto (5 ms para la at24c04)

	rIICCON |= (1<<7); // Habilita la generación de ACK
   	return byte;
}
