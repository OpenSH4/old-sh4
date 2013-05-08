/*
 * Vip2.c
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
#include "Vip2.h"

extern int vRamMode;

static tLongKeyPressSupport cLongKeyPressSupport = {
  20, 120,
};

/* Edision argus-vip2 RCU */
static tButton cButtonsEdisionVip2[] = {
    {"STANDBY"        , "25", KEY_POWER},
    {"MUTE"           , "85", KEY_MUTE},
    {"V.FORMAT"       , "AD", KEY_V},
    {"AUX"            , "C5", KEY_AUX},

    {"0BUTTON"        , "57", KEY_0},
    {"1BUTTON"        , "B5", KEY_1},
    {"2BUTTON"        , "95", KEY_2},
    {"3BUTTON"        , "BD", KEY_3},
    {"4BUTTON"        , "F5", KEY_4},
    {"5BUTTON"        , "D5", KEY_5},
    {"6BUTTON"        , "FD", KEY_6},
    {"7BUTTON"        , "35", KEY_7},
    {"8BUTTON"        , "15", KEY_8},
    {"9BUTTON"        , "3D", KEY_9},

    {"BACK"           , "5D", KEY_BACK},
    {"INFO"           , "A7", KEY_INFO}, //THIS IS WRONG SHOULD BE KEY_INFO

    {"DOWN"        , "0F", KEY_DOWN},
    {"UP"          , "27", KEY_UP},
    {"RIGHT"       , "AF", KEY_RIGHT},
    {"LEFT"        , "6D", KEY_LEFT},
    {"v+"	      , "C7", KEY_VOLUMEUP},
    {"v-"	      , "DD", KEY_VOLUMEDOWN},
    {"p+"	      , "07", KEY_PAGEUP},
    {"p-"	      , "5F", KEY_PAGEDOWN},
    {"OK/LIST"        , "2F", KEY_OK},
    {"MENU"           , "65", KEY_MENU},
    {"GUIDE"          , "8F", KEY_EPG},
    {"EXIT"           , "4D", KEY_HOME},
    {"FAV"            , "87", KEY_FAVORITES},

    {"RED"            , "7D", KEY_RED},
    {"GREEN"          , "FF", KEY_GREEN},
    {"YELLOW"         , "3F", KEY_YELLOW},
    {"BLUE"           , "BF", KEY_BLUE},

    {"REWIND"         , "17", KEY_REWIND},
    {"PAUSE"          , "37", KEY_PAUSE},
    {"PLAY"           , "B7", KEY_PLAY},
    {"FASTFORWARD"    , "97", KEY_FASTFORWARD},
    {"RECORD"         , "45", KEY_RECORD},
    {"STOP"           , "F7", KEY_STOP},
    {"SLOWMOTION"     , "1F", KEY_SLOW},
    {"ARCHIVE"        , "75", KEY_ARCHIVE},
    {"SAT"            , "1D", KEY_SAT},
    {"STEPBACK"       , "55", KEY_PREVIOUS},
    {"STEPFORWARD"    , "D7", KEY_NEXT},
    {"MARK"           , "9D", KEY_EPG},
    {"TV/RADIO"       , "77", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCH BUTTON
    {"USB"            , "9F", KEY_CLOSE},
    {"TIMER"          , "8D", KEY_TIME},

    {"TMS"            , "E5", KEY_TMS},
    {"PIP"            , "ED", KEY_PIP},
    {"F1"             , "CD", KEY_F1},
    {"RECALL"         , "7F", KEY_RECALL},
    {"VOR"            , "DF", KEY_VOR},

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

    //Newbiez: for write of evremote2 tmp files in /ram take -x parameter
    if (vRamMode==0)
	system("echo KEYBOARD > /tmp/autoswitch.tmp");
    else
	system("echo KEYBOARD > /ram/autoswitch.tmp");


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


RemoteControl_t Vip2_RC = {
	"VIP2 Neu GStreamer MultiImages RemoteControl",
	Vip2,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsEdisionVip2,
	NULL,
        NULL,
  	1,
  	&cLongKeyPressSupport,
};
