#ifndef _DETECT_H
#define _DETECT_H

// Proc
#define MAX_LEN       4096 	// Proc Buffer

/* wir benoetigen die Pins zum Aktivieren der Buse */
struct stpio_pin*	detect1;   // Vip2 Shift register Pin...
struct stpio_pin*	detect2;   // Vip1 Vip1v2 Tuner reset und shift Vip2 Pin ...
struct stpio_pin*	detect3;   // Cimax Boxtype Pin 
struct stpio_pin*	detect4;   // Vip2 Shift register Pin...

/* I2C Check Address of Bus 2 for Boxtype */
#define I2C_BUS2		2 	// I2C Bus 2
#define I2C_0X40		0x40	// Cimax I2C Addresse
#define I2C_0X28		0x28	// Display I2C Adresse

/* I2C Check Bus0 & 1 for Tuner */
#define I2C_TUNERBUS0		0	// I2C Bus 0
#define I2C_TUNERBUS1		1	// I2C Bus 1

/* Tuner Address from I2C */
#define SharpS2			0x68	// SharpS2 Tuner I2C Adresse auf Bus 1 und/oder Bus2 (Vip2 und/oder Vip1v2)
#define RBTuner			0x6a	// RB-Tuner I2C Adresse auf Bus 1 
#define STTuner			0x68	// ST-Tuner I2C Adresse auf Bus 1 
#define LGCabel			0x0c	// LG-Tuner I2C Adresse auf Bus 1 und/oder Bus2 (Vip2 und/oder Vip1v2)
#define Sharpdvbt		0x0f	// Sharp DVB-T Tuner I2C Adresse auf Bus 1 und/oder Bus2 (Vip2 und/oder Vip1v2)

#endif
