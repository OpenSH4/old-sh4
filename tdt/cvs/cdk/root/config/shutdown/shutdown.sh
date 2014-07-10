#!/bin/sh
   /bin/echo "Herunterfahren" > /dev/vfd
   sleep 3
if [ -e /var/config/subsystem ]; then
   SYSTEM=`cat /var/config/subsystem`
   if [ "$SYSTEM" = "Neutrino" ]; then
      echo "killed self"
   else
      if [ -e /var/config/subswitch ]; then
         echo "subswitch Aktiv"
      else
         echo "killed self"
      fi
   fi
else
   killall -9 enigma2
fi
   sleep 3
   ##Bootlogo in HD
if [ -e /var/config/subsystem ]; then
   SYSTEM=`cat /var/config/subsystem`
   if [ "$SYSTEM" = "Neutrino" ]; then
      echo "############ Neutrino Shutdown, no Logo ################"
   else   
      if [ -e /var/config/subswitch ]; then
         echo "subswitch Aktiv no Logo"
      else
         /usr/local/bin/dvbtest -4 -f l /boot/shutdown.mp4 &
      fi
   fi
else   
   /usr/local/bin/dvbtest -4 -f l /boot/shutdown.mp4 &
fi
   sleep 12
   echo "init lircd"
   killall -9 evremote2
   killall -9 lircd   
   killall -9 smbd &
   /etc/init.d/portmap stop &
   /usr/bin/lircd -P /ram/lircd.pid -o /ram/lircd 
   ##FB Laden
    stfbcontrol a 0   
    fb=`cat /var/keys/Benutzerdaten/.system/fernbedienung`
    DEEPSTANDBY=`cat /proc/Boxtype`
       if [ "$DEEPSTANDBY" = "Vip2" ]; then
		SETS="-s"
       elif [ "$DEEPSTANDBY" = "Vip1v2" ]; then
		SETS="-s"
       elif [ "$DEEPSTANDBY" = "Vip1" ]; then
		SETS="-x"
       fi
       if [ "$fb" = "neu" ]; then
          echo "Fernbedienung NEU geladen"
            /bin/evremote2 $SETS vip2 &
       elif [ "$fb" = "alt" ]; then
          echo "Fernbedienung ALT geladen"
          /bin/evremote2 $SETS vip1 &
       elif [ "$fb" = "opti" ]; then
          echo "Fernbedienung OPTI geladen"
          /bin/evremote2 $SETS opti &
       elif [ "$fb" = "Pingulux" ]; then
          echo "Fernbedienung Pingulux geladen"
          /bin/evremote2 $SETS Pingulux &
       elif [ "$fb" = "mce2005" ]; then
          echo "Fernbedienung MediaCenter geladen"
          /bin/evremote2 $SETS MediaCenter &
       elif [ "$fb" = "techno" ]; then
          echo "Fernbedienung TechnoTrend geladen"
          /bin/evremote2 $SETS TechnoTrend &
       fi
    fi
   ##Module Entladen
   rmmod /lib/modules/boxtype.ko
   rmmod /lib/modules/cifs.ko
   rmmod /lib/modules/bpamem.ko
   rmmod /lib/modules/stmalloc.ko
   rmmod /lib/modules/smartcard.ko
   rmmod /lib/modules/silencegen.ko
   rmmod /lib/modules/sth264pp.ko
   rmmod /lib/modules/mpeg2hw.ko
   ##Modul ende
   sync
   killall -9 dvbtest
   # Aktiviere Display Uhr anzeige für Box OFF
   MODE=`cat /var/config/mode`
   echo "$MODE" > /var/config/boxoff
   if [ -e /tmp/autoswitch.tmp ]; then
      rm /tmp/autoswitch.tmp
      sleep 1
   fi

   DEEPSTANDBY=`cat /proc/Boxtype`
   if [ "$DEEPSTANDBY" = "Vip2" ]; then
        sync
	echo "umount FS"
		swapoff /dev/sda3
		umount /dev/sdb1
		umount /dev/sda2
		umount /sys
		umount /ram
	echo "umountet sda1 sdb1 sys ram swap"
	 sync
         fp_control -d
   elif [ "$DEEPSTANDBY" = "Vip1v2" ]; then
        sync
	echo "umount FS"
		swapoff /dev/sda3
		umount /dev/sdb1
		umount /dev/sda2
		umount /sys
		umount /ram
	echo "umountet sda1 sdb1 sys ram swap"
	 sync
         fp_control -d
   else
         until false
         do
         file="/tmp/autoswitch.tmp"
         if [ -e $file ]; then
                 echo "Neustart" > /dev/vfd
		echo "umount FS"
		swapoff /dev/sda3
		umount /dev/sdb1
		umount /dev/sda2
		umount /dev/sda1
		umount /sys
		umount /ram
		echo "umountet sda1 sdb1 sys ram swap"
            	sleep 2
                 init 6
         else    
            sleep 3
         fi
         done
   fi