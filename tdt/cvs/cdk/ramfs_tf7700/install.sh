echo '   7'     > /dev/fpsmall
echo "SAVE" > /dev/fplarge
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
echo "done"
echo '   6'     > /dev/fpsmall
echo "FDISK" > /dev/fplarge
echo "Partitioniere HDD Datenträger"
HDD=/dev/sda
HDDBOOTFS=$HDD"1"
dd if=/dev/zero of=$HDD bs=512 count=64
sfdisk --re-read $HDD
# Löscht die Festplatte und erstellt 2 Partitionen
#  1: 512MB Linux Uboot ext3
#  2: rest freier Speicher LINUX ext4 RECORD auf HDD
sfdisk $HDD -uM << EOF
,,L
;
EOF
echo "Format Record HDD"
mkfs.ext4 -L RECORD $HDD"1"
echo "Kopiere Image auf Festplatte für Installation"
sleep 3
mount $HDD"1" /hdd1
mount /dev/sdb1 /rootfs
sleep 1
cp /rootfs/rootfs.tar.gz /hdd1/rootfs.tar.gz
echo "erstelle Record Strucktur"
mkdir /hdd1/movie
mkdir /hdd1/picture
mkdir /hdd1/audio
sleep 5
sync
echo '   5'     > /dev/fpsmall
echo "KERNEL" > /dev/fplarge
echo "Flashe Kernel"
dd if=/rootfs/uImage of=/dev/mtdblock3
echo "Umount USB"
umount /dev/sdb1
echo "Partitioniere USB Datenträger"
USB=/dev/sdb
ROOTFS=$USB"1"
SYSFS=$USB"2"
SWAPFS=$USB"3"
DATAFS=$USB"4"
dd if=/dev/zero of=$USB bs=512 count=64
sfdisk --re-read $USB
# Löscht die Festplatte/Stick und erstellt 4 Partitionen
#  1: 512MB Linux Uboot ext4
#  2:   1GB Linux System ext4
#  3: 64MB Swap > 64 MB sind mehr wie ausreichend ...
#  4: rest freier Speicher LINUX ext4 (bei HDD record)
sfdisk $USB -uM << EOF
,512,L
,1024,L
,64,S
,,L
;
EOF
echo "done"
echo '   4'     > /dev/fpsmall
echo "FORMAT" > /dev/fplarge
echo "Formatiere Partitionen"
echo "Format Uboot"
mkfs.ext2 -I128 -b4096 -L USBBOOTFS $USB"1"
echo "Format System"
mkfs.ext4 -L USBROOTFS $USB"2"
echo "Formatiere Swap"
mkswap $SWAPFS
echo "Formatiere Rest Free Space"
mkfs.ext4 -L USBRECORD $USB"4"
echo "done"
# Remount /dev/sda2 zu /INTERN
mount $USB"1" /usb1
mount $USB"2" /INTERN
echo '   3'     > /dev/fpsmall
echo "INSTALL" > /dev/fplarge
echo "Kopiere RootFS Image auf /dev/sda2..."
cp /hdd1/*.tar.gz /INTERN
rm /hdd1/*.tar.gz
sleep 5
sync
echo "Installiere RootFS ..."
cd /INTERN
tar -xf rootfs.tar.gz
sleep 5
cd /
cp /INTERN/boot/uImage /usb1/uImage
echo "Lösche RootFS Image File"
sleep 5
sync
rm /INTERN/*.tar.gz
echo "done"
echo '   2'     > /dev/fpsmall
echo 'RESTOR'     > /dev/fpsmall
echo "Restore Settings"
if [ -e /install/backup/E2Settings.tar.gz ]; then
	cp /install/backup/E2Settings.tar.gz /INTERN/etc/enigma2
	cd /INTERN/etc/enigma2
	tar -xf E2Settings.tar.gz
	cd ../../..
else
	echo "keine Settings gesichert/restored"
fi
if [ -e /install/backup/keys.tar.gz ]; then
	cp /install/backup/keys.tar.gz /INTERN/var/keys
	cd /INTERN/var/keys
	tar -xf keys.tar.gz
	cd ../../..
else
	echo "keine Keys gesichert/restored"
fi
cd /
umount $USB"1"
sleep 5
sync
umount $USB"2"
sleep 1
umount $HDD"1"
sleep 1
echo '   1'     > /dev/fpsmall
echo "FSCK" > /dev/fplarge
echo "Starte FSCK"
fsck.ext2 -f -y $USB"1"
sleep 1
fsck.ext4 -f -y $USB"2"
sleep 1
fsck.ext4 -f -y $USB"4"
sleep 1
fsck.ext4 -f -y $HDD"1"
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
# Reboot
echo '   0'     > /dev/fpsmall
echo 'REBOOT'   > /dev/fplarge
sleep 2
reboot -f
