/*-------------------------------------------------------------------
**
**  Fichero:
**    s3cev40.h  2/2/2013
**
**    (c) J.M. Mendias
**    Programación de Sistemas y Dispositivos
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Creación de nemotécnicos para acceso a distintos elementos
**    de la placa de prototipado Embest S3CEV40
**
**  Notas de diseño:
**    Las direcciones usadas asumen un alineamiento little-endian
**
**-----------------------------------------------------------------*/

#ifndef __S3CEV40_H__
#define __S3CEV40_H__

#include "common_types.h"

#define CPU   ("S3C44B0X")
#define CLKIN (8000000U)    // Frecuencia base del oscilador (Hz)

/* Mapa de memoria */

#define ROM_START_ADDRESS (0x00000000)
#define ROM_END_ADDRESS   (0x001fffff)
#define ROM_SIZE          (ROM_END_ADDRESS-ROM_START_ADDRESS+1)

#define NON_CACHE_START   (0x02000000)
#define NON_CACHE_END     (0x0bffffff)

#define RAM_START_ADDRESS (0x0c000000)
#define RAM_END_ADDRESS   (0x0c7fffff)
#define RAM_SIZE          (RAM_END_ADDRESS-RAM_START_ADDRESS+1)

#define SP_START_ADDRESS  (0x10000000)
#define SP_END_ADDRESS    (0x100001ff)
#define SP_SIZE           (SP_END_ADDRESS-SP_START_ADDRESS+1)

/* Tiempos de rebote en ms */

#define KEYPAD_KEYDOWN_DELAY  (30)
#define KEYPAD_KEYUP_DELAY   (100)
#define PB_KEYDOWN_DELAY      (30)
#define PB_KEYUP_DELAY       (100)

#endif 
