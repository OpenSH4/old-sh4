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
	if [ -e /update/boot/uImage.gz ]; then
	#copy new kernel files
		cp /update/boot/uImage.gz /rootfs/boot/
		rm /update/boot/uImage.gz
	fi
	if [ -e /update/tmp/update.sh ]; then
	#so we can run a update Skript for remove or delate Files ;)
		/update/tmp/update.sh
	fi
	# Setzt das Update State auf 0 für Updatecheck in Enigma2/NeutrinoHD
	echo "0" > /update/var/config/update/state
	if [-e /update/var/config/nanduse ]; then
		USED=`cat var/config/nanduse`
		if [ $USED = "jffs2-nand-e2" ]; then
			echo "create old symlink for modules"
			rm /update/lib/modules
			mv /update/lib/modules.bak /update/lib/modules
		fi
	fi
	echo "Fertig...." > /dev/vfd
	sleep 3
	sync
	# Exit und reboot System zum neuen Kernel Laden
	reboot -f
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
	if [-e /update/var/config/nanduse ]; then
		USED=`cat /update/var/config/nanduse`
		if [ $USED = "jffs2-nand-e2" ]; then
			mountcheck=`mount | grep /dev/mtdblock1 | awk '{ print $5 }'`
			if [ "$mountcheck" = "jffs2" ]; then
				echo "Nand Mounted"
			else
				mount -t jffs2 /dev/mtdblock1 /update/media/nand
				echo "nand already mounted, create Symlinks for Modules now"
				mv /update/lib/modules /update/lib/modules.bak
				ln -s /update/media/nand/modules /update/lib/modules
			fi
		else
			echo "Nand not USED for E2"
		fi
	else
		echo "no nanduse File found"
	fi
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

