#ifndef _DETECT_H
#define _DETECT_H

// Proc
#define MAX_LEN       4096

/* wir benoetigen die Pins zum Aktivieren der Buse */
struct stpio_pin*	detect1;   // dieser Pin ist bei allen Boxen gleich...
struct stpio_pin*	detect2;   // dieser Pin ist bei allen Boxen gleich...
struct stpio_pin*	detect3;   // dieser Pin ist bei allen Boxen gleich...

/* I2C Check Address of Bus 2 for Boxtype */
#define I2C_BUS2		2
#define I2C_0X40		0x40
#define I2C_0X28		0x28

/* I2C Check Bus0 & 1 for Tuner */
#define I2C_TUNERBUS0		0
#define I2C_TUNERBUS1		1

/* Tuner Address from I2C */
#define SharpS2			0x68
#define RBTuner			0x6a
#define STTuner			0x68
#define LGCabel			0x0c
#define Sharpdvbt		0x0f

#endif
