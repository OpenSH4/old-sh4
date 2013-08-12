echo "UPDATE..." > /dev/fplarge
sleep 5
#mountet die ziel Partition nach /update, dadurch können die Updates größer 95MB sein
if [ -e /rootfs/hdd ]; then
	echo "Mount interne HDD, Kein USB Mounted"
	mount /dev/sda2 /update
	LAUFWERK=HDD
else
	mount /dev/sdb2 /update
	LAUFWERK=USB
fi
# Kopiert das Update File auf die /dev/sda2 Partition um es Später zu installieren
echo "Copy Update auf Ziel Partition"
echo "Copy..." > /dev/fplarge
cp /rootfs/*.tar.gz /update
echo "done"
sleep 2
echo "lösche Update vom SDA1"
# Löscht das Update File von der Partition
rm /rootfs/*.tar.gz
rm /rootfs/update
sleep 2
echo "Install Update"
echo "Install..."
# Entpackt das Update und löscht es anschliessend
cd /update
tar -xf *.tar.gz
sleep 2
echo "done"
echo "Lösche tar.gz von SDA2"
rm /update/*.tar.gz
echo "Update Komplett"
sleep 3
cd /
echo "Starte System"
if [ $LAUFWERK = USB ]; then
	umount /dev/sdb2 /update
else
	echo "Mount interne HDD, Kein USB Mounted"
	umount /dev/sda2 /update
fi
echo "Ready..." > /dev/fplarge

