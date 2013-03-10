#!/bin/sh
if [ -e /var/emu/mgcamd.sh4 ]; then
info1="Stoppe Cam ..."
info2="mgcamd 1.38 startet..."
info3="mgcamd 1.38 ist gestartet"
number=`cat /var/emu/setemu`
sleep 1
if [ "$number" = "MG-Camd" ]; then
    echo $info1
    killall -9 mgcamd.sh4 > /dev/null
fi
echo $info2
/var/emu/mgcamd.sh4 /var/keys/mg_cfg>/dev/null &
echo $info3
/bin/echo "MG-Camd" > /var/emu/setemu
/bin/echo "1" > /var/emu/emudual
echo ""
echo "Emu zum Autostart hizugefügt"
exit 0
else
echo "nicht Installiert"
fi
