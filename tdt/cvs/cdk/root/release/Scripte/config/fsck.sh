###########################
# Startzähler             #
# Writen by Ducktrick     #
# count 0 ist standart    #
###########################
echo "_______________________________________________________________________________________"
echo ""
echo ""
echo ""
echo "########################################################################################"
echo "###########                     FSCK User Check Config                     #############"
echo "###########              Only for GStreamer Image von Ducktrick            #############"
echo "###########                       Write by ducktrick                       #############"
echo "###########            Support unter http://mein-forum-live.de.vu          #############"
echo "########################################################################################"
echo ""
echo ""
echo ""
echo "_______________________________________________________________________________________"
echo ""
echo "INFORMATION"
if [ ! -e /var/keys/Benutzerdaten/.system/count_fsck ]; then
echo "0" > /var/keys/Benutzerdaten/.system/count_fsck
fi
COUNT=`cat /var/keys/Benutzerdaten/.system/count_fsck`
USERSET=`cat /var/keys/Benutzerdaten/.system/userset_fsck`
RUNS=1
START=`expr $COUNT + $RUNS`
echo "$START" > /var/keys/Benutzerdaten/.system/count_fsck
echo "Setze den Startzaehler ..."
echo ""
echo "Aktuell gezaehlter Start : $START"
echo "Gesetzte Starts bis zum System Check : $COUNT"
echo ""
if [ $START = $USERSET ]; then
	echo "Ext2 Dateisystem will beim naechsten Neustart Ueberprueft werden, dies kann einige Minuten in Anspruch nehmen"
	echo "errors" > /var/etc/.usercheckintervall
	echo "Startzaehler auf NULL gesetzt"
	echo "0" > /var/keys/Benutzerdaten/.system/count_fsck
fi
echo "_______________________________________________________________________________________"

