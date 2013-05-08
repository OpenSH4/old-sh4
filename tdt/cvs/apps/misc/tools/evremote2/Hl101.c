/*
 * Hl101.c
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
#include "Hl101.h"

extern int vRamMode;

static tLongKeyPressSupport cLongKeyPressSupport = {
  20, 120,
};

/* Spider Box HL-101 RCU */
static tButton cButtonsSpideroxHL101[] = {
    {"STANDBY"        , "f7", KEY_POWER},
    {"MUTE"           , "3d", KEY_MUTE},
    {"V.FORMAT"       , "5d", KEY_V},
    {"AUX"            , "9f", KEY_AUX},

    {"0BUTTON"        , "af", KEY_0},
    {"1BUTTON"        , "2f", KEY_1},
    {"2BUTTON"        , "cf", KEY_2},
    {"3BUTTON"        , "4f", KEY_3},
    {"4BUTTON"        , "8f", KEY_4},
    {"5BUTTON"        , "0f", KEY_5},
    {"6BUTTON"        , "7f", KEY_6},
    {"7BUTTON"        , "77", KEY_7},
    {"8BUTTON"        , "b7", KEY_8},
    {"9BUTTON"        , "37", KEY_9},

    {"BACK"           , "5f", KEY_BACK},
    {"INFO"           , "1f", KEY_INFO}, //THIS IS WRONG SHOULD BE KEY_INFO
    {"AUDIO"          , "0d", KEY_AUDIO},

    {"DOWN/P-"        , "97", KEY_DOWN},
    {"UP/P+"          , "57", KEY_UP},
    {"RIGHT/V+"       , "e7", KEY_RIGHT},
    {"LEFT/V-"        , "17", KEY_LEFT},
    {"OK/LIST"        , "d7", KEY_OK},
    {"MENU"           , "f5", KEY_MENU},
    {"GUIDE"          , "75", KEY_EPG},
    {"EXIT"           , "df", KEY_HOME},
    {"FAV"            , "3f", KEY_FAVORITES},

    {"RED"            , "07", KEY_RED},
    {"GREEN"          , "fb", KEY_GREEN},
    {"YELLOW"         , "7d", KEY_YELLOW},
    {"BLUE"           , "fd", KEY_BLUE},

    {"REWIND"         , "c7", KEY_REWIND},
    {"PAUSE"          , "6d", KEY_PAUSE},
    {"PLAY"           , "47", KEY_PLAY},
    {"FASTFORWARD"    , "27", KEY_FASTFORWARD},
    {"RECORD"         , "1d", KEY_RECORD},
    {"STOP"           , "87", KEY_STOP},
    {"SLOWMOTION"     , "ed", KEY_SLOW},
    {"ARCHIVE"        , "bd", KEY_ARCHIVE},
    {"SAT"            , "35", KEY_SAT},
    {"STEPBACK"       , "67", KEY_PREVIOUS},
    {"STEPFORWARD"    , "a7", KEY_NEXT},
    {"MARK"           , "75", KEY_EPG},
    {"TV/RADIO"       , "9d", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCH BUTTON
    {"USB"            , "2d", KEY_CLOSE},
    {"TIMER"          , "dd", KEY_TIME},
    {""               , ""  , KEY_NULL},
};

/* fixme: move this to a structure and
 * use the private structure of RemoteControl_t
 */
static struct sockaddr_un  vAddr;

static int pInit(Context_t* context, int argc, char* argv[]) {

    int vHandle;

    vAddr.sun_family = AF_UNIX;
    // in new lircd its moved to /var/run/lirc/lircd by default and need use key to run as old version
    
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

RemoteControl_t Hl101_RC = {
	"VIP1 Alt GStreamer MultiImages RemoteControl",
	Hl101,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsSpideroxHL101,
	NULL,
	NULL,
  	1,
  	&cLongKeyPressSupport,
};
