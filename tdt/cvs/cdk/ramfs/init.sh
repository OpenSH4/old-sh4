#!/bin/sh

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
root="/dev/sda1"
rootfs="/dev/sda2"
record="/dev/sda4"

echo "Sleep 3 Second and wait of the /dev/sda1"
sleep 3

echo "INIT VFD"
insmod /drvko/aotom.ko I2C_bus_num=2 I2C_bus_add=0x28
sleep 1
insmod /drvko/aotom_vip1.ko I2C_bus_num=2 I2C_bus_add=0x40

#Process command line options
for i in $(cat /proc/cmdline); do
	case $i in
		root\=*)
			root=$(get_opt $i)
			;;
		init\=*)
			init=$(get_opt $i)
			;;
	esac
done
if [ `tune2fs -l /dev/sda1 | grep -i "Filesystem state" | awk '{ print $3 }'` == "clean" ]; then
    echo "SDA1 OK"
else
    echo "FSCK SDA1 run"
    echo "FSCK SDA1 run" > /dev/vfd
    fsck.ext2 -f -y "${root}" > /dev/null
    tune2fs -l "${root}" | grep -i "Filesystem state"
fi
if [ `tune2fs -l /dev/sda2 | grep -i "Filesystem state" | awk '{ print $3 }'` == "clean" ]; then
    echo "SDA2 OK"
else
    echo "FSCK SDA2 run"
    echo "FSCK SDA2 run" > /dev/vfd
    fsck.ext4 -f -y "${rootfs}" > /dev/null
    tune2fs -l "${rootfs}" | grep -i "Filesystem state"
fi
if [ `tune2fs -l /dev/sda4 | grep -i "Filesystem state" | awk '{ print $3 }'` == "clean" ]; then
    echo "SDA4 OK"
else
    echo "FSCK SDA4 run"
    echo "FSCK SDA4 run" > /dev/vfd
    fsck.ext4 -f -y "${record}" > /dev/null
    tune2fs -l "${record}" | grep -i "Filesystem state"
fi
#Mount the root device
echo "Mount rootfs /dev/sda1"
mount "${root}" /rootfs
# Check auf installing System Files
if [ -e /rootfs/install ]; then
	cd /install
	./install.sh
elif [ -e /rootfs/update ]; then
	cd /install
	./update.sh
fi
# Wenn kein install mounte rootfs to start
# Switch from /dev/sda1 to /dev/sda2 (ROOTFS)
if [ ! -e /rootfs/install ]; then
echo "umount /dev/sda1"
umount "${root}"
fi
echo "mount /dev/sda2"
mount "${rootfs}" /rootfs

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
echo "Failed to switch_root, dropping to a shell"
exec sh
