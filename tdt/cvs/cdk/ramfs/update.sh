echo "UPDATE..." > /dev/vfd
# Kopiert das Update File in den Ram um es Später zu installieren
echo "Copy Update in den RAM"
cp /rootfs/*.tar.gz /install
echo "done"
echo "lösche Update vom SDA1"
# Löscht das Update File von der Partition
rm /rootfs/*.tar.gz
rm /rootfs/update
# Wechselt zur Zielpartition
echo "umount /dev/sda1"
umount /dev/sda1
echo "mount /dev/sda2"
mount /dev/sda2 /rootfs
echo "Copy Update vom RAM zum Rootfs"
echo "Copy..." > /dev/vfd
# Kopiert das updaten file auf die Ziehlpartition
cp /install/*.tar.gz /rootfs
echo "Lösche tar.gz aus RAM"
# löscht es aus den RAM Speicher
rm /install/*tar.gz
echo "done"
echo "Install Update"
echo "Install..."
# Entpackt das Update und löscht es anschliessend
cd /rootfs
tar -xf *.tar.gz
echo "done"
echo "Lösche tar.gz von SDA2"
rm /rootfs/*.tar.gz
echo "Update Komplett"
cd /
echo "Starte System"
umount /dev/sda2
mount /dev/sda1 /rootfs
echo "Ready..." > /dev/vfd

