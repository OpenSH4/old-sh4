if [ ! -e /etc/profile ]; then
   echo "erstelle Profile ..."
   cp /etc/profile.bak /etc/profile
fi
####### MAC #######################
if [ -e /var/keys/Benutzerdaten/.system/wol ]; then
MAC=`cat /var/keys/Benutzerdaten/.system/wol`
if [ "$MAC" = "an" ]; then
   echo "MAC Intervall gestoppen ..."
   killall -9 timeping.sh
else
   echo "MAC Intervall Deaktiviert ..."
fi
fi
####### Display Uhr #######################
if [ -e /var/keys/Benutzerdaten/.system/uhr ]; then
UHR=`cat /var/keys/Benutzerdaten/.system/uhr`
if [ "$UHR" = "an" ]; then
   echo "Display Uhr stoppen ..."
   killall -9 time.sh
else
   echo "Display Uhr Deaktiviert ..."
fi
else
   echo "Display Uhr nicht Aktiv ..."
fi
###### Autonews Start ###########################
if [ -e /var/config/tools/autonews.sh ]; then
   echo "Autonews Stoppen ..."
   killall -9 ash
   killall -9 sleep
else
   echo "Autonews inaktiv ..."
fi
###### Samba Start ###############################
if [ -e /var/keys/Benutzerdaten/.system/samba ]; then
SAMBA=`cat /var/keys/Benutzerdaten/.system/samba`
  if [ "$SAMBA" = "an" ]; then
   echo "Samba Server Stoppen ..."
   killall -9 smbd
   killall -9 nmbd
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
   echo "OpenVPN Client Stoppen ..."
   killall -9 openvpn
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
   echo "UPNP Client Stoppen ..."
   killall -9 djmount
   echo "FERTIG"
  else
   echo "UPNP Autostart Deaktiviert..."
  fi
else
echo "UPNP Autostart einstellungen nicht Aktiv...OFF"
fi
####### Emu autostart #####################
echo "Emu Autostart ..."
/var/config/emu/autostart.sh &
echo "Emu Autostart ... FERTIG"
####### Ram nach dem Start frisch machen ######
echo "RAM Leeren ..."
/var/config/system/ram_free.sh &
echo "RAM Leeren ... FERTIG"
sleep 2
###### emu Watchdog ######
echo "Emu Watchdog Stoppen ..."
killall -9 emu-watchdog.sh &
echo "Emu Watchdog Autostart ... FERTIG"
###### END OF Start Script #######################
