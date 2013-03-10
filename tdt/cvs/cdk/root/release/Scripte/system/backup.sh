#!/bin/sh
#

DATE=`date +"%Y.%m.%d_%H.%M.%S"`_backup.e2.tar.gz
ENIGMA2=`busybox pidof enigma2`
RCS=`busybox pidof rcS`
SFRAME=`busybox pidof showiframe`
echo "----------------------------------------"
echo "| syncing disk" > /dev/vfd
sync
if [ "$RCS" -eq 0 ]; then
	echo "| rcS not running"
else
	echo "| kill rcS" > /dev/vfd
	killall -9 rcS
fi

if [ "$ENIGMA2" -eq 0 ]; then
	echo "| enigma2 not running"
else
	echo "| kill enigma2" > /dev/vfd
	killall -9 enigma2
fi

if [ "$SFRAME" -eq 0 ]; then
	echo "| showiframe not running"
else
	echo "| kill showiframe" > /dev/vfd
	killall -9 showiframe
fi

echo "| touch firstboot" > /dev/vfd
touch /var/etc/.firstboot
echo "-----"
echo "| Waiting"
echo "-----"

if [ -e /etc/init.d/umount.sh ]; then
	echo "UMOUNT your MOUNTS - look LCD for infos"
	/etc/init.d/umount.sh
	sleep 10
else
	echo "UMOUNT ERROR - please install AUTOMOUNT v1.4" > /dev/vfd
fi

## create media execlude list
echo "Running..." > /dev/vfd
TMP=.tmp
EXECLUDLIST=.execludlist
echo "" > $TMP
echo "" > $EXECLUDLIST

ls -1 /media > $TMP
LIST=`cat $TMP`

for ROUND in $LIST; do
        echo " --exclude=/media/$ROUND/*" >> $EXECLUDLIST
        sed '/^ *$/d' -i $EXECLUDLIST

done
EXECLUDMEDIA=`cat $EXECLUDLIST | tr -d '\n' | sed 's/*/* /'`
rm $EXECLUDLIST
rm $TMP

## create mnt execlude list

TMP=.tmp
EXECLUDLIST=.execludlist
echo "" > $TMP
echo "" > $EXECLUDLIST

ls -1 /mnt > $TMP
LIST=`cat $TMP`

for ROUND in $LIST; do
        echo " --exclude=/mnt/$ROUND/*" >> $EXECLUDLIST
        sed '/^ *$/d' -i $EXECLUDLIST

done
EXECLUDMNT=`cat $EXECLUDLIST | tr -d '\n' | sed 's/*/* /'`
rm $EXECLUDLIST
rm $TMP

## create hdd execlude list

TMP=.tmp
EXECLUDLIST=.execludlist
echo "" > $TMP
echo "" > $EXECLUDLIST

ls -1 /hdd > $TMP
LIST=`cat $TMP`

for ROUND in $LIST; do
        echo  " --exclude=/hdd/$ROUND/*" >> $EXECLUDLIST
        sed '/^ *$/d' -i $EXECLUDLIST

done
EXECLUDHDD=`cat $EXECLUDLIST | tr -d '\n' | sed 's/*/* /'`
rm $EXECLUDLIST
rm $TMP

##
echo "|"
echo "| KOMPRESS      : zcf"
echo "| EXECLUD-SELF  : --exclude=`date +"%Y.%m.%d_%H.%M.%S"`_backup.e2.tar"
echo "| EXECLUD-FILE  : --exclude=.execludlist --exclude=.tmp --exclude=swapfile" 
echo "| EXECLUD-SYS   : --exclude=sys/* --exclude=proc/* --exclude=tmp/* --exclude=ram/* --exclude=dev/* --exclude=dev.static/*"
echo "| EXECLUD-HDD   : $EXECLUDHDD"
echo "| EXECLUD-MNT   : $EXECLUDMNT"
echo "| EXECLUD-MEDIA : $EXECLUDMEDIA"
echo "| ADD-LIST      : --add-file=/dev/MAKEDEV /"
echo "|"
echo "| Backup started"
/var/config/system/tar zcf /Enigma2_System_Ordner/Backups/`date +"%Y.%m.%d_%H.%M.%S"`_backup.e2.tar.gz --exclude=`date +"%Y.%m.%d_%H.%M.%S"`_backup.e2.tar.gz --exclude=.execludlist --exclude=.tmp --exclude=swapfile --exclude=sys/* --exclude=proc/* --exclude=tmp/* --exclude=ram/* --exclude=dev/* --exclude=dev.static/* --exclude=Enigma2_System_Ordner/Backups/* --exclude=.Trash-0/* --exclude=.Trash-1000/* --exclude=var/keys/Benutzerdaten/.emu/* --exclude=var/keys/Benutzerdaten/.system/* --exclude=var/keys/Benutzerdaten/.web/*$EXECLUDHDD $EXECLUDMNT $EXECLUDMEDIA --add-file=/dev/MAKEDEV /


echo "| Backup created"
echo "-----"
echo "| remove firstboot"
rm /var/etc/.firstboot
echo "| syncing disk" > /dev/vfd
sync
echo "| your backup idled in /Enigma2_System_Ordner/Backups/$DATE"
echo "| copy to pc with ftpclient"
echo "| restart your Box or start enigma2"
echo "-----"
echo "| Backup done" > /dev/vfd
echo "----------------------------------------"
rm /var/config/.power
rm /var/config/system/.backup
sleep 2
reboot -f
