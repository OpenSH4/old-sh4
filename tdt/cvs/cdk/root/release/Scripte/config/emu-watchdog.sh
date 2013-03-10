#!/bin/sh

# Oscam-Watchdog-Skript das alle 60 Sekunden überprüft, ob Oscam läuft und gegebenenfalls neu startet.
# Dabei wird protokolliert, wie oft es abgefragt, bzw. Oscam neu gestartet werden musste.
#
# Autor: DrStoned
# Mod by Ducktrick
# Version: 0.1.1

INTERVALL=30 # Setzt den Intervall wie ihr wollt !!!
echo ""
echo "##################################"
echo "      Emu Watchdog gestartet      "
echo "Check Intervall ist auf $INTERVALL gesetzt"
echo "##################################" 

while sleep $INTERVALL 
do
EMUCHECK=`cat /var/emu/setemu`
EMUCHECK2=`cat /var/emu/setemu2`

	# Emu start zuordnung, je nach Check
	if [ "$EMUCHECK" = "Oscam" ]; then
		EMUDIR=/var/emu/oscam
		EMU=oscam
		EMURUN=$EMUCHECK
	elif [ "$EMUCHECK" = "MG-Camd" ]; then
		EMUDIR=/var/emu/mgcamd.sh4
		EMU=mgcamd.sh4
		EMURUN=$EMUCHECK
	elif [ "$EMUCHECK" = "Vizcam" ]; then
		EMUDIR=/var/emu/vizcam.sh4
		EMU=vizcam.sh4
		EMURUN=$EMUCHECK
	elif [ "$EMUCHECK" = "Mbox" ]; then
		EMUDIR=/var/emu/mbox_0.6_BETA_0010
		EMU=mbox_0.6_BETA_0010
		EMURUN=$EMUCHECK
	elif [ "$EMUCHECK" = "incubusCamd" ]; then
		EMUDIR=/var/emu/incubusCamd_0.99
		EMU=incubusCamd_0.99
		EMURUN=$EMUCHECK
	elif [ "$EMUCHECK" = "camd3.902" ]; then
		EMUDIR=/var/emu/camd3_902
		EMU=camd3_902
		EMURUN=$EMUCHECK
	fi

	if [ "$EMUCHECK2" = "MG-Camd" ]; then
		EMUDIR2=/var/emu/mgcamd.sh4
		EMU2=mgcamd.sh4
		EMURUN2=$EMUCHECK2
	elif [ "$EMUCHECK2" = "Mbox" ]; then
		EMUDIR2=/var/emu/mbox_0.6_BETA_0010
		EMU2=mbox_0.6_BETA_0010
		EMURUN2=$EMUCHECK2
	elif [ "$EMUCHECK2" = "incubusCamd" ]; then
		EMUDIR2=/var/emu/incubusCamd_0.99
		EMU2=incubusCamd_0.99
		EMURUN2=$EMUCHECK2
	elif [ "$EMUCHECK2" = "camd3.902" ]; then
		EMUDIR2=/var/emu/camd3_902
		EMU2=camd3_902
		EMURUN2=$EMUCHECK2
	fi

if [ "$EMUCHECK" = "kein_Emu" ]; then
	echo "Single-Emu-not-RUN..."
elif [ "$EMUCHECK" = "$EMURUN" ]; then
   if ps | grep -v grep | grep -w -c $EMUDIR > /dev/null # check ob der Emu Läuft
      then
      echo "" > /dev/null
   else
      #killall -9 $EMU #Nich nötig Läuft ja nicht ;)
      echo `date` "Emu nicht gestartet, Neustart $EMUCHECK...Fertig" >> /tmp/watchdog.log # Erstellt log bei Crash
      sleep 1
	echo "$EMUCHECK Crash...Restart"
# Emu start zuordnung, je nach Check
	if [ "$EMUCHECK" = "Oscam" ]; then
		/var/emu/oscam -c /var/keys &
	elif [ "$EMUCHECK" = "MG-Camd" ]; then
		/var/emu/mgcamd.sh4 /var/keys/mg_cfg>/dev/null &
	elif [ "$EMUCHECK" = "Vizcam" ]; then
		/var/emu/vizcam.sh4 /var/keys/vizcam.conf >/dev/null &
	elif [ "$EMUCHECK" = "Mbox" ]; then
		/var/emu/mbox_0.6_BETA_0010 /var/keys/mbox.cfg >/dev/null &
	elif [ "$EMUCHECK" = "incubusCamd" ]; then
		/var/emu/incubusCamd_0.99 >/dev/null &
	elif [ "$EMUCHECK" = "camd3.902" ]; then
		/var/emu/camd3_902 /var/keys/camd3.config >/dev/null &
	fi

   fi
fi
if [ "$EMUCHECK2" = "kein_Emu" ]; then
	echo "Dual-Emu-not-RUN..."
elif [ "$EMUCHECK2" = "$EMURUN2" ]; then
   if ps | grep -v grep | grep -w -c $EMUDIR2 > /dev/null # check ob der Emu2 Läuft
      then
      echo "" > /dev/null
   else
      #killall -9 $EMU #Nich nötig Läuft ja nicht ;)
      echo `date` "Emu nicht gestartet, Neustart $EMUCHECK2...Fertig" >> /tmp/watchdog.log # Erstellt log bei Crash
      sleep 1
	echo "$EMUCHECK2 Crash...Restart"
# Emu start zuordnung, je nach Check
	if [ "$EMUCHECK2" = "MG-Camd" ]; then
		/var/emu/mgcamd.sh4 /var/keys/mg_cfg>/dev/null &
	elif [ "$EMUCHECK2" = "Mbox" ]; then
		/var/emu/mbox_0.6_BETA_0010 /var/keys/mbox.cfg >/dev/null &
	elif [ "$EMUCHECK2" = "incubusCamd" ]; then
		/var/emu/incubusCamd_0.99 >/dev/null &
	elif [ "$EMUCHECK2" = "camd3.902" ]; then
		/var/emu/camd3_902 /var/keys/camd3.config >/dev/null &
	fi

   fi
fi
done
