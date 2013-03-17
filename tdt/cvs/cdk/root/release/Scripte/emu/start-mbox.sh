#!/bin/sh
if [ -e /var/emu/mbox_0.6_BETA_0010 ]; then
info1="Stoppe Cam ..."
info2="Mbox startet..."
info3="Mbox ist gestartet"
number=`cat /var/emu/setemu`
sleep 1
if [ "$number" = "Mbox" ]; then
    echo $info1
    killall -9 mbox_0.6_BETA_0010 > /dev/null
fi
echo $info2
    /var/emu/mbox_0.6_BETA_0010 /var/keys/mbox.cfg >/dev/null &
echo $info3
/bin/echo "Mbox" > /var/emu/setemu
/bin/echo "1" > /var/emu/emudual
echo ""
echo "Emu zum Autostart hizugefügt"
exit 0
else
echo "Nicht Installiert"
fi
