#!/bin/sh
if [ -e /var/emu/camd3_902 ]; then
info1="Stoppe Cam ..."
info2="camd3.902 startet..."
info3="camd3.902 ist gestartet"
number=`cat /var/emu/setemu`
sleep 1
if [ "$number" = "camd3.902" ]; then
    echo $info1
    killall -9 camd3_902 > /dev/null
fi
echo $info2
    /var/emu/camd3_902 /var/keys/camd3.config >/dev/null &
echo $info3
/bin/echo "camd3.902" > /var/emu/setemu
/bin/echo "1" > /var/emu/emudual
echo ""
echo "Emu zum Autostart hizugefügt"
exit 0
else
echo "Nicht Installiert"
fi
