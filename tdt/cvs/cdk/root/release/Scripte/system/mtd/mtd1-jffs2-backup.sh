#!/bin/sh

# Dieses Script Flasht das erstellte Backup vom 
# mtd1-jffs2 Script wieder zurück um die ILTV 
# wieder verwenden zu können

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
# nand umount
mountcheck=`mount | grep /dev/mtdblock1 | awk '{ print $5 }'`
if [ "$mountcheck" = "jffs2" ]; then
	echo "zurück kopieren von E2 Daten" 
	echo "Kopiere /media/nand/enigma2 nach /etc/enigma2"
	echo "Enigma2" > /dev/vfd
	rm /etc/enigma2
	mv /media/nand/enigma2 /etc/enigma2 
	echo "Kopiere /media/nand nach /var/emu"
	echo "Emu" > /dev/vfd
	rm /var/emu
	mv /media/nand/emu /var/emu
	echo "Kopiere /media/nand nach /var/keys"
	echo "Keys" > /dev/vfd
	rm /var/keys
	mv /media/nand/keys /var/keys
	echo "Kopiere /media/nand nach /lib/modules"
	echo "Treiber" > /dev/vfd
	rm /lib/modules
	mv /media/nand/modules /lib/modules
	#umount /media/nand
else
	echo "Nand not mounted"
fi
# Backupfile Check
if [ ! -e /media/nanddump-mtd1.bin ]; then
	echo "Kein Backup gefunden in /media"
	exit 0
fi
sleep 3
# vorbereiten des Flashspeichers
echo ""
echo "Löschen..." > /dev/vfd
echo "Lösche Flash Nand"
echo ""
flash_eraseall /dev/mtd1
# we wait a moment
sleep 5
# Start des Flash vorgangs
echo ""
echo "Flashe Nand Backup wieder zurück"
echo "Bitte Warten"
echo "Flashen..." > /dev/vfd
echo ""
dd if=/media/nanddump-mtd1.bin of=/dev/mtdblock1 bs=1024
#nandwrite /dev/mtd1 /media/nanddump-mtd1.bin
# Setzt Status für das System das das device nicht mehr gemountet wird on startup
echo "not-use" > /var/config/nanduse
echo "__________________________________________"
echo ""
echo "Der Nand bereich wurde mit dem eigenst erstellten"
echo "Backup file wieder in den urzustand versetzt"
echo "Das Booten der ILTV sollte nun wieder möglich sein"
echo ""
echo "__________________________________________"
echo "Fertig" > /dev/vfd
