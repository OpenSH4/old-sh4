/* Dieser Treiber Laed benoetigte Pio Pins 
 * um den Boxtype und den Tuner ermitteln zu
 * koennen noch bevor das avs oder der Tuner 
 * geladen wurde, wir aktivieren die pios um
 * damit zeitgleich auch die I2C zu reaktivieren
 * um diese dann je nach dem was verfuegbar ist
 * zu ermitteln, da bei allen Boxen andere i2c
 * Addressen aktiviert werden durch die Pios 
 * koennen wir abfrage welche eine Positive 
 * rueckantwort geben und daraus erschliessen um
 * welchen Boxtype und um welchen Tuner es sich handelt
 */
#include <linux/module.h>	/* Specifically, a module */
#include <linux/kernel.h>	/* We're doing kernel work */
#include <linux/proc_fs.h>
#include <linux/kallsyms.h>
#include <linux/init.h>
#include <linux/i2c.h>
#include <asm/uaccess.h>
#include <linux/stm/pio.h>

#include <linux/string.h>
#include <linux/vmalloc.h>

#include "detect.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

/* Tuner register Vip2 reset for Tuner Scan 
   This use only by Boxtype = Vip2 detect  */
static unsigned char fctl = 0;

#define SRCLK_CLR() {stpio_set_pin(detect1, 0);}
#define SRCLK_SET() {stpio_set_pin(detect1, 1);}

#define RCLK_CLR() {stpio_set_pin(detect2, 0);}
#define RCLK_SET() {stpio_set_pin(detect2, 1);}

#define SDA_CLR() {stpio_set_pin(detect4, 0);}
#define SDA_SET() {stpio_set_pin(detect4, 1);}

void hc595_out(unsigned char ctls, int state)
{
	int i;

	if(state)
		fctl |= 1 << ctls;
	else
		fctl &= ~(1 << ctls);

	SDA_CLR();
	SRCLK_CLR();

    for(i = 7; i >=0; i--)
	{
    	SRCLK_CLR();
		if(fctl & (1<<i))
		{
			SDA_SET();
		}
		else
		{
			SDA_CLR();
		}
		SRCLK_SET();
	}

    RCLK_CLR();
    RCLK_SET();
}

///////////////////////////////////////////////////////////////////////////////////////////////////

static int detected_boxid;
static char *Boxtype;		// Statisch Boxtype
static char *Tunertype;		// Statisch Tuner Type 1
static char *Tunertype2;	// Statisch Tuner Type 2 (Vip2)

int read_info( char *page, char **start, off_t off,int count, int *eof, void *data );
ssize_t write_info( struct file *filp, const char __user *buff,unsigned long len, void *data );

static struct proc_dir_entry *proc_entry;
static struct proc_dir_entry *proc_entry_tuner1;
static struct proc_dir_entry *proc_entry_tuner2;

static char *info;
static int write_index;
static int read_index;

// -------------------------------------------------------------
/* I2C Write Funktion */
static int i2c_autodetect (struct i2c_adapter *adapter, unsigned char i2c_addr, unsigned char dev_addr)
{
  	unsigned char buf[2] = { 0, 0 };
  	struct i2c_msg msg[] = { 
		{ .addr = i2c_addr, .flags = 0, .buf = &dev_addr, .len = 1 },
		{ .addr = i2c_addr, .flags = I2C_M_RD, .buf = &buf[0], .len = 1 } 
	};
  	int b;

  	b = i2c_transfer(adapter,msg,1);
  	b |= i2c_transfer(adapter,msg+1,1);

  	if (b != 1) 
		return -1;

  	return buf[0];
}

int TunerScan(char *Boxtype)
{
	struct i2c_adapter *adap;
	
	/* Check I2CBus and Tuner Address */
	if(Boxtype == "Vip1") 
	{
	  	/* Bus 0 Check */
		if((adap = i2c_get_adapter(I2C_TUNERBUS0)) == NULL) {
			printk("[DETECT] -> Autodetection failed. I2C Tunerbus error\n");
			return 0;
		}
		/* Ist 0x6a auf Bus 0 vorhanden setzen wir RB-Tuner */
		if(i2c_autodetect(adap, RBTuner, 0x0) != -1 ) {
			Tunertype = "stb6100";
		}
		/* Ist 0x68 auf Bus 0 vorhanden setzen wir ST-Tuner */
		if(i2c_autodetect(adap, STTuner, 0x0) != -1 ) {
			Tunertype = "stb6110x";
		}
		/* Ist 0x0c auf Bus 0 vorhanden setzen wir LG-Tuner */
		if(i2c_autodetect(adap, LGCabel, 0x0) != -1 ) {
			Tunertype = "lg031";
		}
		/* Ist 0x0f auf Bus 0 vorhanden setzen wir Sharp DVBT Tuner */
		if(i2c_autodetect(adap, Sharpdvbt, 0x0) != -1 ) {
			Tunertype = "sharp6465";
		}
	}
	if(Boxtype == "Vip1v2") 
	{
	  	/* Bus 0 Check */
		if((adap = i2c_get_adapter(I2C_TUNERBUS0)) == NULL) {
			printk("[DETECT] -> Autodetection failed. I2C Tunerbus error\n");
			return 0;
		}
		/* Ist 0x0c auf Bus 0 vorhanden setzen wir LG-Tuner */
		if(i2c_autodetect(adap, LGCabel, 0x0) != -1 ) {
			Tunertype = "lg031";
		}
		/* Ist 0x0f auf Bus 0 vorhanden setzen wir Sharp DVBT Tuner */
		if(i2c_autodetect(adap, Sharpdvbt, 0x0) != -1 ) {
			Tunertype = "sharp6465";
		}
		/* Ist 0x68 auf Bus 0 vorhanden setzen wir SharpS2-Tuner(Ist zwar die gleiche Adresse wie ST-Tuner, diese sind aber nicht im Vip1v2 und Vip2 verbaut ;)) */
		if(i2c_autodetect(adap, SharpS2, 0x0) != -1 ) {
			Tunertype = "sharp7306";
		}
	}
	if(Boxtype == "Vip2") 
	{
		/* Bus 0 Check */
		if((adap = i2c_get_adapter(I2C_TUNERBUS0)) == NULL) {
			printk("[DETECT] -> Autodetection failed. I2C Tunerbus error\n");
			return 0;
		}
		/* Ist 0x0c auf Bus 0 vorhanden setzen wir LG-Tuner */
		if(i2c_autodetect(adap, LGCabel, 0x0) != -1 ) {
			Tunertype = "lg031";
		}
		/* Ist 0x0f auf Bus 0 vorhanden setzen wir Sharp DVBT Tuner */
		if(i2c_autodetect(adap, Sharpdvbt, 0x0) != -1 ) {
			Tunertype = "sharp6465";
		}
		/* Ist 0x68 auf Bus 0 vorhanden setzen wir SharpS2-Tuner(Ist zwar die gleiche Adresse wie ST-Tuner, diese sind aber nicht im Vip1v2 und Vip2 verbaut ;)) */
		if(i2c_autodetect(adap, SharpS2, 0x0) != -1 ) {
			Tunertype = "sharp7306";
		}
		/* Bus 1 Check */
		if((adap = i2c_get_adapter(I2C_TUNERBUS1)) == NULL) {
			printk("[DETECT] -> Autodetection failed. I2C Tunerbus error\n");
			return 0;
		}
		/* Ist 0x0c auf Bus 1 vorhanden setzen wir LG-Tuner */
		if(i2c_autodetect(adap, LGCabel, 0x0) != -1 ) {
			Tunertype2 = "lg031";
		}
		/* Ist 0x0f auf Bus 1 vorhanden setzen wir Sharp DVBT Tuner */
		if(i2c_autodetect(adap, Sharpdvbt, 0x0) != -1 ) {
			Tunertype2 = "sharp6465";
		}
		/* Ist 0x68 auf Bus 1 vorhanden setzen wir SharpS2-Tuner(Ist zwar die gleiche Adresse wie ST-Tuner, diese sind aber nicht im Vip1v2 und Vip2 verbaut ;)) */
		if(i2c_autodetect(adap, SharpS2, 0x0) != -1 ) {
			Tunertype2 = "sharp7306";
		}
	}
	
	/* prink des Boxtype und des Tuners die ermittelt wurden */
	if(Boxtype == "Vip1")
		printk("[DETECT] -> Boxtype = %s \n[DETECT] -> Tuner = %s \n", Boxtype, Tunertype);
	if(Boxtype == "Vip1v2")
		printk("[DETECT] -> Boxtype = %s \n[DETECT] -> Tuner = %s \n", Boxtype, Tunertype);
	if(Boxtype == "Vip2")
		printk("[DETECT] -> Boxtype = %s \n[DETECT] -> Tuner1 = %s \n[DETECT] -> Tuner2 = %s \n", Boxtype, Tunertype, Tunertype2);
	
	return 0;
}

static int detect_boxid(void)
{
	struct i2c_adapter *adap;
	int i2c40 = 0;
	int i2c28 = 0;

	/* Bus 2 Check ob verfügbar */
	if((adap = i2c_get_adapter(I2C_BUS2)) == NULL) {
		printk("[DETECT] -> Autodetection failed. I2C bus error\n");
		return 0;
	}
	/* Bus 2 write auf Adresse 0x40 (Cimax Adresse(Hat nur Vip1 und Vip1v2)), wenn verfügbar set Status 1, anderfalls 3 */
  	if(i2c_autodetect(adap, I2C_0X40, 0x0) != -1 ) {
		i2c40 = 1;	
	} else {
		i2c40 = 3;
	}
	/* Bus 2 write auf Adresse 0x28(Display Adresse(Hat nur Vip1v2 und Vip2)), wenn verfügbar set Status 1, anderfalls 3 */
  	if(i2c_autodetect(adap, I2C_0X28, 0x0) != -1 ) {
		i2c28 = 1;
	} else {
		i2c28 = 3;
	}

	/* Ist 0x40 vorhanden aber nicht 0x28(wegen fehlendem Display) so ist es ein Vip1(Opticum))
	 * Ist 0x40 und 0x28 vorhanden so ist es ein Vip1v2
	 */
	if(i2c40 == 1) {
		if(i2c28 == 1) {
			Boxtype = "Vip1v2";
		} else {
			Boxtype = "Vip1";
		}
	}
	/* Ist 0x40 nicht vorhanden aber 0x28 (wegen Fehlenden Ci Schacht) so ist es Vip2 */
	if(i2c40 == 3) {
		if(i2c28 == 1) {
			Boxtype = "Vip2";
		}
	}
	/* Ist Garnix vorhanden ERROR mit printk ausgabe*/
	if(i2c40 == 3) {
		if(i2c28 == 3) {
			printk("[DETECT] -> error \n[DETECT] -> i2c40 = %d \n[DETECT] -> i2c28 = %d\n", i2c40, i2c28);
			printk("[DETECT] -> Kein Boxtype erkannt\n");
		}
	}

	/* we need reset Tuner by Shift register for Vip2 
	   4 = Tuner A Reset Pin on hc595
	   1 = Tuner B Reset Pin on hc595		*/
	/* Ist Boxtype Vip2 erkannt müssen wir die Tuner anders Resetten um sie nachfolgen peer I2C zu finden */
	if(Boxtype == "Vip2") {
		hc595_out (4, 0);
  		hc595_out (1, 0);
		hc595_out (4, 1);
  		hc595_out (1, 1);
	}

	return TunerScan(Boxtype);
}
// -------------------------------------------------------------
/* /proc/Boxtype und /proc/Tunertype1 sowie 2 können beschrieben werden in E2 per echo "Type" > /proc/Boxtype */
ssize_t write_info( struct file *filp, const char __user *buff, unsigned long len, void *data )
{
    int capacity = (MAX_LEN-write_index)+1;
    if (len > capacity)
    {
        return -1;
    }
    if (copy_from_user( &info[write_index], buff, len ))
    {
        return -2;
    }

    write_index += len;
    info[write_index-1] = 0;
    return len;
}
/* Read Funktion für /proc/Boxtype */ 
int read_info( char *page, char **start, off_t off, int count, int *eof, void *data )
{
    int len;
    if (off > 0)
    {
        *eof = 1;
        return 0;
    }

    if (read_index >= write_index)
    		read_index = 0;

    len = sprintf(page, "%s\n", Boxtype, &info[read_index]);
    read_index += len;

    return len;
}
/* Read Funktion für /proc/Tunertype1 */ 
int read_info_tuner1( char *page, char **start, off_t off, int count, int *eof, void *data )
{
    int len;
    if (off > 0)
    {
        *eof = 1;
        return 0;
    }

    if (read_index >= write_index)
    		read_index = 0;

    len = sprintf(page, "%s\n", Tunertype, &info[read_index]);
    read_index += len;

    return len;
}
/* Read Funktion für /proc/Tunertype2 */ 
int read_info_tuner2( char *page, char **start, off_t off, int count, int *eof, void *data )
{
    int len;
    if (off > 0)
    {
        *eof = 1;
        return 0;
    }

    if (read_index >= write_index)
    		read_index = 0;

    len = sprintf(page, "%s\n", Tunertype2, &info[read_index]);
    read_index += len;   

    return len;
}

// -------------------------------------------------------------------

int __init detect_init(void)
{
    	int ret = 0;
	printk("[DETECT] -> Boxdetect for Argus Boxes\n");
	
	/* wir mussen das AVS sowie das Cimax und Tuner erwecken
	 * dafür muessen wir fuer Cimax und AVS nur zwei Pins 
	 * Aktivieren, um auch den Tuner zu ermitteln muss noch ein
	 * reset erfolgen, anschliessen koennen wir alles
	 * vor dem init der avs (Boxtype) und des fe_core ermitteln
	 */

	detect1 = stpio_request_pin (2, 2, "detect1", STPIO_OUT); // Vip2 hc595 Pio
	detect2 = stpio_request_pin (2, 3, "detect2", STPIO_OUT); // Standart Reset Pin Vip1, Vip1v2 und Vip2 hc595
	detect4 = stpio_request_pin (2, 4, "detect4", STPIO_OUT); // Vip2 hc595 Pio
	detect3 = stpio_request_pin (2, 5, "detect3", STPIO_OUT); // Cimax Boxtype Pio
	
	if ((detect1 == NULL) || (detect2 == NULL) || (detect3 == NULL) || (detect4 == NULL))
	{
	    printk ("[DETECT] -> Allocate Pio: failed to allocate IO resources\n");
	    
	    if(detect1 != NULL)
		stpio_free_pin (detect1);
	    
	    if(detect2 != NULL)
		stpio_free_pin (detect2);
	    
	    if(detect3 != NULL)
		stpio_free_pin (detect3);
	    
	    if(detect4 != NULL)
		stpio_free_pin (detect4);

	    return;
	}

	/* Aktivate Tuner durch Reset
	 * das ermöglicht uns den Tuner zur Reaktion
	 * zu swingen worauf hin wir ihn peer i2c
	 * finden können und später koreckt laden
	 * Das benötigen nur Vip1 und Vip1v2, Vip2 Reset
	 * Erfolgt über das Shift register beim Boxtype detect.
	 */
	stpio_set_pin(detect2, 0); // default Reset für Vip1 und Vip1v2
	stpio_set_pin(detect2, 1); // default Reset für Vip1 und Vip1v2
	
	/* startet Boxtype und tuner Check */
	detected_boxid = detect_boxid();

	/* da wir nun alles ermittelt haben muessen wir
	 * hier die Pios wieder Freimachen da sonnst Treiber
	 * wie AVS Cimax und fe-core (Tuner) nicht geladen werden können.
	 * Danach gehts wie gehabt beim Boot weiter !!!
	 */
	stpio_free_pin (detect1);
	stpio_free_pin (detect2);
	stpio_free_pin (detect3);
	stpio_free_pin (detect4);
		
	/* make /proc */
    	info = (char *)vmalloc( MAX_LEN );
    	memset( info, 0, MAX_LEN );
	/* Erstellt /proc/Boxtype */
    	proc_entry = create_proc_entry( "Boxtype", 0644, NULL );

    	if (proc_entry == NULL)
    	{
    	    ret = -1;
    	    vfree(info);
    	}
    	else
    	{
    	    write_index = 0;
    	    read_index = 0;
    	    proc_entry->read_proc = read_info;
    	    proc_entry->write_proc = write_info;
   	}
	/* Erstellt /proc/Tunertype1 */
    	proc_entry_tuner1 = create_proc_entry( "Tunertype", 0644, NULL );

    	if (proc_entry_tuner1 == NULL)
    	{
    	    ret = -1;
    	    vfree(info);
    	}
    	else
    	{
    	    write_index = 0;
    	    read_index = 0;
    	    proc_entry_tuner1->read_proc = read_info_tuner1;
    	    proc_entry_tuner1->write_proc = write_info;
   	}
	/* /proc/Tunertype2 wird nur erstellt wenn beim Boxtype Vip2 gefunden wurde */
	if(Boxtype == "Vip2") {
		proc_entry_tuner2 = create_proc_entry( "Tunertype2", 0644, NULL );

    		if (proc_entry_tuner2 == NULL)
    		{
    		    ret = -1;
    		    vfree(info);
    		}
    		else
    		{
    		    write_index = 0;
    		    read_index = 0;
    		    proc_entry_tuner2->read_proc = read_info_tuner2;
    		    proc_entry_tuner2->write_proc = write_info;
   		}
	}
	
	return 0;
}

void __exit detect_exit(void)
{
    	remove_proc_entry("Boxtype", proc_entry);
    	remove_proc_entry("Tunertype", proc_entry);
	if(Boxtype == "Vip2") {
		remove_proc_entry("Tunertype2", proc_entry);
	}
    	vfree(info);
	printk("[DETECT] -> Removed\n");
}

module_init(detect_init);
module_exit(detect_exit);

MODULE_AUTHOR("Ducktrick");
MODULE_DESCRIPTION("Argus Boxtype and Tuner Detect");
MODULE_LICENSE("GPL");
