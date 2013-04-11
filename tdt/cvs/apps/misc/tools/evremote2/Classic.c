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
#include "Classic.h"

static tLongKeyPressSupport cLongKeyPressSupport = {
  20, 120,
};

/* Spider Box HL-101 RCU */
static tButton cButtonsClassic[] = {
    {"STANDBY"        , "c4", KEY_POWER},
    {"MUTE"           , "c6", KEY_MUTE},
    {"MENU"           , "56", KEY_MENU},
    {"V.FORMAT"       , "fc", KEY_V},
    {"AUX"            , "a4", KEY_AUX},
    {"GUIDE"          , "94", KEY_EPG},
    {"EXIT"           , "5c", KEY_HOME},

    {"0BUTTON"        , "1e", KEY_0},
    {"1BUTTON"        , "b6", KEY_1},
    {"2BUTTON"        , "36", KEY_2},
    {"3BUTTON"        , "cc", KEY_3},
    {"4BUTTON"        , "8e", KEY_4},
    {"5BUTTON"        , "0e", KEY_5},
    {"6BUTTON"        , "ec", KEY_6},
    {"7BUTTON"        , "ae", KEY_7},
    {"8BUTTON"        , "2e", KEY_8},
    {"9BUTTON"        , "dc", KEY_9},

    {"GUIDE"          , "94", KEY_EPG},
    {"EXIT"           , "5c", KEY_HOME},
    {"INFO"           , "f4", KEY_INFO}, 
    {"AUDIO"          , "6e", KEY_AUDIO},

    {"FAV"            , "ee", KEY_FAVORITES},
    {"SAT"            , "3e", KEY_SAT},

    {"DOWN/P-"        , "b4", KEY_DOWN},
    {"UP/P+"          , "ac", KEY_UP},
    {"RIGHT/V+"       , "7c", KEY_RIGHT},
    {"LEFT/V-"        , "66", KEY_LEFT},
    {"OK/LIST"        , "8c", KEY_OK},

    {"RED"            , "96", KEY_RED},
    {"GREEN"          , "bc", KEY_GREEN},
    {"GREEN"          , "bc", KEY_GREEN},
    {"YELLOW"         , "3c", KEY_YELLOW},
    {"BLUE"           , "de", KEY_BLUE},

    {"REWIND"         , "f6", KEY_REWIND},
    {"PLAY"           , "26", KEY_PLAY},
    {"FASTFORWARD"    , "76", KEY_FASTFORWARD},
    {"STOP"           , "a6", KEY_STOP},
    {"TV/RADIO"       , "64", KEY_TV2}, 
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
    
    strcpy(vAddr.sun_path, "/var/run/lirc/lircd");

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
    system("echo KEYBOARD > /tmp/autoswitch.tmp");
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

RemoteControl_t Classic_RC = {
	"Argus Classic RemoteControl",
	Classic,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsClassic,
	NULL,
	NULL,
  	1,
  	&cLongKeyPressSupport,
};
