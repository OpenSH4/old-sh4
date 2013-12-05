/*
 * mce2005.c
 *
 * (c) 2010 duckbox project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>

#include <termios.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <time.h>

#include "global.h"
#include "map.h"
#include "remotes.h"
#include "mce2005.h"

extern int vRamMode;

static tLongKeyPressSupport cLongKeyPressSupport = {
  5, 150,
};

/* Edision argus-vip2 RCU */
static tButton cButtonsEdisionMce2005[] = {
    {"STANDBY"        , "f3", KEY_POWER},
    {"MUTE"           , "f1", KEY_MUTE},
    {"V.FORMAT"       , "b5", KEY_V},
    {"AUX"            , "db", KEY_AUX},

    {"0BUTTON"        , "ff", KEY_0},
    {"1BUTTON"        , "fe", KEY_1},
    {"2BUTTON"        , "fd", KEY_2},
    {"3BUTTON"        , "fc", KEY_3},
    {"4BUTTON"        , "fb", KEY_4},
    {"5BUTTON"        , "fa", KEY_5},
    {"6BUTTON"        , "f9", KEY_6},
    {"7BUTTON"        , "f8", KEY_7},
    {"8BUTTON"        , "f7", KEY_8},
    {"9BUTTON"        , "f6", KEY_9},

    {"BACK"           , "f5", KEY_BACK},
    {"INFO"           , "f0", KEY_INFO}, //THIS IS WRONG SHOULD BE KEY_INFO

    {"DOWN"        , "e0", KEY_DOWN},
    {"UP"          , "e1", KEY_UP},
    {"RIGHT"       , "de", KEY_RIGHT},
    {"LEFT"        , "df", KEY_LEFT},
    {"v+"	      , "ef", KEY_VOLUMEUP},
    {"v-"	      , "ee", KEY_VOLUMEDOWN},
    {"p+"	      , "ed", KEY_PAGEUP},
    {"p-"	      , "ec", KEY_PAGEDOWN},
    {"OK/LIST"        , "dd", KEY_OK},
    {"MENU"           , "f2", KEY_MENU},
    {"GUIDE"          , "d9", KEY_EPG},
    {"EXIT"           , "dc", KEY_HOME},
    {"FAV"            , "da", KEY_FAVORITES},

    {"RED"            , "a4", KEY_RED},
    {"GREEN"          , "a3", KEY_GREEN},
    {"YELLOW"         , "a2", KEY_YELLOW},
    {"BLUE"           , "a1", KEY_BLUE},

    {"REWIND"         , "ea", KEY_REWIND},
    {"PAUSE"          , "e7", KEY_PAUSE},
    {"PLAY"           , "e9", KEY_PLAY},
    {"FASTFORWARD"    , "eb", KEY_FASTFORWARD},
    {"RECORD"         , "e8", KEY_RECORD},
    {"STOP"           , "e6", KEY_STOP},
    {"ARCHIVE"        , "e2", KEY_ARCHIVE},
    {"STEPBACK"       , "e4", KEY_PREVIOUS},
    {"STEPFORWARD"    , "e5", KEY_NEXT},
    {"TV/RADIO"       , "da", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCH BUTTON
    {"USB"            , "e3", KEY_CLOSE},

    {""               , ""  , KEY_NULL},
};

/* fixme: move this to a structure and
 * use the private structure of RemoteControl_t
 */
static struct sockaddr_un  vAddr;

static int pInit(Context_t* context, int argc, char* argv[]) {

    int vHandle;

    vAddr.sun_family = AF_UNIX;

    //Newbiez: for write of evremote2 tmp files in /ram take -x parameter
    if(vRamMode==0)
	strcpy(vAddr.sun_path, "/var/run/lirc/lircd");
    else 
	strcpy(vAddr.sun_path, "/ram/lircd");	

    vHandle = socket(AF_UNIX,SOCK_STREAM, 0);

    if(vHandle == -1)  {
        perror("socket");
        return -1;
    }

    if(connect(vHandle,(struct sockaddr *)&vAddr,sizeof(vAddr)) == -1)
    {
        perror("connect");
        return -1;
    }

    return vHandle;
}

static int pShutdown(Context_t* context ) {

    close(context->fd);

    return 0;
}

static int pRead(Context_t* context ) {
    char                vBuffer[128];
    char                vData[10];
    const int           cSize         = 128;
    int                 vCurrentCode  = -1;

	memset(vBuffer, 0, 128);
    //wait for new command
    read (context->fd, vBuffer, cSize);

    //parse and send key event
    vData[0] = vBuffer[17];
    vData[1] = vBuffer[18];
    vData[2] = '\0';


    vData[0] = vBuffer[14];
    vData[1] = vBuffer[15];
    vData[2] = '\0';

    printf("[RCU] key: %s -> %s\n", vData, &vBuffer[0]);

    //Newbiez: for write of evremote2 tmp files in /ram take -x parameter - Mod by Ducktrick ;)
    if (vRamMode==0) {
	system("echo KEYBOARD > /tmp/autoswitch.tmp");
    } else if (vRamMode==1) {
	system("echo KEYBOARD > /ram/autoswitch.tmp");
    } else if (vRamMode==2) {
	printf("[RCU] autoswitch.tmp write is off\n");
    }


    vCurrentCode = getInternalCode((tButton*)((RemoteControl_t*)context->r)->RemoteControl, vData);

	if(vCurrentCode != 0) {
		static int nextflag = 0;
		if (('0' == vBuffer[17]) && ('0' == vBuffer[18]))
		{
		    nextflag++;
		}
		vCurrentCode += (nextflag << 16);
	}
    return vCurrentCode;
}

/*static int pNotification(Context_t* context, const int cOn) {

    struct aotom_ioctl_data vfd_data;
    int ioctl_fd = -1;

    if(cOn)
    {
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 1;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }
    else
    {
       usleep(100000);
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 0;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }

    return 0;
}*/
static int pNotification(Context_t* context, const int cOn) {

    struct proton_ioctl_data vfd_data;
    int ioctl_fd = -1;

    if(cOn)
    {
       usleep(100000);
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 0;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }
    else
    {
       usleep(100000);
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 0;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }

    return 0;
}


RemoteControl_t Mce2005_RC = {
	"MediaCenter MultiImages RemoteControl",
	Mce2005,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsEdisionMce2005,
	NULL,
        NULL,
  	1,
  	&cLongKeyPressSupport,
};
