echo '   7'     > /dev/fpsmall
echo "SAVE" > /dev/fplarge
mount /dev/sda2 /rootfs
if [ -e /rootfs/etc/enigma2 ]; then
	echo "Sichere Settings"
	echo "Save" > /dev/fplarge
	cd /rootfs/etc/enigma2
	rm settings
	tar -czvf /install/backup/E2Settings.tar.gz ./ > /dev/null 2>&1
	cd /
else
	echo "keine Settings gefunden"
	echo "checke SDA2"
	cd /
fi
if [ -e /rootfs/var/keys ]; then
	cd /rootfs/var/keys
	tar -czvf /install/backup/keys.tar.gz ./ > /dev/null 2>&1
	echo "done"
	cd /
else
	echo "keine keys gefunden"
	echo "checke SDA2"
	cd /
fi
umount /dev/sda2
mount /dev/sdb2 /rootfs
if [ -e /rootfs/etc/enigma2 ]; then
	echo "Sichere Settings"
	echo "Save" > /dev/fplarge
	cd /rootfs/etc/enigma2
	rm settings
	tar -czvf /install/backup/E2Settings.tar.gz ./ > /dev/null 2>&1
	cd /
else
	echo "keine Settings gefunden"
	echo "checke SDA2"
	cd /
fi
if [ -e /rootfs/var/keys ]; then
	cd /rootfs/var/keys
	tar -czvf /install/backup/keys.tar.gz ./ > /dev/null 2>&1
	echo "done"
	cd /
else
	echo "keine keys gefunden"
	echo "checke SDA2"
	cd /
fi
umount /dev/sdb2
echo "done"
echo '   6'     > /dev/fpsmall
echo "FDISK" > /dev/fplarge
echo "Partitioniere HDD Datenträger"
HDD=/dev/sda
HDDBOOTFS=$HDD"1"
HDDBOOTFS=$HDD"2"
HDDBOOTFS=$HDD"3"
HDDBOOTFS=$HDD"4"
USB=/dev/sdb
USBBOOT=$USB"1"
dd if=/dev/zero of=$HDD bs=512 count=64
sfdisk --re-read $HDD
# Löscht die Festplatte und erstellt 2 Partitionen
#  1: 512MB Linux Uboot ext3
#  2: rest freier Speicher LINUX ext4 RECORD auf HDD
sfdisk $HDD -uM << EOF
,1024,L
,2048,L
,512,S
,,L
;
EOF
echo "Format Record HDD"
mkfs.ext2 -I128 -b4096 -L USBBOOTFS $HDD"1"
mkfs.ext4 -L RECORD $HDD"2"
mkswap $HDD"3"
mkfs.ext4 -L RECORD $HDD"4"
echo "Kopiere Image auf Festplatte für Installation"
sleep 3
mount $HDD"2" /hdd1
mount $USB"1" /usb1
sleep 5
cd /usb1
ls
cp rootfs.tar.gz /hdd1
cd /
sleep 5
sync
echo '   5'     > /dev/fpsmall
echo "KERNEL" > /dev/fplarge
echo "Flashe Kernel"
dd if=/usb1/uImage of=/dev/mtdblock3
mount $HDD"1" /INTERN
sleep 1
echo '   3'     > /dev/fpsmall
echo "INSTALL" > /dev/fplarge
sync
echo "Installiere RootFS ..."
cd /hdd1
tar -xf rootfs.tar.gz
# setze Mountpoits für HDD
cp /hdd1/var/config/fstab /etc/fstab
sleep 5
cd /
cp /usb1/uImage /INTERN
echo "hdd" > /INTERN/hdd
echo "Lösche RootFS Image File"
sleep 5
sync
cd /
cd hdd1
rm *.tar.gz
echo "done"
echo '   2'     > /dev/fpsmall
echo 'RESTOR'     > /dev/fpsmall
echo "Restore Settings"
if [ -e /install/backup/E2Settings.tar.gz ]; then
	cp /install/backup/E2Settings.tar.gz /hdd1/etc/enigma2
	cd /hdd1/etc/enigma2
	tar -xf E2Settings.tar.gz
	cd ../../..
else
	echo "keine Settings gesichert/restored"
fi
if [ -e /install/backup/keys.tar.gz ]; then
	cp /install/backup/keys.tar.gz /hdd1/var/keys
	cd /hdd1/var/keys
	tar -xf keys.tar.gz
	cd ../../..
else
	echo "keine Keys gesichert/restored"
fi
cd /
umount $USB"1"
sleep 5
sync
umount $HDD"2"
sleep 1
umount $HDD"1"
# erstelle Record Strucktur
mount $HDD"4" /rootfs
sleep 1
mkdir /rootfs/movie
mkdir /rootfs/audio
mkdir /rootfs/picture
umount $HDD"4"
sleep 1
echo '   1'     > /dev/fpsmall
echo "FSCK" > /dev/fplarge
echo "Starte FSCK"
fsck.ext2 -f -y $HDD"1"
sleep 1
fsck.ext4 -f -y $HDD"2"
sleep 1
fsck.ext4 -f -y $HDD"4"
sleep 1
echo "done"
echo "######################################################"
echo ""
echo "  System erfolgreich Installiert, im anschluss wird   "
echo "              das System neu Gestartet                "
echo "                na dann auf gehts ...                 "
echo ""
echo "######################################################"
sleep 1
mount $USB"1" /rootfs
cp /rootfs/uImage /rootfs/uImage_
rm /rootfs/uImage
sync
umount $USB"1"
# Reboot
echo '   0'     > /dev/fpsmall
echo 'REBOOT'   > /dev/fplarge
sleep 2
reboot -f
