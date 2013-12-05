    /*
     * TTUSBIR.c
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
    #include "TTUSBIR.h"

    extern int vRamMode;

    static tLongKeyPressSupport cLongKeyPressSupport = {
      20, 120,
    };

    /* TUSBIR Remote */
    static tButton cButtonsSpideroxTTUSBIR[] = {
        {"STANDBY"        , "41", KEY_POWER},
        {"MUTE"           , "58", KEY_MUTE},

        {"0BUTTON"        , "4c", KEY_0},
        {"1BUTTON"        , "43", KEY_1},
        {"2BUTTON"        , "44", KEY_2},
        {"3BUTTON"        , "45", KEY_3},
        {"4BUTTON"        , "46", KEY_4},
        {"5BUTTON"        , "47", KEY_5},
        {"6BUTTON"        , "48", KEY_6},
        {"7BUTTON"        , "49", KEY_7},
        {"8BUTTON"        , "4a", KEY_8},
        {"9BUTTON"        , "4b", KEY_9},

        {"INFO"           , "52", KEY_INFO},

        {"DOWN"           , "51", KEY_DOWN},
        {"UP"             , "4d", KEY_UP},
        {"RIGHT"          , "50", KEY_RIGHT},
        {"LEFT"           , "4e", KEY_LEFT},
        {"OK/LIST"        , "4f", KEY_OK},
        {"MENU"           , "42", KEY_MENU}, //No Menu-Button, so we use KEY_REPLY
        {"GUIDE"          , "62", KEY_EPG},
        {"EXIT"           , "53", KEY_HOME},

        {"RED"            , "54", KEY_RED},
        {"GREEN"          , "55", KEY_GREEN},
        {"YELLOW"         , "56", KEY_YELLOW},
        {"BLUE"           , "57", KEY_BLUE},

        {"REWIND"         , "7d", KEY_REWIND},
        {"PAUSE"          , "7e", KEY_PAUSE},
        {"PLAY"           , "7b", KEY_PLAY},
        {"FASTFORWARD"    , "7f", KEY_FASTFORWARD},
        {"RECORD"         , "7a", KEY_RECORD},
        {"STOP"           , "7c", KEY_STOP},
        {"SAT"            , "59", KEY_SAT}, //KEY_TEXT on Remote
        {"TV/RADIO"       , "5a", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCH BUTTON
        {"V+"             , "65", KEY_VOLUMEUP},
        {"V-"             , "66", KEY_VOLUMEDOWN},
        {"P+"             , "63", KEY_PAGEDOWN},
        {"P-"             , "64", KEY_PAGEUP},
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

    RemoteControl_t TTUSBIR_RC = {
       "TTUSBIR external RemoteControl",
       TTUSBIR,
       &pInit,
       &pShutdown,
       &pRead,
       &pNotification,
       cButtonsSpideroxTTUSBIR,
       NULL,
       NULL,
         1,
         &cLongKeyPressSupport,
    };
