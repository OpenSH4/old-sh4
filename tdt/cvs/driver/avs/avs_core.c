/*
 *   avs_core.c - audio/video switch core driver - Kathrein UFS-910
 *
 *   written by captaintrip - 19.Nov 2007
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

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/version.h>

#include <linux/sched.h>
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/poll.h>
#include <linux/types.h>
#include <linux/i2c.h>
#include <linux/miscdevice.h>
#include <asm/string.h>

#include "avs_core.h"
#include "stv6418.h"
#include "vip2_avs.h"
#include "vip1_avs.h"

enum
{
	STV6418,
	VIP2_AVS,
	VIP1_AVS,
};

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
static const struct i2c_device_id avs_id[] = {
        { "stv6418", STV6418 },
        { "vip2_avs", VIP2_AVS },
	{ "vip1_avs", VIP1_AVS },
        { }
};
MODULE_DEVICE_TABLE(i2c, avs_id);
#endif

static int devType;
static char *type = "stv6418";

/*
 * Addresses to scan
 */
static unsigned short normal_i2c[] = {
	0x4b, /* stv6412 / stv6417 / stv6418 */
	I2C_CLIENT_END
};
I2C_CLIENT_INSMOD;

static struct i2c_driver avs_i2c_driver;
static struct i2c_client *avs_client = NULL;

/*
 * i2c probe
 */

static int avs_newprobe(struct i2c_client *client, const struct i2c_device_id *id)
{
	if (avs_client) {
		printk("[AVS]: failure, client already registered\n");
		return -ENODEV;
	}

	printk("[AVS]: chip found @ 0x%x\n", client->addr);

	switch(devType)
	{
	case STV6418:  stv6418_init(client);  break;
	default: return -ENODEV;
	}
	avs_client = client;
	return 0;
}

static int avs_remove(struct i2c_client *client)
{
	avs_client = NULL;
	printk("[AVS]: remove\n");
	return 0;
}

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
static int avs_attach(struct i2c_adapter *adap, int addr, int kind)
{
	struct i2c_client *client;
	int err;

	printk("[AVS]: attach\n");

	if (!(client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
		printk("[AVS]: attach nomem 1\n");
		return -ENOMEM;
	}

	/*
		NB: this code only works for a single client
	*/
	client->adapter = adap;
	client->addr = addr;
	client->driver = &avs_i2c_driver;
	strlcpy(client->name, "AVS", I2C_NAME_SIZE);

	if ((err = avs_newprobe(client, NULL))) {
		kfree(client);
		return err;
	}

	printk("[AVS]: attach final\n");
	i2c_attach_client(client);
	printk("[AVS]: attach final ok\n");

	return 0;
}

static int avs_probe(struct i2c_adapter *adap)
{
	int ret = 0;

	printk("[AVS]: probe\n");
	ret = i2c_probe(adap, &addr_data, avs_attach);
	printk("[AVS]: probe end %d\n",ret);

	return ret;
}

static int avs_detach(struct i2c_client *client)
{
	int err = avs_remove(client);
	i2c_detach_client(client);
	if (client)
		kfree(client);

	return err;
}

#endif /* < 2.6.30 */

/*
 * devfs fops
 */

static int avs_command_ioctl(struct i2c_client *client, unsigned int cmd, void *arg)
{
	int err = 0;

	/* ist STV6418 gewählt so wird der i2c Client gecheckt
	 * bei allen anderen (vip1v2 und Vip2) gibt es keinen 
	 * I2C Client aber abbrechen wollen wir auch nciht 
	 */
	if (devType == STV6418)
	{
		if (!client)
			return -1;
	}


	printk("[AVS]: %s (%u)\n", __func__, cmd);

	switch(devType)
	{
	case STV6418:  err = stv6418_command(client, cmd, arg);  break;
	/* none i2c avs */
	case VIP2_AVS: 		err = vip2_avs_command(cmd, arg); 	 break;
	case VIP1_AVS: 		err = vip1_avs_command(cmd, arg);	 break;
	}
	return err;
}

int avs_command_kernel(unsigned int cmd, void *arg)
{
	int err = 0;

	struct i2c_client *client = avs_client;
	/* ist STV6418 gewählt so wird der i2c Client gecheckt
	 * bei allen anderen (vip1v2 und Vip2) gibt es keinen 
	 * I2C Client aber abbrechen wollen wir auch nciht 
	 */
	if (devType == STV6418)
	{
		if (!client)
			return -1;
	}
	
	printk("[AVS]: %s (%u)\n", __func__, cmd);

	switch(devType)
	{
	case VIP2_AVS: 		err = vip2_avs_command_kernel(cmd, arg); 	break;
	case VIP1_AVS: 		err = vip1_avs_command_kernel(cmd, arg); 	break;
	case STV6418:  		err = stv6418_command_kernel(client, cmd, arg);  break;
	}
	return err;
}

EXPORT_SYMBOL(avs_command_kernel);

static int avs_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
{
	printk("[AVS]: IOCTL\n");
	return avs_command_ioctl(avs_client, cmd, (void *) arg);
}

static struct file_operations avs_fops = {
	owner:		THIS_MODULE,
	ioctl:		avs_ioctl
};


static struct miscdevice avs_dev = {
	.minor = AVS_MINOR,
	.name = "avs",
	.fops = &avs_fops
};

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
static int avs_detect(struct i2c_client *client, int kind, const char **info)
#else
static int avs_detect(struct i2c_client *client, int kind, struct i2c_board_info *info)
#endif
{
	const char *name = "";

    /*
     * Now we do the remaining detection. A negative kind means that
     * the driver was loaded with no force parameter (default), so we
     * must both detect and identify the chip. A zero kind means that
     * the driver was loaded with the force parameter, the detection
     * step shall be skipped. A positive kind means that the driver
     * was loaded with the force parameter and a given kind of chip is
     * requested, so both the detection and the identification steps
     * are skipped.
     */

    /* Default to an ak4705 if forced */
    if (kind == 0) {
    	name = "stv6418";
    	kind = STV6418;
    }

	if (kind < 0) { /* detection and identification */
		if (!type || !strcmp("stv6418", type))
			kind = STV6418;
		else if(!strcmp("vip2_avs", type))
			kind = VIP2_AVS;
		else if(!strcmp("vip1_avs", type))
			kind = VIP1_AVS;
		else
			return -ENODEV;
	}
	switch (kind) {
	case STV6418:  		name = "stv6418";  		break;
	case VIP2_AVS: 		name = "vip2_avs"; 		break;
	case VIP1_AVS: 		name = "vip1_avs"; 		break;
	default: return -ENODEV;
	}
	devType = kind;
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
	*info = name;
#else
	strlcpy(info->type, name, I2C_NAME_SIZE);
#endif
	return 0;
}

/*
 * i2c
 */

static struct i2c_driver avs_i2c_driver = {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
	.driver = {
		.owner = THIS_MODULE,
		.name = "avs_driver", /* can this be avs_driver? */
	},
	.id = I2C_DRIVERID_AVS,
	.attach_adapter = avs_probe,
	.detach_client = avs_detach,
#else
	.class = I2C_CLASS_TV_DIGITAL,
	.driver = {
		.owner = THIS_MODULE,
		.name = "avs_driver", /* 2.6.30 requires name without spaces */
	},
	.probe = avs_newprobe,
	.detect = avs_detect,
	.remove = avs_remove,
	.id_table = avs_id,
	.address_data = &addr_data,
#endif
	.command = avs_command_ioctl
};

/*
 * module init/exit
 */

int __init avs_init(void)
{
	int res, err;
	const char *name;

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
	err = avs_detect(NULL, -1, &name);
#else
	struct i2c_board_info info;
	err = avs_detect(NULL, -1, &info);
	name = info.type;
#endif

	if (err) {
		printk("[AVS]: Unknown AVS Driver!\n");
		return err;
	}

	printk("[AVS]: A/V switch handling for %s\n", name);

	if ((devType != VIP2_AVS) && (devType != VIP1_AVS)) {
		if ((res = i2c_add_driver(&avs_i2c_driver))) {
			printk("[AVS]: i2c add driver failed\n");
			return res;
		}

		if (!avs_client){
			printk("[AVS]: no client found\n");
			i2c_del_driver(&avs_i2c_driver);
			return -EIO;
		}
	}else if (devType == VIP2_AVS){
		if(vip2_avs_init() != 0)
		{
			printk("[AVS]: init vip2 avs faild!\n");
			return -EIO;
		}
	}else if (devType == VIP1_AVS){
		if(vip1_avs_init() != 0)
		{
			printk("[AVS]: init vip1 avs faild!\n");
			return -EIO;
		}
	}

	if (misc_register(&avs_dev)<0){
		printk("[AVS]: unable to register device\n");
		return -EIO;
	}

	return 0;
}

void __exit avs_exit(void)
{
	misc_deregister(&avs_dev);
	i2c_del_driver(&avs_i2c_driver);
}

module_init(avs_init);
module_exit(avs_exit);

MODULE_AUTHOR("Team Ducktales");
MODULE_DESCRIPTION("Multiplatform A/V scart switch driver");
MODULE_LICENSE("GPL");

module_param(type,charp,0);
MODULE_PARM_DESC(type, "device type (stv6418, vip2_avs, vip1_avs)");

