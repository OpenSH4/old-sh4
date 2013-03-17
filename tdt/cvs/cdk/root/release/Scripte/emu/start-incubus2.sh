#!/bin/sh
if [ -e /var/emu/incubusCamd_0.99 ]; then
info1="Stoppe Cam ..."
info2="incubusCamd startet..."
info3="incubusCamd ist gestartet"
number=`cat /var/emu/setemu2`
sleep 1
if [ "$number" = "incubus" ]; then
    echo $info1
    killall -9 incubusCamd_0.99 > /dev/null
fi
echo $info2
    /var/emu/incubusCamd_0.99 >/dev/null &
echo $info3
/bin/echo "incubusCamd" > /var/emu/setemu2
/bin/echo "2" > /var/emu/emudual
echo ""
echo "Emu zum Autostart hizugefügt"
exit 0
else
echo "Nicht Installiert"
fi
