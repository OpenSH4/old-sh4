#!/bin/sh
EMU1=`cat /var/emu/setemu`
EMU2=`cat /var/emu/setemu2`
Info="Laufende Emus : $EMU1 $EMU2  Stoppen ..."
Info1="$EMU1 Gestoppt !!!"
Info4="$EMU2 Gestoppt !!!"
Info2="Durch das Stoppen der Emus wurde auch das Automatische Starten Deaktiviert"
Info3="Nach dem Start eines Emus wird dieser wieder zum Autostart hinzugefügt"
echo "$Info"
if [ "$EMU1" = "MG-Camd" ]; then
	killall -9 mgcamd.sh4
elif [ "$EMU1" = "Vizcam" ]; then
	killall -9 vizcam.sh4 > /dev/null
elif [ "$EMU1" = "Oscam" ]; then
	killall -9 oscam
elif [ "$EMU1" = "camd3.902" ]; then
	killall -9 camd3_902
elif [ "$EMU1" = "incubus" ]; then
	killall -9 incubusCamd_0.99 > /dev/null
elif [ "$EMU1" = "Mbox" ]; then
	 killall -9 mbox_0.6_BETA_0010 > /dev/null
fi
if [ "$EMU2" = "MG-Camd" ]; then
	killall -9 mgcamd.sh4
elif [ "$EMU2" = "camd3.902" ]; then
	killall -9 camd3_902
elif [ "$EMU2" = "incubus" ]; then
	killall -9 incubusCamd_0.99 > /dev/null
elif [ "$EMU2" = "Mbox" ]; then
	killall -9 mbox_0.6_BETA_0010 > /dev/null
fi
/bin/echo "kein_Emu" > /var/emu/setemu
/bin/echo "kein_Emu" > /var/emu/setemu2
echo "$Info1"
echo "$Info4"
echo ""
echo "$Info2"
echo "$Info3"


