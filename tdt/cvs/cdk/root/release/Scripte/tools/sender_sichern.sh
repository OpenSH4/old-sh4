echo "Backup der Senderlisten erstellen"
echo "warten bitte . . . Comprimiere Daten"
/bin/tar czf /Enigma2_System_Ordner/Backups/Senderliste_Backup.E2.tar.gz /etc/enigma2 --exclude=/etc/enigma2/settings
echo "Backup abgeschlossen, Datei per FTP aus dem /Enigma2_System_Ordner/Backups Ordner kopieren"
exit 0
