echo "UPDATE..." > /dev/vfd
# mountet die ziel Partition nach /update, dadurch können die Updates größer 95MB sein
mount /dev/sda2 /update
# Checkt Aktuell Installierte Version
INSTALLED=`cat /update/var/config/update/version`
# Setzt nächst größte Version zum Updaten
NEWVERSION=`expr $INSTALLED + 1`
# Letztes Updatefile ( definiert in E2 beim Updatecheck )
AKTUELL=`cat /update/var/config/update/state`
# Check und Aktuell 
sleep 2
while true; do
if [ $INSTALLED = $AKTUELL ]; then
	echo "Loesche" > /dev/vfd
	echo "Lösche alte Update Files"
	cd /update
	# löscht alte Updates Files von sda2
	rm *.tar.gz
	# Löscht alte Updates Files von sda1
	rm -r /rootfs/updates
	# lösche Update start file
	rm /rootfs/update
	echo "done"
	# Setzt das Update State auf 0 für Updatecheck in Enigma2/NeutrinoHD
	echo "0" > /update/var/config/update/state
	echo "Fertig...." > /dev/vfd
	sleep 3
	sync
	# Exit und Boot System
	exit 0
else
	# Kopiert das Update File auf die /dev/sda2 Partition um es Später zu installieren
	echo "Copy Update auf Ziel Partition"
	echo "Copy..." > /dev/vfd
	cp /rootfs/updates/update-$NEWVERSION.tar.gz /update
	echo "done"
	echo "Install Update"
	echo "Install $NEWVERSION"
	# Entpackt das Updates
	cd /update
	sleep 1
	tar -xf update-$NEWVERSION.tar.gz
	echo "done... Grundfile"
	# entpacke Update
	tar -xf update.tar.gz
	echo "done... Updatefile"
	sleep 3
	sync
	# Lösche Update File
	rm update.tar.gz
	# lösche Update Startfile
	rm update
	# setzt neuen Installed State
	echo $NEWVERSION > /update/var/config/update/version
	# neues init der Installierten Versionsinformationen
	INSTALLED=`cat /update/var/config/update/version`
	# nichts übereilen ;)
	sleep 1
	# neue Version + 1 für nächtes Update File
	NEWVERSION=`expr $INSTALLED + 1` 
	sync
fi
done

