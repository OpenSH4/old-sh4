#!/bin/sh
# TimeSet ArgusVIP-Mod by Ducktrick
UHR=`cat /var/keys/Benutzerdaten/.system/uhr`
standby=0
stats=0
echo "run" > /var/config/time
while sleep 20 
do
TIMEZONE=`cat /var/keys/Benutzerdaten/.system/timezone`
BOXOFF=`cat /var/config/boxoff`
MODE=`cat /var/config/mode`
STBY=`cat /proc/stb/avs/0/input`
diff=$TIMEZONE
hour=`date +"%H"`
minute=`date +"%M"`
second=`date +"%S"`
day=`date +"%d"`
month=`date +"%m"`
year=`date +"%Y"`
hour=`expr $hour + $diff`
if [ $hour -gt 12 ]; then
hour=`expr $hour - 24`
fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
fp_control -i 34 1 > /dev/null
fi
if [ $STBY = scart ]; then # Hier beginnt die Anzeige wenn Box im standby
	CLEAR=`cat /var/config/time`
	if [ $standby = 0 ]; then
		fp_control -c > /dev/null
		sleep 2
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
		echo "Change Standby State too ON"
		# Deaktiviert das dauer OC im Standby sonnst läuft die Uhr zu schnell ;)
		if [ -e /var/keys/Benutzerdaten/.system/overclock ]; then
       			OVERCLOCK=`cat /var/keys/Benutzerdaten/.system/overclock`
       			if [ "$OVERCLOCK" = "300daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "333daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "366daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "400daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
			fi
		fi
	fi 
	# Clear Display and Icons
	if [ $stats = 0 ];then
		fp_control -c > /dev/null
		# Disable HDD
		sdparm --flexible --command=stop /dev/sdb
		# Clear Memory in standby
		echo "Clear Memory ..."
		/var/config/system/ram_free.sh &
		# Deaktiviert den HDMI im Standby
		/bin/stfbcontrol hd
		stats=1
	fi
	fp_control -i 34 1 > /dev/null
	fp_control -i 36 1 > /dev/null
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "$day-$month" > /dev/null # Das ist die Display anzeige Monat und Tag
	standby=1
	if [ $MODE = BLANK ]; then
		# set Display OFF
		fp_control -l 0 > /dev/null
	fi
else # Hier beginnt die anzeige im Betrieb, nicht ändern
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -tm 24 > /dev/null
	fp_control -i 36 0 > /dev/null
	# Setzt neuen stats wert für nächsten Standby
	if [ $stats = 1 ];then
		stats=0
	fi
	if [ $MODE = BLANK ]; then
		# set Display ON 
		fp_control -l 1 > /dev/null
	fi
	if [ $standby = 1 ]; then
		echo "anders" > /var/config/time 
		echo "Change Standby State too OFF"
		# Aktiviert den HDMI im Standby
		/bin/stfbcontrol he
		####### OnScreen Update Message #######
		/var/config/system/updatecheck.sh &
		# Clear Memory after standby ;)
		echo "Clear Memory ..."
		/var/config/system/ram_free.sh &
		# Aktiviert das dauer OC nach dem Standby wieder
		if [ -e /var/keys/Benutzerdaten/.system/overclock ]; then
       			OVERCLOCK=`cat /var/keys/Benutzerdaten/.system/overclock`
       			if [ "$OVERCLOCK" = "300daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 25609 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "333daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 9475 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "366daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 31241 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "400daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 22790 > /proc/cpu_frequ/pll0_ndiv_mdiv
			fi
		fi
	fi
	standby=0
fi
if [ $BOXOFF = OFF ]; then # Hier beginnt die Anzeige wenn Box Heruntergefahren wird
	CLEAR=`cat /var/config/time`
	if [ $CLEAR = anders ]; then
		fp_control -c > /dev/null
		sleep 2
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
		echo "set run"
		# Deaktiviert das dauer OC im Standby sonnst läuft die Uhr zu schnell ;)
		if [ -e /var/keys/Benutzerdaten/.system/overclock ]; then
       			OVERCLOCK=`cat /var/keys/Benutzerdaten/.system/overclock`
       			if [ "$OVERCLOCK" = "300daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "333daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "366daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "400daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
			fi
		fi
	else
	if [ $stats = 0 ];then
		fp_control -c > /dev/null
		# HDD Standby
		sdparm --flexible --command=stop /dev/sdb
		# Deaktiviert den HDMI im Standby
		/bin/stfbcontrol hd
		stats=1
	fi
	echo "give Time String"
	fp_control -i 34 1
	fp_control -i 36 1
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "Turn OFF" #> /dev/null # Hier wird wenn die runtergefahren ist Turn OFf im Display gezeigt
	fi
elif [ $BOXOFF = BLANK ]; then
	fp_control -c #Schalltet alle schriftzüge aus Im Display und bleibt dunkel
	sleep 1
	fp_control -c > /dev/null
	fp_control -i 36 1 > /dev/null
	fp_control -i 34 1 > /dev/null
	fp_control -l 0 > /dev/null
	if [ $stats = 0 ];then
		# HDD Standby
		sdparm --flexible --command=stop /dev/sdb
		# Deaktiviert den HDMI im Standby
		/bin/stfbcontrol hd
		stats=1
	fi
elif [ $BOXOFF = DATE ]; then
	CLEAR=`cat /var/config/time`
	if [ $CLEAR = anders ]; then
		fp_control -c > /dev/null
		sleep 2
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
		# Deaktiviert das dauer OC im Standby sonnst läuft die Uhr zu schnell ;)
		if [ -e /var/keys/Benutzerdaten/.system/overclock ]; then
       			OVERCLOCK=`cat /var/keys/Benutzerdaten/.system/overclock`
       			if [ "$OVERCLOCK" = "300daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "333daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "366daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "400daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
			fi
		fi
	else
	# Clear Display and Icons
	if [ $stats = 0 ];then
		fp_control -c > /dev/null
		# HDD Standby
		sdparm --flexible --command=stop /dev/sdb
		# Deaktiviert den HDMI im Standby
		/bin/stfbcontrol hd
		stats=1
	fi
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -i 34 1 > /dev/null
	fp_control -i 36 1 > /dev/null
	fp_control -t "$day-$month" > /dev/null # Hier wird wenn die Box runtergefahren ist Datum Uhr angezeigt im Display
	fi
elif [ $BOXOFF = DATEPLUS ]; then
	CLEAR=`cat /var/config/time`
	if [ $CLEAR = anders ]; then
		fp_control -c > /dev/null
		sleep 2
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
		# Deaktiviert das dauer OC im Standby sonnst läuft die Uhr zu schnell ;)
		if [ -e /var/keys/Benutzerdaten/.system/overclock ]; then
       			OVERCLOCK=`cat /var/keys/Benutzerdaten/.system/overclock`
       			if [ "$OVERCLOCK" = "300daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "333daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "366daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
       			elif [ "$OVERCLOCK" = "400daueron" ]; then
    				echo "overclock Aktiviert"
   				echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv
			fi
		fi
	else
	# Clear Display and Icons
	if [ $stats = 0 ];then
		fp_control -c > /dev/null
		#HDD Standby
		sdparm --flexible --command=stop /dev/sdb1
		# Deaktiviert den HDMI im Standby
		/bin/stfbcontrol hd
		stats=1
	fi
	fp_control -i 34 1 > /dev/null
	fp_control -i 36 1 > /dev/null
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "$day-$month" > /dev/null # Hier wird wenn die box runtergefahren ist das Datum und Turn OFF im Display als Wechselschrift angezeigt
	sleep 30
	fp_control -t "Turn OFF" > /dev/null
	fi
fi
done