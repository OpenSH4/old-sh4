#!/bin/sh
	/bin/echo "Neustart" > /dev/vfd
	sleep 5
	##Bootlogo in HD
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

