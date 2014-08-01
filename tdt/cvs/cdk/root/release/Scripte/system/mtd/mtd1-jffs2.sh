#!/bin/sh

# Dieses Script erstellt erstellt ein Backup des /dev/mtd1
# und Formatiert das device für die verwendung in E2
# 6.4 MB Nand stehen dann zur verfügung, jffs2 Comprimiert
# sodas mehr als 6.4 MB Datengröße drauf geschrieben werden kann

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
# erstelle mountpunkt
if [ ! -e /media/nand ]; then
	echo "Erstelle mount Ordner /media/nand"
	mkdir /media/nand
	if [ ! -e /media/nand ]; then
		echo "Konnte Verzeichniss /media/nand nicht anlegen"
		echo "Bitte dateisystem Prüfen"
	fi
fi
echo ""
echo "Erstelle Backup..."
echo "Backup..." > /dev/vfd
echo ""
dd if=/dev/mtd1 of=/media/nanddump-mtd1.bin bs=1024
#nanddump -f /media/nanddump-mtd1.bin /dev/mtd1
# vorbereiten des Flashspeichers
echo ""
echo "Löschen..." > /dev/vfd
echo "Lösche Flash Nand"
echo ""
flash_eraseall -j /dev/mtd1
#we wait a moment of the Flashchip	
sleep 5
# Start des Flash vorgangs
echo ""
echo "Mount..." > /dev/vfd
echo "Mounte Nand Speicher"
echo ""
mount -t jffs2 /dev/mtdblock1 /media/nand
sleep 2
mountcheck=`mount | grep /dev/mtdblock1 | awk '{ print $5 }'`
if [ "$mountcheck" = "jffs2" ]; then
	echo "Auslagern von E2 Daten" 
	echo "Kopiere /etc/enigma2 auf /media/nand"
	echo "Enigma2" > /dev/vfd
	mv /etc/enigma2 /media/nand/enigma2
	ln -s /media/nand/enigma2 /etc/enigma2
	echo "Kopiere /var/emu auf /media/nand"
	echo "Emu" > /dev/vfd
	mv /var/emu /media/nand/emu
	ln -s /media/nand/emu /var/emu
	echo "Kopiere /var/keys auf /media/nand"
	echo "Keys" > /dev/vfd
	mv /var/keys /media/nand/keys
	ln -s /media/nand/keys /var/keys
	echo "Kopiere /lib/modules auf /media/nand"
	echo "Treiber" > /dev/vfd
	mv /lib/modules /media/nand/modules
	ln -s /media/nand/modules /lib/modules
else
	echo "nand nicht gemountet, kein auslagern möglich"
	echo "ERROR - NO Mount" > /dev/vfd
	exit 0
fi
# Setzt den nand status für das system zum automount on boot up
echo "jffs2-nand-e2" > /var/config/nanduse

echo "__________________________________________"
echo ""
echo "Der Nand bereich ist nun für das System vorbereitet"
echo "und kann unter dem Mountpunt /media/nand verwendet werden"
echo ""
echo "__________________________________________"
echo "Fertig" > /dev/vfd
