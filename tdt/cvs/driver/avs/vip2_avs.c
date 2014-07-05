
/*
 *   vip2_avs.c -
 *
 *   spider-team 2010.
 *
 *   mainly based on avs_core.c from Gillem gillem@berlios.de / Tuxbox-Project
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include <linux/version.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/poll.h>
#include <linux/types.h>
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,17)
#include <linux/stm/pio.h>
#else
#include <linux/stpio.h>
#endif

#include "avs_core.h"
#include "vip2_avs.h"

/* hold old values for mute/unmute */
static unsigned char t_mute;

/* hold old values for volume */
static unsigned char t_vol;

/* hold old values for standby */
static unsigned char ft_stnby=0;
static unsigned char fctl=0;

enum scart_ctl {
	SCART_AUDHI 		= 0, // 1 = LOW(Leiser Sound) | 0 = HI(Lauter Sound) | Aber nicht Mute !!!
	SCART_STANDBY		= 1, // OK = Standby
	SCART_WSS		= 2, // OK = 16:9 by 1
	SCART_CVBS_RGB		= 3, // OK = CVBS/RGB
	SCART_TV_SAT		= 4, // OK Encoder On by 1
	SCART_0_12V		= 5, // ? 12V kommen immer egal ob 1 oder 0
	FAN_VCCEN1		= 6, // ? FAN POWER ? 
	HDD_VCCEN2		= 7, // ? HDD POWER ?
};

static struct stpio_pin*	srclk; // shift clock
static struct stpio_pin*	rclk;  // latch clock
static struct stpio_pin*	sda;   // serial data

#define SRCLK_CLR() {stpio_set_pin(srclk, 0);}
#define SRCLK_SET() {stpio_set_pin(srclk, 1);}

#define RCLK_CLR() {stpio_set_pin(rclk, 0);}
#define RCLK_SET() {stpio_set_pin(rclk, 1);}

#define SDA_CLR() {stpio_set_pin(sda, 0);}
#define SDA_SET() {stpio_set_pin(sda, 1);}

void vip2_avs_hc595_out(unsigned char ctls, int state)
{
	int i;

	if(state)
		fctl |= 1 << ctls;
	else
		fctl &= ~(1 << ctls);

	/*
	 * clear everything out just in case to
	 * prepare shift register for bit shifting
	 */

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

int vip2_avs_src_sel(int src)
{
	printk("[AVS]: Not Supported (vip2_avs_src_sel) \n");
	return 0;
}

inline int vip2_avs_standby(int type)
{

	if ((type<0) || (type>1))
	{
		printk("[AVS]: ft_stnby error type\n");
		return -EINVAL;
	}
 
	if (type==1) 
	{
		if (ft_stnby == 0)
		{
			printk("[AVS]: ft_stnby 0\n");
			vip2_avs_hc595_out(SCART_STANDBY, !ft_stnby);
			ft_stnby = 1;
		}
		else
			printk("[AVS]: ft_stnby error\n");
			return -EINVAL;		
	}
	else
	{
		if (ft_stnby == 1)
		{
			printk("[AVS]: ft_stnby 1\n");
			vip2_avs_hc595_out(SCART_STANDBY, !ft_stnby);
			ft_stnby = 0;
		}
		else
			printk("[AVS]: ft_stnby error\n");
			return -EINVAL;
	}

	return 0;
}
 
int vip2_avs_set_volume(int vol)
{
	int c;
 
	printk("[AVS]: %s (%d)\n", __func__, vol);
	c = vol;
 
	if (c > 63 || c < 0)
		printk("[AVS]: %s - out off range (%d)\n", __func__, c);
		if (c > 63 )
			c = 62;
		else
			c = 1;
 
	c = 63 - c;

	printk("[AVS]: %s: c = (%d)\n", __func__, c);
	msleep(50);
	t_vol = c;
 
	return 0;
}
 
inline int vip2_avs_set_mute(int type)
{
	if ((type<0) || (type>1))
	{
		return -EINVAL;
	}
	
	if (type==AVS_MUTE) 
	{
		printk("[AVS]: type Mute 1 (SCART_AUDHI=1 Zappen OK aber zu leise)\n");
		t_mute = 1;
	}
	else
	{
		printk("[AVS]: type Mute 0 (SCART_AUDHI=0 Kackt beim Zappen)\n");
		t_mute = 0;
	}

	printk("[AVS]: %s: t_mute = (%d)\n", __func__, t_mute);
	vip2_avs_hc595_out(SCART_AUDHI, t_mute);
	printk("[AVS]: Hier Knackt es wenn SCART_AUDHI auf 0 gestellt wird für lauteren Sound...");
	return 0;
}
 
int vip2_avs_get_volume(void)
{
	int c;
 
	c = t_vol;
 
	return c;
}
 
inline int vip2_avs_get_mute(void)
{
	return t_mute;
}
 
int vip2_avs_set_mode(int vol)
{
	switch(vol)
	{
	case	SAA_MODE_RGB:
		printk("[AVS]: vip2_avs_set_mode RGB 1\n");
		vip2_avs_hc595_out(SCART_CVBS_RGB, 1);
		break;
	case	SAA_MODE_FBAS:
		printk("[AVS]: vip2_avs_set_mode CVBS 1\n");
		vip2_avs_hc595_out(SCART_CVBS_RGB, 0);
		break;
	default:
		printk("[AVS]: vip2_avs_set_mode error\n");
		break;

	}
 
	return 0;
}
 
int vip2_avs_set_encoder(int vol)
{
	vip2_avs_hc595_out(SCART_TV_SAT, 1); // set encoder
	printk("[AVS]: Set Encoder = (1)ON\n");
	/* set Audio Low by Boot (kein knacken bei Bootlogo) */
	vip2_avs_hc595_out(SCART_AUDHI, 0);
	return 0;
}
 
int vip2_avs_set_wss(int vol)
{
	printk("[AVS]: %s\n", __func__);

	if (vol == SAA_WSS_43F)
	{
		printk("[AVS]: avs_set_wss SAA_WSS_43F (0)\n");
		vip2_avs_hc595_out(SCART_WSS, 0);
	}
	else if (vol == SAA_WSS_169F)
	{
		printk("[AVS]: avs_set_wss SAA_WSS_169F = (1)\n");
		vip2_avs_hc595_out(SCART_WSS, 1);
	}
	else if (vol == SAA_WSS_OFF)
	{
		printk("[AVS]: Not supportet\n");
	}
	else
	{
		printk("[AVS]: avs_set_wss error\n");
		return  -EINVAL;
	}
 
	return 0;
}

int vip2_avs_command(unsigned int cmd, void *arg )
{
	int val=0;

	printk("[AVS]: %s(%d)\n", __func__, cmd);

	if (cmd & AVSIOSET)
	{
		if ( copy_from_user(&val,arg,sizeof(val)) )
		{
			printk("[AVS]: command copy error\n");
			return -EFAULT;
		}

		switch (cmd)
		{
			case AVSIOSVOL:
				printk("[AVS]: vip2_avs_command AVSIOSVOL\n");
				return vip2_avs_set_volume(val);
			case AVSIOSMUTE:
				printk("[AVS]: vip2_avs_command AVSIOSMUTE\n");
				return vip2_avs_set_mute(val);
			case AVSIOSTANDBY:
				printk("[AVS]: vip2_avs_command AVSIOSTANDBY\n");
				return vip2_avs_standby(val);
			default:
				printk("[AVS]: vip2_avs_command error\n");
				break;
		}
	}
	else if (cmd & AVSIOGET)
	{
		switch (cmd)
		{
			case AVSIOGVOL:
				printk("[AVS]: vip2_avs_command AVSIOGET volume\n");
				val = vip2_avs_get_volume();
				break;
			case AVSIOGMUTE:
				printk("[AVS]: vip2_avs_command AVSIOGET mute\n");
				val = vip2_avs_get_mute();
				break;
			default:
				printk("[AVS]: vip2_avs_command AVSIOGET error\n");
				break;
		}

		return put_user(val,(int*)arg);
	}
	else
	{
		printk("[AVS]: %s: SAA command\n", __func__);

		/* an SAA command */
		if ( copy_from_user(&val,arg,sizeof(val)) )
		{
			printk("[AVS]: %s: SAA command - Copy from User error\n", __func__);
			return -EFAULT;
		}

		switch(cmd)
		{
		case SAAIOSMODE:
			printk("[AVS]: vip2_avs_command SAAIOSMODE set mode\n");
           		return vip2_avs_set_mode(val);
 	        case SAAIOSENC:
			printk("[AVS]: vip2_avs_command SAAIOSMODE set encoder\n");
        		return vip2_avs_set_encoder(val);
		case SAAIOSWSS:
			printk("[AVS]: vip2_avs_command SAAIOSMODE set wss\n");
			return vip2_avs_set_wss(val);
		case SAAIOSSRCSEL:
			printk("[AVS]: vip2_avs_command SAAIOSMODE src sel\n");
        		return vip2_avs_src_sel(val);
		default:
			printk("[AVS]: %s: SAA command not supported\n", __func__);
			return -EINVAL;
		}
	}

	return 0;
}

int vip2_avs_command_kernel(unsigned int cmd, void *arg)
{
    int val=0;
	
	if (cmd & AVSIOSET)
	{
		val = (int) arg;

      	printk("[AVS]: %s: AVSIOSET command\n", __func__);

		switch (cmd)
		{
			case AVSIOSVOL:
			    printk("[AVS]: vip2_avs_command_kernel AVSIOSVOL set volume\n");
		            return vip2_avs_set_volume(val);
		        case AVSIOSMUTE:
			    printk("[AVS]: vip2_avs_command_kernel AVSIOSVOL set mute\n");
		            return vip2_avs_set_mute(val);
		        case AVSIOSTANDBY:
			    printk("[AVS]: vip2_avs_command_kernel AVSIOSVOL standby\n");
		            return vip2_avs_standby(val);
			default:
				printk("[AVS]: %s: AVSIOSET command not supported\n", __func__);
				return -EINVAL;
		}
	}
	else if (cmd & AVSIOGET)
	{
		printk("[AVS]: %s: AVSIOGET command\n", __func__);

		switch (cmd)
		{
			case AVSIOGVOL:
			    printk("[AVS]: vip2_avs_command_kernel AVSIOGVOL volume\n");
			    val = vip2_avs_get_volume();
			    break;
			case AVSIOGMUTE:
			    printk("[AVS]: vip2_avs_command_kernel AVSIOGVOL mute\n");
			    val = vip2_avs_get_mute();
			    break;
			default:
				printk("[AVS]: %s: AVSIOGET command not supported\n", __func__);
				return -EINVAL;
		}

		arg = (void *) val;
	        return 0;
	}
	else
	{
		printk("[AVS]: %s: SAA command (%d)\n", __func__, cmd);

		val = (int) arg;

		switch(cmd)
		{
		case SAAIOSMODE:
			 printk("[AVS]: vip2_avs_command_kernel SAAIOSMODE set mode\n");
           		 return vip2_avs_set_mode(val);
 	        case SAAIOSENC:
			 printk("[AVS]: vip2_avs_command_kernel SAAIOSMODE set encode\n");
        		 return vip2_avs_set_encoder(val);
		case SAAIOSWSS:
			 printk("[AVS]: vip2_avs_command_kernel SAAIOSMODE set wss\n");
			return vip2_avs_set_wss(val);
		case SAAIOSSRCSEL:
			 printk("[AVS]: vip2_avs_command_kernel SAAIOSMODE src sel\n");
        		return vip2_avs_src_sel(val);
		default:
			printk("[AVS]: %s: SAA command not supported\n", __func__);
			return -EINVAL;
		}
	}

	return 0;
}

int vip2_avs_init(void)
{
  
	srclk= stpio_request_pin (2, 5, "AVS_HC595_SRCLK", STPIO_OUT);
	rclk = stpio_request_pin (2, 6, "AVS_HC595_RCLK", STPIO_OUT);
	sda  = stpio_request_pin (2, 7, "AVS_HC595_SDA", STPIO_OUT);

	if ((srclk == NULL) || (rclk == NULL) || (sda == NULL))
	{
		if(srclk != NULL)
			stpio_free_pin (srclk);
		else
			printk("[AVS]: srclk error\n");

		if(rclk != NULL)
			stpio_free_pin (rclk);
		else
			printk("[AVS]: rclk error\n");

		if(sda != NULL)
			stpio_free_pin(sda);
		else
			printk("[AVS]: sda error\n");
		
		return -1;
	}

	printk("[AVS]: init success\n");

  return vip2_avs_set_encoder(1);
}
