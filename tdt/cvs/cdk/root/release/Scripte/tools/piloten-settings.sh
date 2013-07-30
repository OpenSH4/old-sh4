#!/bin/sh
echo " | Initialisiere System..."
SYSTEM=`cat /var/config/subsystem`
echo " | Done ---> $SYSTEM"
echo " | Download Piloten Sender Settings für $SYSTEM"
echo " | Vorbereitung ..."
# Download Settings File
if [ $SYSTEM = Enigma2 ]; then
	LOCAL=/etc/enigma2
else
	LOCAL=/var/tuxbox/config/zapit
fi
wget http://dbs-clan.de/argus/settings/Piloten-Settings-$SYSTEM.tar.gz -O $LOCAL > /dev/null
# Pause
sleep 2
echo " | Installiere Settings..."
cd $LOCAL
tar -xf Piloten-Settings-$SYSTEM.tar.gz
# Pause
sleep 2
echo " | Fertig"
echo " | Räume auf ..."
rm Piloten-Settings-$SYSTEM.tar.gz
sync
echo " |-----------------------------------------"
echo " | Installation Abgeschlossen"
echo " | Bitte starten Sie die "
echo " | Benutzeroberfläche oder den Receiver neu"
echo " |"
echo " |-----------------------------------------"
echo "                               by Ducktrick"


