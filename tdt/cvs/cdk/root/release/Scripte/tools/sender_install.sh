echo "Backups NHD2/E2 Installieren"
echo "warten bitte . . . Installiere Daten"
# Senderlisten und Settings Files werden aus /tmp installiert
tar -xzf /tmp/*.tar.gz -C /
echo "Installation abgeschlossen, System Neustarten um Aktuelle Senderlisten/Configs zu verwenden"
exit 0
