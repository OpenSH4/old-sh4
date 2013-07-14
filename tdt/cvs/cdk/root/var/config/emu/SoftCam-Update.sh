#!/bin/sh
#DESCRIPTION=This script will update your image with DNA CCcam Keys
echo "CCcam KeyUpdate by DNA"
echo "erstelle Ordner..."
[ -d /var/keys ] || mkdir -p /var/keys
echo "lade CCcam Keys herunter"
wget http://dark-network.eu/downloads/DNA-Updater/keys/cccam_keys.tar.gz -O /tmp/cccam_keys.tar.gz
wget http://dark-network.eu/downloads/DNA-Updater/keys/Keys_Changelog_info.txt -O /tmp/Keys_Changelog_info.txt
echo "CCcam Keys werden installiert..."
tar -xzf /tmp/cccam_keys.tar.gz -C /
chmod 644 /var/keys/AutoRoll.Key
chmod 644 /var/keys/SoftCam.Key
cp /var/keys/SoftCam.Key /var/keys/oscam.keys
echo "Key-Update erfolgreich abgeschlossen."
echo ""
echo ""
echo ""
echo ""
cat /tmp/Keys_Changelog_info.txt
echo "Loesche Installationsdatei...."
rm /tmp/cccam_keys.tar.gz
rm /tmp/Keys_Changelog_info.txt
sleep 2
