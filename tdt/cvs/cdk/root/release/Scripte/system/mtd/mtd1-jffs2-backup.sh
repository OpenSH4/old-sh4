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
umount /media/nand
# Backupfile Check
if [ ! -e /media/nanddump-mtd1.bin ]; then
	echo "Kein Backup gefunden in /media"
	exit 0
fi
# vorbereiten des Flashspeichers
echo "Löschen..." > /dev/vfd
echo "Lösche Flash Nand"
flash_eraseall /dev/mtd1	
# Start des Flash vorgangs
echo "Flashe..." > /dev/vfd
echo "Flashe Nand Backup wieder zurück"
nandwrite /dev/mtd1 /media/nanddump-mtd1.bin
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
