#!/bin/sh
# Checkt im install file ob FDisk durchgeführtwerden soll oder nicht
# Für User mit Image auf der HDD kann so die Film Partition erhallten bleiben
echo "umount /dev/sda1"
umount /dev/sda1
echo "done"
echo "FDISK" > /dev/vfd
echo "Partitioniere Datenträger"
HDD=/dev/sda
ROOTFS=$HDD"1"
SYSFS=$HDD"2"
SWAPFS=$HDD"3"
DATAFS=$HDD"4"
dd if=/dev/zero of=$HDD bs=512 count=64
sfdisk --re-read $HDD
# Löscht die Festplatte/Stick und erstellt 4 Partitionen
#  1: 256MB Linux Uboot ext2
#  2:   1GB Linux System ext4
#  3: 128MB Swap > 128 MB sind mehr wie ausreichend ...
#  4: rest freier Speicher LINUX ext4 (bei HDD record)
sfdisk $HDD -uM << EOF
,256,L
,1024,L
,128,S
,,L
;
EOF
echo "done"
echo "Format ALL" > /dev/vfd
echo "Formatiere Partitionen"
echo "Format Uboot"
mkfs.ext2 -I128 -b4096 -L BOOTFS $HDD"1"
echo "Format System"
mkfs.ext4 -L ROOTFS $HDD"2"
echo "Formatiere Swap"
mkswap $SWAPFS
echo "Formatiere Rest Free Space"
mkfs.ext4 -L RECORD $HDD"4"
echo "done"
# Online Image Downloader and Installer

echo "Loading Installer"
# DHCP zuweisung des Netzwerks
echo "Starting dhcp"
echo "DHCP" > /dev/vfd
busybox ifdown -a
busybox ifup -a
busybox ip addr flush eth0
busybox udhcpc -i eth0

# mount neu Formatierten USB vor dem Download
mount /dev/sda2 /sda2
mount /dev/sda2 /sda1
# switch of sda2 for Downloading Image Files
cd /sda2

# Downloading Image
echo "Downloading Versionsinformation"
wget http://dbs-clan.de/argus/installer/RELEASE -O RELEASE
if [ ! -e RELEASE ]; then
  echo "Release Informationen konnten nicht gedownloadet werden !!! Internet Verbindung bitte Prüfen"
  echo "DL Error" > /dev/vfd
else
  VERSION=`cat RELEASE`
  echo "Release V$VERSION wird Installiert"
  echo "Re-$VERSION" > /dev/vfd
  sleep 5
fi
echo "Downloading Image..."
echo "DL Image..." > /dev/vfd
wget http://dbs-clan.de/argus/installer/release-$VERSION.tar.gz -O image.tar.gz
sleep 2
if [ ! -e image.tar.gz ]; then
  echo "Image konnte nicht gedownloadet werden !!! Internet Verbindung bitte Prüfen"
  echo "DL Error" > /dev/vfd
else
  echo "Download Kommplett, starte entpacken..."
  echo "DL OK" > /dev/vfd
  sleep 5
  echo "Entpacke..." > /dev/vfd
  tar -xf image.tar.gz
  echo "Entpacken abgeschlossen, starte USB Sync"
  echo "Fertig" > /dev/vfd
  sync
  # erstellt Bootkernel dir auf sda1
  echo "Kopiere Kernel" > /dev/vfd
  mkdir /sda1/boot
  # kopiert Kernel in boot dir
  cp /sda2/boot/uImage.gz /sda1/boot/uImage.gz
  # switch in Bootdir
  cd /sda1/boot
  # symlink erstellen vom Kernel 
  ln -s uImage.gz uImage
  # switch back
  cd /sda2
  sleep 2
  # Löschen der nicht benötigten Dateien
  echo "Aufräumen..." > /dev/vfd
  rm -rf boot
  rm image.tar.gz
  rm install
  # entpacken des Dateisystems für sda2
  echo "Entpacke SDA2" > /dev/vfd
  tar -xf *.tar.gz
  sync
  sleep 5
  # Löschen des tar.gz
  echo "Aufräumen..." > /dev/vfd
  rm *.tar.gz
  # wait a moment for slow USB-Sticks
  sleep 2
  sync
  echo "Reboot vorbereiten"
  echo "Reboot und GO" > /dev/vfd
  sleep 5
  reboot -f
fi
