echo "Backup der Enigma-Senderlisten erstellen"
echo "warten bitte . . . Comprimiere Daten"
echo " | Vorbereitung ..."
SYSTEM=`cat /var/config/subsystem`
# Download Settings File
if [ $SYSTEM = Enigma2 ]; then
	echo "Backup der Enigma2 Senderliste erstellen"
	/bin/tar -czf /Enigma2_System_Ordner/Backups/Senderliste_Backup.E2.tar.gz /etc/enigma2 --exclude=/etc/enigma2/settings
else
	echo "Backup der Neutrino-Einstellungen + Senderliste erstellen"
	/bin/tar -czf /Enigma2_System_Ordner/Backups/Config_Backup.NHD2.tar.gz /var/tuxbox/config/
fi
echo "Backup abgeschlossen, Datei per FTP aus dem /Enigma2_System_Ordner/Backups Ordner kopieren"
exit 0
