#!/bin/sh
# TimeSet ArgusVIP-Mod by Ducktrick
UHR=`cat /var/keys/Benutzerdaten/.system/uhr`
TIMEZONE=`cat /var/keys/Benutzerdaten/.system/timezone`
standby=0
echo "run" > /var/config/time
while sleep 10 
do
BOXOFF=`cat /var/config/boxoff`
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
fi
if [ $STBY = scart ]; then # Hier beginnt die Anzeige wenn Box im standby
	CLEAR=`cat /var/config/time`
	if [ $standby = 0 ]; then
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
		echo "Change Standby State too ON"
	fi
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "$day-$month" > /dev/null # Das ist die Display anzeige Monat und Tag
	standby=1
else # Hier beginnt die anzeige im Betrieb, nicht ändern
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -tm 24 > /dev/null
	if [ $standby = 1 ]; then
		echo "anders" > /var/config/time 
		echo "Change Standby State too OFF"
	fi
	standby=0
fi
if [ $BOXOFF = OFF ]; then # Hier beginnt die Anzeige wenn Box Heruntergefahren wird
	CLEAR=`cat /var/config/time`
	if [ $CLEAR = anders ]; then
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
		echo "set run"
	else
	echo "give Time String"
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "Turn OFF" #> /dev/null # Hier wird wenn die runtergefahren ist Turn OFf im Display gezeigt
	fi
elif [ $BOXOFF = BLANK ]; then
	fp_control -c #Schalltet alle schriftzüge aus Im Display und bleibt dunkel
elif [ $BOXOFF = DATE ]; then
	CLEAR=`cat /var/config/time`
	if [ $CLEAR = anders ]; then
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
	else
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "$day-$month" > /dev/null # Hier wird wenn die Box runtergefahren ist Datum und uhr angezeigt im Display
	fi
elif [ $BOXOFF = DATEPLUS ]; then
	CLEAR=`cat /var/config/time`
	if [ $CLEAR = anders ]; then
		fp_control -c > /dev/null
		echo "run" > /var/config/time 
	else
	fp_control -s $hour:$minute:$second $day-$month-$year > /dev/null
	fp_control -t "$day-$month" > /dev/null # Hier wird wenn die box runtergefahren ist das Datum und Turn OFF im Display als Wechselschrift angezeigt
	sleep 30
	fp_control -t "Turn OFF" > /dev/null
	fi
fi
done
