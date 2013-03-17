#!/bin/sh
if [ -e /var/emu/vizcam.sh4 ]; then
info1="Stoppe Cam ..."
info2="Vizcam 1.35 startet..."
info3="Vizcam ist gestartet"
number=`cat /var/emu/setemu`
sleep 1
if [ "$number" = "Vizcam" ]; then
    echo $info1
    killall -9 vizcam.sh4 > /dev/null
fi
echo $info2
/var/emu/vizcam.sh4 /var/keys/vizcam.conf >/dev/null &
echo $info3
/bin/echo "Vizcam" > /var/emu/setemu
/bin/echo "1" > /var/emu/emudual
echo ""
echo "Emu zum Autostart hizugefügt"
else
echo "nicht Installiert"
fi
