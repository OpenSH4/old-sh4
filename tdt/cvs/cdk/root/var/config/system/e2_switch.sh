echo "setze Switch ON Status"
echo "yes" > /ram/switch
echo "Done"
echo "Beende NeutrinoHD2"
pkill neutrino 
echo "Done"
echo "Enigma2 Start"
echo "Start Enigma2" > /dev/vfd
echo Enigma2 > /var/config/subsystem; echo switch > /var/config/subswitch
sleep 5
echo "Done"
echo "setze Switch OFF Status"
echo "no" > /ram/switch
echo "Done"
