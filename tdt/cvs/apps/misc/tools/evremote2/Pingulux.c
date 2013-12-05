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
#include "Pingulux.h"

extern int vRamMode;

static tLongKeyPressSupport cLongKeyPressSupport = {
  20, 120,
};

static tButton cButtonsSpideroxPINGULUX[] = {
    {"STANDBY"        , "87", KEY_POWER},
    {"MUTE"           , "A5", KEY_MUTE},
    {"V.FORMAT"       , "2f", KEY_V},
   /* {"AUX"            , "9f", KEY_AUX},*/

    {"0BUTTON"        , "37", KEY_0},
    {"1BUTTON"        , "A7", KEY_1},
    {"2BUTTON"        , "07", KEY_2},
    {"3BUTTON"        , "E5", KEY_3},
    {"4BUTTON"        , "97", KEY_4},
    {"5BUTTON"        , "27", KEY_5},
    {"6BUTTON"        , "D5", KEY_6},
    {"7BUTTON"        , "B7", KEY_7},
    {"8BUTTON"        , "17", KEY_8},
    {"9BUTTON"        , "F5", KEY_9},

    {"BACK"           , "CF", KEY_BACK},
    {"INFO"           , "C5", KEY_INFO}, //THIS IS WRONG SHOULD BE KEY_INFO
   /* {"AUDIO"          , "0d", KEY_AUDIO},*/

    {"DOWN/P-"        , "85", KEY_DOWN},
    {"UP/P+"          , "3F", KEY_UP},
    {"RIGHT/V+"       , "FD", KEY_RIGHT},
    {"LEFT/V-"        , "BF", KEY_LEFT},
    {"OK/LIST"        , "05", KEY_OK},
    {"MENU"           , "C7", KEY_MENU},
    {"GUIDE"          , "25", KEY_EPG},
    {"EXIT"           , "F9", KEY_HOME},
    {"FAV"            , "3D", KEY_FAVORITES},

    {"V+"             , "AF", KEY_VOLUMEUP},
    {"V-"      	      , "9F", KEY_VOLUMEDOWN},
    {"P+"             , "7F", KEY_PAGEUP},
    {"P-"      	      , "35", KEY_PAGEDOWN},

    {"RED"            , "6D", KEY_RED},
    {"GREEN"          , "8D", KEY_GREEN},
    {"YELLOW"         , "77", KEY_YELLOW},
    {"BLUE"           , "AD", KEY_BLUE},

    {"REWIND"         , "FB", KEY_REWIND},
    {"PAUSE"          , "4D", KEY_PAUSE},
    {"PLAY"           , "57", KEY_PLAY},
    {"FASTFORWARD"    , "3B", KEY_FASTFORWARD},
    {"RECORD"         , "F7", KEY_RECORD},
    {"STOP"           , "BB", KEY_STOP},
    {"SLOWMOTION"     , "B5", KEY_SLOW},
    {"ARCHIVE"        , "67", KEY_ARCHIVE},
    {"SAT"            , "0D", KEY_SAT},
    {"STEPBACK"       , "7B", KEY_PREVIOUS},
    {"STEPFORWARD"    , "E7", KEY_NEXT},
    {"MARK"           , "75", KEY_MARK},
    {"TV/RADIO"       , "95", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCH BUTTON
    {"USB"            , "DF", KEY_CLOSE},
    {"SLEEP"          , "65", KEY_TIME},
    {"TIMESHIFT"      , "55", KEY_TIMESHIFT},

    {"F1"             , "15", KEY_TIME},
    {"F2"             , "D7", KEY_TIMESHIFT},
    {"EDV"            , "45", KEY_TIMESHIFT},
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

static int pNotification(Context_t* context, const int cOn) {

    struct aotom_ioctl_data vfd_data;
    int ioctl_fd = -1;

    if(cOn)
    {
       usleep(100000);
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
}

RemoteControl_t Pingulux_RC = {
	"Pingulux GStreamer MultiImages RemoteControl",
	Pingulux,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsSpideroxPINGULUX,
	NULL,
	NULL,
  	1,
  	&cLongKeyPressSupport,
};
