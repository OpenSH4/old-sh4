#!/bin/sh
#set dummys
iltvmd5="error"
tunertype=`cat /var/keys/Benutzerdaten/.system/tuner1`
#Check auf nand tools vorhanden
if [ -e /sbin/flash_eraseall ]; then
	if [ ! -e /sbin/nandwrite ]; then
	      echo "nandwrite nicht gefunden"
	      opkg update
	      opkg remove mtd_utils
	      opkg install mtd_utils
	fi
	if [ ! -e /sbin/nanddump ]; then
	      echo "nanddump nicht gefunden"
	      opkg update
	      opkg remove mtd_utils
	      opkg install mtd_utils
	fi
	echo "Nand tools mtd_utils installed"
else
	echo "Downlaoding and Install mtd_utils..."
	opkg update
	opkg install mtd_utils
	# erneuter Check ob die nand Files da sind
	if [ ! -e /sbin/flash_eraseall ]; then
	      echo "flash_eraseall nicht gefunden"
	      exit 0
	fi	
	if [ ! -e /sbin/nandwrite ]; then
	      echo "nandwrite nicht gefunden"
	      exit 0
	fi
	if [ ! -e /sbin/nanddump ]; then
	      echo "nanddump nicht gefunden"
	      exit 0
	fi
fi
# Checkt Tunertype
if [ "$tunertype" = "stb6100" ]; then
	echo "Tunertype = $tunertype (RB) ... continue"
else
	echo "Tunertype = $tunertype (ST)... error"
	echo "Die gewählte ILTV passt nicht zum Tuner"
	echo "Wählen Sie bitte die Richtige zum Flashen"
	echo "des Nand Speichers, anderfalls würde"
	echo "die Box nach dem Flashvorgang nicht mehr starten."
	exit 0
fi
# Check ob das Arbeitsverzeichniss vorhanden ist
if [ -e /media/iltv ]; then
	echo "Arbeitsverzeichniss vorhanden"
else
	echo "Erstelle Arbeitsverzeichniss"
	mkdir /media/iltv
	# erneuter Check ob das Verzeichniss existiert
	if [ -e /media/iltv ]; then
		echo "ok"
	else
		echo "Verzeichniss /media/iltv konnte nicht erstellt werden"
		echo "Bitte Dateisystem Prüfen"
		exit 0
	fi
fi
# Downloading und Check der ILTV + Bootloader"
wget http://dbs-clan.de/argus/mtdiltv/mtd3-opti-rb.bin -O /media/iltv/mtd3-opti-rb.bin
sleep 2
# Check ob das file gedownloadet wurde
if [ ! -e /media/iltv/mtd3-opti-rb.bin ]; then
	echo "Download der ILTV Fehlgeschlagen"
	exit 0
fi
# Download der MD5SUM aller ILTV Files
wget http://dbs-clan.de/argus/mtdiltv/MD5SUM -O /media/iltv/MD5SUM
# Check ob das file gedownloadet wurde
if [ ! -e /media/iltv/MD5SUM ]; then
	echo "Download der MD5SUM Fehlgeschlagen"
	exit 0
fi
# MD5SUM Check der FILES
cd /media/iltv/
md5sum -c MD5SUM > /media/iltv/md5check
# set new md5 Status
iltvmd5=`cat /media/iltv/md5check | grep mtd3-opti-rb.bin | awk '{ print $2 }'`
echo "md5 Summe der ILTV Datei = $iltvmd5"
if [ "$iltvmd5" = "OK" ]; then
# nand umount
mountcheck=`mount | grep /dev/mtdblock1 | awk '{ print $5 }'`
if [ "$mountcheck" = "jffs2" ]; then
	echo "Nand ist mountet"
	echo "Check des FileSystems"
	if [ -e /media/nand/enigma2 ]; then
		echo "Nand Daten gefunden..."
		echo "Kopiere Files zurück auf SDA"
		echo "" 
		echo "Kopiere /media/nand/enigma2 nach /etc/enigma2"
		echo "Enigma2" > /dev/vfd
		rm /etc/enigma2
		mv /media/nand/enigma2 /etc/enigma2
	fi
	if [ -e /media/nand/emu ]; then
		echo "Kopiere /media/nand nach /var/emu"
		echo "Emu" > /dev/vfd
		rm /var/emu
		mv /media/nand/emu /var/emu
	fi
	if [ -e /media/nand/keys ]; then
		echo "Kopiere /media/nand nach /var/keys"
		echo "Keys" > /dev/vfd
		rm /var/keys
		mv /media/nand/keys /var/keys
	fi
	if [ -e /media/nand/modules ]; then
		echo "Kopiere /media/nand nach /lib/modules"
		echo "Treiber" > /dev/vfd
		rm /lib/modules
		mv /media/nand/modules /lib/modules
	fi
	echo ""
	echo "Nand ist mountet und kann so nicht beschrieben werden"
	echo "Bitte starten Sie die Box neu und wiederhollen Sie dann"
	echo "den Vorgang erneut um das Flashen der ILTV fortzusetzen"
	echo ""
	echo "not-use" > /var/config/nanduse
	echo "Aufräumen..." > /dev/vfd
	rm -rf /media/iltv/
	exit 0
else
	echo "Nand not mounted"
fi
	clear
	echo ""
	echo ""
	echo ""
	echo "Alle Vorrausetzungen zum Flashen der ILTV sind erfüllt"
	echo "Start des Flashvorgangs in 10 sec"
	echo "Dieser Vorgang kann  bis zu 10 Minuten dauern..."
	echo "Trennen sie den Receiver auf keinen Fall vom Strom oder"
	echo "Starten ihn neu bevor der Vorgang abgeschlossen wurde"
	echo ""
	echo ""
	echo ""
	sleep 10
	# vorbereiten des Flashspeichers
	echo "Flash Löschen" > /dev/vfd
	echo "Lösche Flash Nand..."
	flash_eraseall /dev/mtd3
	#we wait a moment of the Flashchip	
	sleep 10
	# Start des Flash vorgangs
	echo "Flashe ILTV..." > /dev/vfd
	echo "Flashen der ILTV Firmware"
	dd if=/media/iltv/mtd3-opti-rb.bin of=/dev/mtdblock3 bs=1024
	#nandwrite /dev/mtd3 /media/iltv/mtd3-opti-rb.bin
else
	echo "MD5 Der ILTV Datei Fehlerhaft"
	echo "Neustart des Vorgangs zum erneuten Download erforderlich"
	exit 0
fi
# Loeschen der ILTV Software vom USB
echo "Aufräumen"
echo "Aufräumen..." > /dev/vfd
rm -rf /media/iltv/
sync
echo "__________________________________________"
echo ""
echo "Das Flaschen der ILTV ist Abgeschlossen"
echo "Der Receiver kann nun neu gestartet werden"
echo ""
echo "__________________________________________"
echo "Fertig" > /dev/vfd