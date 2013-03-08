#!/bin/sh
	/bin/echo "Neustart" > /dev/vfd
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
	echo "killed self"
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
			sleep 12
		fi
	fi
else	
	/usr/local/bin/dvbtest -4 -f l /boot/shutdown.mp4 &
	sleep 12
fi
	/etc/init.d/networking stop &
	/etc/init.d/vsftpd stop &
	killall -9 inetd &
	killall -9 automount.sh &
   echo "init lircd"
	killall -9 evremote2
	killall -9 lircd	
	killall -9 telnetd &
	killall -9 smbd &
	sync
	init 6

