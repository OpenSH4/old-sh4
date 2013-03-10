#!/bin/sh
EMU1=`cat /var/emu/setemu`
EMU2=`cat /var/emu/setemu2`
if [ "$EMU1" = "MG-Camd" ]; then
	/var/config/emu/start-mgcamd.sh &
elif [ "$EMU1" = "Vizcam" ]; then
	/var/config/emu/start-vizcam.sh &
elif [ "$EMU1" = "Oscam" ]; then
	/var/config/emu/start-oscam.sh &
elif [ "$EMU1" = "camd3.902" ]; then
	/var/config/emu/start-camd3.sh &
elif [ "$EMU1" = "incubus" ]; then
	/var/config/emu/start-incubus.sh &
elif [ "$EMU1" = "Mbox" ]; then
	/var/config/emu/start-mbox.sh &
else
	echo "kein Emu gesetzt"
fi
if [ "$EMU2" = "MG-Camd" ]; then
	/var/config/emu/start-mgcamd.sh &
elif [ "$EMU2" = "camd3.902" ]; then
	/var/config/emu/start-camd3.sh &
elif [ "$EMU2" = "incubus" ]; then
	/var/config/emu/start-incubus.sh &
elif [ "$EMU2" = "Mbox" ]; then
	/var/config/emu/start-mbox.sh &
else
	echo "kein 2 Emu"
fi
