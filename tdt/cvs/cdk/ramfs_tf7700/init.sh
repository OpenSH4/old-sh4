#!/bin/sh
# Es scheinen beim RAMFS das der USB als SDA erkannt wird und die Interne HDD als SDB
# Aufgrund dessen ist hier alles etwas verdreht ;)
#Mount things needed by this script
/sbin/mount -t proc proc /proc
/sbin/mount -t sysfs sysfs /sys

#Create all the symlinks to /bin/busybox
echo "---------------- RAMFS Load ---------------------"
echo "-------------------------------------------------"
echo "Installing Busybox"
busybox --install -s

#Create device nodes
mknod /dev/tty c 5 0
mdev -s

#Function for parsing command line options with "=" in them
# get_opt("init=/sbin/init") will return "/sbin/init"
get_opt() {
	echo "$@" | cut -d "=" -f 2
}

#Defaults
init="/sbin/init"
usbroot="/dev/sdb1"
usbrootfs="/dev/sdb2"
record="/dev/sdb4"
hddrecord="/dev/sda1"

# Läd den Display Treiber
echo "INIT VFD"
insmod /drvko/e2_proc.ko
insmod /drvko/tffp.ko

#Process command line options
for i in $(cat /proc/cmdline); do
	case $i in
		root\=*)
			root=/dev/sdb1
			;;
		init\=*)
			init=/sbin/init
			;;
	esac
done
#Mount the root device
echo "Mount rootfs from HDD"
mount $usbroot /rootfs
if [ -e /rootfs/uImage ];then
	echo "USB Mounted"
	echo "IS USB" > /dev/fplarge
	sleep 2
	LAUFWERK=USB
	DEVICES=SDB
else
	mount /dev/sda1 /rootfs
	echo "IS HDD" > /dev/fplarge
	sleep 2
	LAUFWERK=HDD
	DEVICES=SDA
fi
# Devices als Partition definiert
DEVICES1=$DEVICES"1"
DEVICES2=$DEVICES"2"
DEVICES4=$DEVICES"4"

# Checkt auf Updates oder Install Files
if [ -e /rootfs/install ]; then
	HDDINSTALL=`cat /rootfs/install`
	if [ "$HDDINSTALL" = "hdd" ]; then
		# Installiert auf Interner HDD
		echo 'HDD INST'     > /dev/fplarge
		sleep 2
		cd /install
		./install_hdd.sh
	else
		# Installiert auf Externen USB
		echo 'USB INST'     > /dev/fplarge
		sleep 2
		umount $usbroot
		cd /install
		./install.sh
	fi
elif [ -e /rootfs/update ]; then
	echo "UPDATE" > /dev/fplarge
	sleep 2
	cd /install
	./update.sh
fi
# Install Check für erst Installation
if [ -e /rootfs/hdd ]; then
	init="/sbin/init"
	usbroot="/dev/sda1"
	usbrootfs="/dev/sda2"
	record="/dev/sda4"
else
	echo 'Ist USB ...'
fi
# umount für FSCK
if [ $LAUFWERK = USB ]; then
	umount /dev/sdb1
else
	echo "Mount interne HDD, Kein USB Mounted"
	umount /dev/sda1
fi
# Quik FSCK Check
if [ `tune2fs -l $usbroot | grep -i "Filesystem state" | awk '{ print $3 }'` == "clean" ]; then
    echo "$DEVICES1 OK"
else
    echo "FSCK $DEVICES1 run" > /fsck.log
    echo "FSCK $DEVICES1" > /dev/fplarge
    fsck.ext2 -f -y "${root}" >> /fsck.log
    tune2fs -l "${root}" | grep -i "Filesystem state" >> /fsck.log
fi
if [ `tune2fs -l $usbrootfs | grep -i "Filesystem state" | awk '{ print $3 }'` == "clean" ]; then
    echo "$DEVICES2 OK"
else
    echo "FSCK $DEVICES2 run" > /fsck.log
    echo "FSCK $DEVICES2" > /dev/fplarge
    fsck.ext4 -f -y "${usbrootfs}" >> /fsck.log
    tune2fs -l "${usbrootfs}" | grep -i "Filesystem state" >> /fsck.log
fi
if [ `tune2fs -l ${record} | grep -i "Filesystem state" | awk '{ print $3 }'` == "clean" ]; then
    echo "$DEVICES4 OK"
else
    echo "FSCK $DEVICES4 run" > /fsck.log
    echo "FSCK $DEVICES4" > /dev/fplarge
    fsck.ext4 -f -y "${record}" >> /fsck.log
    tune2fs -l "${record}" | grep -i "Filesystem state" >> /fsck.log
fi
echo "Mount USB Device"
mount "${usbroot}" /usb1

# Wenn kein install mounte rootfs to start
# Switch from /dev/sda1 to /dev/sda2 (ROOTFS)
if [ ! -e /usb1/install ]; then
echo "umount /dev/sda1"
umount "${usbroot}"
fi
echo "mount /dev/sda2"
mount "${usbrootfs}" /rootfs

if [ -e /rootfs/var/etc/.firstboot ]; then
   echo "WAIT" > /dev/fpsmall
   echo "3 SEC" > /dev/fplarge
	if [ -e /rootfs/hdd ]; then
		cp /rootfs/var/config/fstab /rootfs/etc/fstab
	fi
   cp /rootfs/var/config/devs.tar.gz /rootfs/dev/
   rm /rootfs/var/etc/.firstboot
   cd /rootfs/dev
   tar -xf *.tar.gz
   #touch /dev/.devfsd
fi

# erst hier ist sda2 mounted
# Kopiert das FSCK.log fals vorhanden auf /dev/sdb2
# Später kann dieses File im TeamCS Menü aufgerufen werden
# um nachvollziehen zu können was defekt war
if [ -e /fsck.log ]; then
	cp /fsck.log /rootfs/var/config/fsck.log
	rm /fsck.log
fi
#Check if $init exists and is executable
if [[ -x "/rootfs/${init}" ]] ; then
	#Unmount all other mounts so that the ram used by
	#the initramfs can be cleared after switch_root
	umount /sys /proc
	
	#Switch to the new root and execute init
	echo "Switch and Load new RootFS"
	exec switch_root /rootfs "${init}"
fi

#This will only be run if the exec above failed
echo 'ERROR'     > /dev/fplarge
echo 'NOFS'     > /dev/fpsmall
echo "Failed to switch_root, dropping to a shell"
exec sh
