#!/bin/sh
   /bin/echo "Herunterfahren" > /dev/vfd
   sleep 3
   echo "init lircd"
   killall -9 evremote2
   killall -9 lircd   
   killall -9 smbd &
   /etc/init.d/portmap stop & 
   ##FB Laden
   /usr/bin/lircd  
   stfbcontrol a 0   
fb=`cat /var/keys/Benutzerdaten/.system/fernbedienung`
   if [ "$fb" = "neu" ]; then
        /bin/evremote2 vip2 &
   elif [ "$fb" = "alt" ]; then
      /bin/evremote2 vip1 &
   elif [ "$fb" = "opti" ]; then
      /bin/evremote2 opti &
   elif [ "$fb" = "Pungolux" ]; then
      /bin/evremote2 Pingolux &
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
   umount -l /dev/sda1
   umount -l /dev/sdb1
   sync
   killall -9 dvbtest
   # Aktiviere Display Uhr anzeige für Box OFF
   MODE=`cat /var/config/mode`
   echo "$MODE" > /var/config/boxoff
   if [ -e /tmp/autoswitch.tmp ]; then
      rm /tmp/autoswitch.tmp
      sleep 1
   fi
   if [ -e /var/config/deepstandby ]; then
      DEEPSTANDBY=`cat /var/config/deepstandby`
      if [ "$DEEPSTANDBY" = "vip2" ]; then
         sync
         sleep 2
         swapoff /dev/sda2
         sleep 3
         fp_control -d
      else
         until false
         do
         file="/tmp/autoswitch.tmp"
         if [ -e $file ]; then
                 echo "Neustart" > /dev/vfd
            sleep 2
            swapoff /dev/ramzswap0
            sleep 2
                 sync
            sleep 2
                 init 6
         else    
            sleep 3
         fi
         done
      fi
   else
      until false
      do
      file="/tmp/autoswitch.tmp"
      if [ -e $file ]; then
                echo "Neustart" > /dev/vfd
         sleep 2
         swapoff /dev/ramzswap0
         sleep 2
                sync
         sleep 2
                init 6
      else    
         sleep 3
      fi
      done
   fi
