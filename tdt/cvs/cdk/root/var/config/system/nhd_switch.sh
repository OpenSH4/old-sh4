echo "setze Switch ON Status"
echo "yes" > /ram/switch
echo "Done"
echo "Beende Enigma2"
pkill enigma2
echo "Done"
echo "NHD2 Start"
echo "Start NHD2" > /dev/vfd
echo Neutrino > /var/config/subsystem; echo switch > /var/config/subswitch
sleep 5
echo "Done"
echo "setze Switch OFF Status"
echo "no" > /ram/switch
echo "Done"

