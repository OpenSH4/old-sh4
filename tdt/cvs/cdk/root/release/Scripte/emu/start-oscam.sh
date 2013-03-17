#!/bin/sh
if [ -e /var/emu/oscam ]; then
info1="Stoppe Cam ..."
info2="Oscam startet..."
info3="Oscam ist gestartet"
number=`cat /var/emu/setemu`
sleep 1
if [ "$number" = "Oscam" ]; then
    echo $info1
    killall -9 oscam > /dev/null
fi
echo $info2
#/var/emu/incubusCamd.sh4_e2 /var/keys >/dev/null &
#sleep 3
/var/emu/oscam -c /var/keys >/dev/null &
echo $info3
/bin/echo "Oscam" > /var/emu/setemu
/bin/echo "1" > /var/emu/emudual
echo ""
echo "Emu zum Autostart hizugefügt"
exit 0
else
echo "nicht Installiert"
fi
