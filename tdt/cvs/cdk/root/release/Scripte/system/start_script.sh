if [ ! -e /etc/profile ]; then
	echo "erstelle Profile ..."
	cp /etc/profile.bak /etc/profile
fi
####### MAC #######################
if [ -e /var/keys/Benutzerdaten/.system/wol ]; then
MAC=`cat /var/keys/Benutzerdaten/.system/wol`
if [ "$MAC" = "an" ]; then
	echo "MAC Intervall gestartet ..."
	/var/config/timeping.sh > /dev/null &
else
	echo "MAC Intervall Deaktiviert ..."
fi
fi
####### Display Uhr #######################
if [ -e /var/keys/Benutzerdaten/.system/uhr ]; then
UHR=`cat /var/keys/Benutzerdaten/.system/uhr`
if [ "$UHR" = "an" ]; then
	echo "Display Uhr gestartet ..."
	echo "START" > /var/config/boxoff
	/var/config/time.sh > /dev/null &
else
	echo "Display Uhr Deaktiviert ..."
fi
else
	echo "Display Uhr nicht Aktiv ..."
fi
###### FSCK User Check #######################
if [ -e /var/keys/Benutzerdaten/.system/fsck ]; then
	echo "USER FSCK Aktiv ..."
FSCK=`cat /var/keys/Benutzerdaten/.system/fsck`
if [ "$FSCK" = "an" ]; then
	echo "USER FSCK -- zähle Bootvorgänge ..."
	/var/config/fsck.sh > /dev/null &
else
	echo "USER FSCK nicht Aktiv"
fi
fi
###### Autonews Start ###########################
if [ -e /var/config/tools/autonews.sh ]; then
	echo "Autonews Aktiv ..."
	/var/config/tools/autonews.sh &
else
	echo "Autonews inaktiv ..."
fi
###### Samba Start ###############################
if [ -e /var/keys/Benutzerdaten/.system/samba ]; then
SAMBA=`cat /var/keys/Benutzerdaten/.system/samba`
  if [ "$SAMBA" = "an" ]; then
	echo "Samba Server Starten ..."
	/usr/sbin/smbd -D -s /etc/samba/smb.conf &
	/usr/sbin/nmbd -D -s /etc/samba/smb.conf &
	echo "FERTIG"
  else
	echo "Samba Deaktiviert..."
  fi
else
echo "Samba Menu einstellungen nicht Aktiv...OFF"
fi
############### OpenVPN Autostart ###############
if [ -e /var/keys/Benutzerdaten/.system/openvpn ]; then
OPENVPN=`cat /var/keys/Benutzerdaten/.system/openvpn`
  if [ "$OPENVPN" = "vpnan" ]; then
	echo "OpenVPN Client Starten ..."
	/sbin/openvpn /openvpn/client.conf &
	echo "FERTIG"
  else
	echo "OpenVPN Autostart Deaktiviert..."
  fi
else
echo "OpenVPN Autostart einstellungen nicht Aktiv...OFF"
fi
############### UPNP Autostart ###############
if [ -e /var/keys/Benutzerdaten/.system/upnp ]; then
UPNP=`cat /var/keys/Benutzerdaten/.system/upnp`
  if [ "$UPNP" = "upnpan" ]; then
	echo "UPNP Client Starten ..."
	/bin/djmount -f /upnp &
	echo "FERTIG"
  else
	echo "UPNP Autostart Deaktiviert..."
  fi
else
echo "UPNP Autostart einstellungen nicht Aktiv...OFF"
fi
####### Bootlogo killen bei Neutrino ######
if [ -e /var/config/subsystem ]; then
	SYSTEM=`cat /var/config/subsystem`
		if [ "$SYSTEM" = "Neutrino" ]; then
			sleep 5
			killall -9 dvbtest
		else
			echo "logo Run to END"
		fi
fi
####### Emu autostart #####################
# !!! Sleep verzoegert den Emu Start und sorgt fuer einen Reibungslosen start sodas das Netzwerk bereit ist !!! # 
sleep 12
# !!! 10 sec verzoegert, wirkt sich nicht auf den algemeinen Start der Box aus da dies nebenbei geschiet !!! #
echo "Emu Autostart ..."
/var/config/emu/autostart.sh &
echo "Emu Autostart ... FERTIG"
####### Ram nach dem Start frisch machen ######
echo "RAM Leeren ..."
/var/config/system/ram_free.sh &
echo "RAM Leeren ... FERTIG"
sleep 2
###### emu Watchdog ######
echo "Emu Watchdog Autostart ..."
/var/config/emu-watchdog.sh &
echo "Emu Watchdog Autostart ... FERTIG"
###### END OF Start Script #######################
