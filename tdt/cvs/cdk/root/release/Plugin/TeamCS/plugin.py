import os
from Screens.Screen import Screen
from Components.MenuList import MenuList
from Components.ActionMap import ActionMap, NumberActionMap
from Screens.MessageBox import MessageBox
from Plugins.Plugin import PluginDescriptor
from Tools.Directories import fileExists
from Components.Label import Label
from Components.PluginComponent import plugins
from Components.PluginList import *
from Screens.Console import Console
from Screens.ChoiceBox import ChoiceBox
from Components.Input import Input
from Screens.InputBox import InputBox
from enigma import eConsoleAppContainer
from Tools.Directories import resolveFilename, SCOPE_PLUGINS, SCOPE_SKIN_IMAGE
from Tools.LoadPixmap import LoadPixmap
from Components.Pixmap import Pixmap
from Components.Sources.StaticText import StaticText
from Components.Sources.List import List

###########################################################################

class MyMenu(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="TeamCS Menu" >
			<widget name="myMenu" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Emu Menu", "EMU", "EMUMANAGER", "46"))
		list.append(("Addon Manager", "addon", "addonmanager", "46"))
		list.append(("Display Uhr Einstellen", "time", "timer", "46"))
		list.append(("W-Lan Einstellungen", "wlan", "wlansettings", "46"))
		list.append(("Backup, Install Menu", "BACKUP", "BACKUPINSTALL", "46"))
		list.append(("System Information", "SYSTEM", "SYSINFO", "46"))
		list.append(("Tuner Waehlen", "tuner", "tuners", "46"))
		list.append(("Benutzerdaten Einstellen", "benutzerdaten", "setbenutzer", "46"))
		list.append(("WakeOnLan Einstellen", "wol", "woltimer", "46"))
		list.append(("UPNP Media-Server-Client", "upnp", "upnpms", "46"))
		list.append(("OpenVPN Client", "ovpn", "openvpn", "46"))
		list.append(("Samba Menu", "samba", "sambamenu", "46"))
		list.append(("Swap Einrichten", "swap", "swappart", "46"))
		list.append(("CPU Overclocking", "CPUO", "CPUOVER", "46"))
		list.append(("ETH0 MAC Switcher", "MACSWITCH", "eth0mac", "46"))
		list.append(("NeutrinoHD2 Subsystem Switch", "NHD2", "subsystem", "46"))
		list.append((_("Exit"), "exit"))
		
		Screen.__init__(self, session)
		self["myMenu"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["myMenu"].getCurrent()
		if selection is not None:
			if selection[1] == "EMU":
				self.session.open(EMU)

			elif selection[1] == "addon":
				self.session.open(MerlinDownloadBrowser)

			elif selection[1] == "SYSTEM":
				self.session.open(SYSTEM)

			elif selection[1] == "MACSWITCH":
				self.session.open(ETHMAC)

			elif selection[1] == "swap":
				self.session.open(SWAPPART)

			elif selection[1] == "BACKUP":
				self.session.open(BACKUP)

			elif selection[1] == "time":
				self.session.open(TIMESET)
			
			elif selection[1] == "wol":
				self.session.open(WOLSET)
				
			elif selection[1] == "ovpn":
				self.session.open(OPENSET)			

			elif selection[1] == "upnp":
				self.session.open(UPNPSET)
				
			elif selection[1] == "samba":
				self.session.open(SAMBASET)

			elif selection[1] == "benutzerdaten":
				self.session.open(BENUTZER)	

			elif selection[1] == "tuner":
				self.session.open(TUNER)

			elif selection[1] == "CPUO":
				self.session.open(OVERCLOCK)

			elif selection[1] == "NHD2":
				os.system("echo Neutrino > /var/config/subsystem; echo switch > /var/config/subswitch; sync")
				self.session.open(MessageBox,_("NeutrinoHD2 wird beim naechsten Systemstart ausgefuehrt"), MessageBox.TYPE_INFO)

			elif selection[1] == "wlan":
				self.session.open(WLAN)
		
			else:
				print "\n[MyMenu] cancel\n"
				self.close(None)
	
	def prombt(self, com):
		self.session.open(Console,_("Diplay Reset: %s") % (com), ["%s" % com])

	def cancel(self):
		print "\n[MyMenu] cancel\n"
		self.close(None)

###########################################################################

class ETHMAC(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Mac Switch Menu" >
			<widget name="ETHMAC" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Benutze MAC 00:80:E1:12:06:30 -- default", "MAC1", "UMAC1", "46"))
		list.append(("Benutze MAC 00:81:E1:12:06:30", "MAC2", "UMAC2", "46"))
		list.append(("Benutze MAC 00:82:E1:12:06:30", "MAC3", "UMAC3", "46"))
		list.append(("Benutze MAC 00:83:E1:12:06:30", "MAC4", "UMAC4", "46"))
		list.append(("Benutze MAC 00:84:E1:12:06:30", "MAC5", "UMAC5", "46"))

		Screen.__init__(self, session)
		self["ETHMAC"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["ETHMAC"].getCurrent()
		if selection is not None:
			if selection[1] == "MAC1":
				os.system("echo 1 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:80:E1:12:06:30")
				self.session.open(MessageBox,_("Die neu MAC lautet 00:80:E1:12:06:30"), MessageBox.TYPE_INFO)

			elif selection[1] == "MAC2":
				os.system("echo 2 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:81:E1:12:06:30")
				self.session.open(MessageBox,_("Die neu MAC lautet 00:81:E1:12:06:30"), MessageBox.TYPE_INFO)

			elif selection[1] == "MAC3":
				os.system("echo 3 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:82:E1:12:06:30")
				self.session.open(MessageBox,_("Die neu MAC lautet 00:82:E1:12:06:30"), MessageBox.TYPE_INFO)

			elif selection[1] == "MAC4":
				os.system("echo 4 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:83:E1:12:06:30")
				self.session.open(MessageBox,_("Die neu MAC lautet 00:83:E1:12:06:30"), MessageBox.TYPE_INFO)

			elif selection[1] == "MAC5":
				os.system("echo 5 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:84:E1:12:06:30")
				self.session.open(MessageBox,_("Die neu MAC lautet 00:84:E1:12:06:30"), MessageBox.TYPE_INFO)


	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[ETHMAC] cancel\n"
		self.close(None)
		
###########################################################################

class OVERCLOCK(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Overclock Menu" >
			<widget name="OVERCLOCK" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("---------- Boot Overclocking -----------", "", "", "46"))
		list.append(("Aktivieren 266 Mhz -- default", "OVEROFF", "OVERCLOCKOFF", "46"))
		list.append(("Aktivieren 300 Mhz", "300OVERON", "300OVERCLOCKON", "46"))
		list.append(("Aktivieren 333 Mhz", "333OVERON", "333OVERCLOCKON", "46"))
		list.append(("Aktivieren 366 Mhz", "366OVERON", "366OVERCLOCKON", "46"))
		list.append(("Aktivieren 400 Mhz", "400OVERON", "400OVERCLOCKON", "46"))
		list.append(("--------- Dauer Overclocking -----------", "", "", "46"))
		list.append(("Aktivieren 300 Mhz", "300DAUEROVERON", "300daueron", "46"))
		list.append(("Aktivieren 333 Mhz", "333DAUEROVERON", "333daueron", "46"))
		list.append(("Aktivieren 366 Mhz", "366DAUEROVERON", "366daueron", "46"))
		list.append(("Aktivieren 400 Mhz", "400DAUEROVERON", "400daueron", "46"))
		list.append(("Deaktiviert Overclocking", "DAUEROVEROFF", "daueroff", "46"))
		list.append(("----------------------------------------", "", "", "46"))
		list.append(("Overclock Frequence Check", "OCCHECK", "check", "46"))
		list.append(("----------------------------------------", "", "", "46"))
		list.append(("Das Overclocking geschieht auf eigene", "", "", "46"))
		list.append(("Gefahr, jeder muss selber wissen was er", "", "", "46"))
		list.append(("seiner Box Antut, getestet sind diese ", "", "", "46"))
		list.append(("Einstellungen, dennoch kann es sich bei", "", "", "46"))
		list.append(("jeder Box anders Verhalten oder Auswirken !", "", "", "46"))
		
		Screen.__init__(self, session)
		self["OVERCLOCK"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["OVERCLOCK"].getCurrent()
		if selection is not None:
			if selection[1] == "300OVERON":
				os.system("echo 300on > /var/keys/Benutzerdaten/.system/overclock")
				self.session.open(MessageBox,_("Die CPU wird waerend des Booten auf 300 Mhz getacktet"), MessageBox.TYPE_INFO)

			elif selection[1] == "333OVERON":
				os.system("echo 333on > /var/keys/Benutzerdaten/.system/overclock")
				self.session.open(MessageBox,_("Die CPU wird waerend des Booten auf 333 Mhz getacktet"), MessageBox.TYPE_INFO)

			elif selection[1] == "366OVERON":
				os.system("echo 366on > /var/keys/Benutzerdaten/.system/overclock")
				self.session.open(MessageBox,_("Die CPU wird waerend des Booten auf 366 Mhz getacktet"), MessageBox.TYPE_INFO)

			elif selection[1] == "400OVERON":
				os.system("echo 400on > /var/keys/Benutzerdaten/.system/overclock")
				self.session.open(MessageBox,_("Die CPU wird waerend des Booten auf 400 Mhz getacktet"), MessageBox.TYPE_INFO)

			elif selection[1] == "OVEROFF":
				os.system("echo off > /var/keys/Benutzerdaten/.system/overclock; echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv")
				self.session.open(MessageBox,_("Die CPU wird Standart auf 266 Mhz getacktet"), MessageBox.TYPE_INFO)

			elif selection[1] == "300DAUEROVERON":
				os.system("echo 300daueron > /var/keys/Benutzerdaten/.system/overclock; echo 25609 > /proc/cpu_frequ/pll0_ndiv_mdiv")
				self.session.open(MessageBox,_("Aktuelle CPU Freq. auf 300 Mhz getacktet und fest gestellt fuer jeden Boot"), MessageBox.TYPE_INFO)

			elif selection[1] == "333DAUEROVERON":
				os.system("echo 333daueron > /var/keys/Benutzerdaten/.system/overclock; echo 9475 > /proc/cpu_frequ/pll0_ndiv_mdiv")
				self.session.open(MessageBox,_("Aktuelle CPU Freq. auf 333 Mhz getacktet und fest gestellt fuer jeden Boot"), MessageBox.TYPE_INFO)

			elif selection[1] == "366DAUEROVERON":
				os.system("echo 366daueron > /var/keys/Benutzerdaten/.system/overclock; echo 31241 > /proc/cpu_frequ/pll0_ndiv_mdiv")
				self.session.open(MessageBox,_("Aktuelle CPU Freq. auf 366 Mhz getacktet und fest gestellt fuer jeden Boot"), MessageBox.TYPE_INFO)

			elif selection[1] == "400DAUEROVERON":
				os.system("echo 400daueron > /var/keys/Benutzerdaten/.system/overclock; echo 22790 > /proc/cpu_frequ/pll0_ndiv_mdiv")
				self.session.open(MessageBox,_("Aktuelle CPU Freq. auf 400 Mhz getacktet und fest gestellt fuer jeden Boot"), MessageBox.TYPE_INFO)

			elif selection[1] == "DAUEROVEROFF":
				os.system("echo daueroff > /var/keys/Benutzerdaten/.system/overclock; echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv")
				self.session.open(MessageBox,_("Aktuelle CPU Freq. auf 266 Mhz getacktet und fest gestellt fuer jeden Boot"), MessageBox.TYPE_INFO)

			elif selection[1] == "OCCHECK":
				self.prombt("cat /proc/cpu_frequ/pll0_ndiv_mdiv")

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[OVERCLOCK] cancel\n"
		self.close(None)
				
###########################################################################

class SWAPPART(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Swap Menu" >
			<widget name="SWAPPART" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("------------ Swap Aktivieren -------------", "", "", "46"))
		list.append(("Swap Partition Aktivieren -- default", "swapdev", "swapdevan", "46"))
		list.append(("Ramzswap Aktivieren", "ramzswap", "ramzswapan", "46"))
		list.append(("Swapfile auf HDD Aktivieren", "swaphdd", "hddswapan", "46"))
		list.append(("------------ Swap Anlegen -------------", "", "", "46"))
		list.append(("Swapfile auf HDD Erstellen", "swapfileerstellen", "hddswaperstellen", "46"))
		list.append(("Swappartition /dev/sda3 Formatieren", "swapfileerstellensda", "hddswaperstellensda", "46"))
		
		Screen.__init__(self, session)
		self["SWAPPART"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["SWAPPART"].getCurrent()
		if selection is not None:
			if selection[1] == "swapdev":
				os.system("echo swapdev > /var/config/SWAP")
				self.session.open(MessageBox,_("Swap /dev/sda2 Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "ramzswap":
				os.system("echo ramzswap > /var/config/SWAP")
				self.session.open(MessageBox,_("RamZswap Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "swaphdd":
				os.system("echo swapfile > /var/config/SWAP")
				self.session.open(MessageBox,_("Swapfile auf HDD Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "swapfileerstellen":
				self.prombt("/var/config/swap/swapfile.sh; echo swapfile > /var/config/SWAP")

			elif selection[1] == "swapfileerstellensda":
				self.prombt("/var/config/swap/swapdev.sh; echo swapdev > /var/config/SWAP")

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[SWAPPART] cancel\n"
		self.close(None)
				
###########################################################################

class SAMBASET(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Samba Menu" >
			<widget name="SAMBASET" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Samba AN", "SAMBAAN", "an", "46"))
		list.append(("Samba AUS", "SAMBAAUS", "aus", "46"))
		
		Screen.__init__(self, session)
		self["SAMBASET"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["SAMBASET"].getCurrent()
		if selection is not None:
			if selection[1] == "SAMBAAN":
				os.system("echo an > /var/keys/Benutzerdaten/.system/samba")
				self.session.open(MessageBox,_("Samba Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "SAMBAAUS":
				os.system("echo aus > /var/keys/Benutzerdaten/.system/samba")
				self.session.open(MessageBox,_("Samba Ausgeschalten"), MessageBox.TYPE_INFO)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[SAMBASET] cancel\n"
		self.close(None)
		
		
################################# OPENVPN ################################

class OPENSET(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="OPENVPN Menu" >
			<widget name="OPENSET" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("OpenVPN Client Aktivieren", "VPNAN", "an", "46"))
		list.append(("OpenVPN Client Deaktivieren", "VPNAUS", "aus", "46"))
		list.append(("OpenVPN Client Autostart Aktivieren", "VPNAUTOAN", "vpnaan", "46"))
		list.append(("OpenVPN Client Autostart Deaktivieren", "VPNAUTOAUS", "vpnaaus", "46"))
		
		Screen.__init__(self, session)
		self["OPENSET"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["OPENSET"].getCurrent()
		if selection is not None:
			if selection[1] == "VPNAN":
				os.system("/sbin/openvpn /openvpn/client.conf &")
				self.session.open(MessageBox,_("OpenVPN Client Gestartet,wenn nicht alle Configs im openvpn Ordner erstellt sind Beendet sich der Client von selbst wieder"), MessageBox.TYPE_INFO)

			elif selection[1] == "VPNAUS":
				os.system("killall -9 openvpn")
				self.session.open(MessageBox,_("OpenVPN Client Gestoppt"), MessageBox.TYPE_INFO)

			elif selection[1] == "VPNAUTOAN":
				os.system("echo vpnan > /var/keys/Benutzerdaten/.system/openvpn")
				self.session.open(MessageBox,_("OpenVPN Client Autostart Aktiviert"), MessageBox.TYPE_INFO)
				
			elif selection[1] == "VPNAUTOAUS":
				os.system("echo vpnaus > /var/keys/Benutzerdaten/.system/openvpn")
				self.session.open(MessageBox,_("OpenVPN Client Autostart Deaktiviert"), MessageBox.TYPE_INFO)


			else:
				print "\n[OPENSET] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[OPENSET] cancel\n"
		self.close(None)
		
################################# UPNP ################################

class UPNPSET(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="UPNP Menu" >
			<widget name="UPNPSET" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("UPNP Client Aktivieren", "UPNPAN", "an", "46"))
		list.append(("UPNP Client Deaktivieren", "UPNPAUS", "aus", "46"))
		list.append(("UPNP Client Autostart Aktivieren", "UPNPAUTOAN", "upnpaan", "46"))
		list.append(("UPNP Client Autostart Deaktivieren", "UPNPAUTOAUS", "upnpaaus", "46"))
		
		Screen.__init__(self, session)
		self["UPNPSET"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["UPNPSET"].getCurrent()
		if selection is not None:
			if selection[1] == "UPNPAN":
				os.system("/bin/djmount -f /upnp &")
				self.session.open(MessageBox,_("UPNP Client Gestartet, Daten koennen in upnp Ordner abgerufen werden"), MessageBox.TYPE_INFO)

			elif selection[1] == "UPNPAUS":
				os.system("killall -9 djmount")
				self.session.open(MessageBox,_("UPNP Client Gestoppt"), MessageBox.TYPE_INFO)

			elif selection[1] == "UPNPAUTOAN":
				os.system("echo upnpan > /var/keys/Benutzerdaten/.system/upnp")
				self.session.open(MessageBox,_("UPNP Client Autostart Aktiviert"), MessageBox.TYPE_INFO)
				
			elif selection[1] == "UPNPAUTOAUS":
				os.system("echo upnpaus > /var/keys/Benutzerdaten/.system/upnp")
				self.session.open(MessageBox,_("UPNP Client Autostart Deaktiviert"), MessageBox.TYPE_INFO)


			else:
				print "\n[UPNPSET] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[UPNPSET] cancel\n"
		self.close(None)
		
################################# WOL ################################

class WOLSET(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="WakeOnLan Menu" >
			<widget name="WOLSET" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("WakeOnLan AN", "WOLAN", "an", "46"))
		list.append(("WakeOnLan AUS", "WOLAUS", "aus", "46"))
		list.append(("MAC Adresse", "mac", "macaddresse", "46"))
		list.append(("Port", "WOLMACPORT", "macport", "46"))
		list.append(("Zeit in Sec fuer wiederholung", "WOLTIME", "mactime", "46"))
		
		Screen.__init__(self, session)
		self["WOLSET"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["WOLSET"].getCurrent()
		if selection is not None:
			if selection[1] == "WOLAN":
				os.system("echo an > /var/keys/Benutzerdaten/.system/wol")
				self.session.open(MessageBox,_("WOL Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "WOLAUS":
				os.system("echo aus > /var/keys/Benutzerdaten/.system/wol")
				self.session.open(MessageBox,_("WOL Ausgeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "mac":
				self.session.open(MAC)
				
			elif selection[1] == "WOLMACPORT":
				self.session.open(WOLPORT)
				
			elif selection[1] == "WOLTIME":
				self.session.open(WOLTIMESET)

			else:
				print "\n[BENUTZER] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[WOLSET] cancel\n"
		self.close(None)
		
############################ MWOLPORT #################################

class WOLTIMESET(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="WOL TIME" >
			<widget name="WOLTIMESET" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["WOLTIMESET"] = Label(_("Zeit eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.TIMEimput,
			"cancel": self.cancel
		}, -1)

	def TIMEimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte die Zeit in Sec eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Zeit Einstellung: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.system/MACTIME; echo Zeit eingestellt" % word])

	def cancel(self):
		print "\n[WOLTIMESET] cancel\n"
		self.close(None)
		
############################ MWOLPORT #################################

class WOLPORT(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="WOL PORT" >
			<widget name="WOLPORT" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["WOLPORT"] = Label(_("Port eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.PORTimput,
			"cancel": self.cancel
		}, -1)

	def PORTimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte den Port eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("MAC Adresse: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.system/MACPORT; echo Port eingestellt" % word])

	def cancel(self):
		print "\n[WOLPORT] cancel\n"
		self.close(None)
		
############################ MAC#################################

class MAC(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="MAC Adresse" >
			<widget name="MAC" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["MAC"] = Label(_("MAC Adresse eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.MACimput,
			"cancel": self.cancel
		}, -1)

	def MACimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte die MAC Adresse eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("MAC Adresse: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.system/MAC; echo MAC eingestellt" % word])

	def cancel(self):
		print "\n[MAC] cancel\n"
		self.close(None)

################################# TIMESET ################################
class TIMESET(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Uhr Einstellung" >
			<widget name="TIMESET" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Display Reset", "display", "displayreset", "46"))
		list.append(("Display Uhr Aktivieren", "an", "an1", "46"))
		list.append(("Display Uhr Deaktivieren", "aus", "aus1", "46"))
		list.append(("Sommerzeit Einstellen", "sommer", "sommer1", "46"))
		list.append(("Winterzeit Einstellen", "winter", "winter1", "46"))
		list.append(("Display Auschalt Anzeige", "ausmachen", "boxoff", "46"))
		
		Screen.__init__(self, session)
		self["TIMESET"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["TIMESET"].getCurrent()
		if selection is not None:
			if selection[1] == "an":
				os.system("echo an > /var/keys/Benutzerdaten/.system/uhr")
				self.session.open(MessageBox,_("Display Uhr Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "aus":
				os.system("echo aus > /var/keys/Benutzerdaten/.system/uhr")
				self.session.open(MessageBox,_("Display Uhr Ausgeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "sommer":
				os.system("echo 2 > /var/keys/Benutzerdaten/.system/timezone")
				self.session.open(MessageBox,_("Sommerzeit Eingestellt"), MessageBox.TYPE_INFO)
				
			elif selection[1] == "display":
				os.system("/var/config/tools/display.sh")
				self.session.open(MessageBox,_("Display Reset durchgefuehrt"), MessageBox.TYPE_INFO)

			elif selection[1] == "winter":
				os.system("echo 1 > /var/keys/Benutzerdaten/.system/timezone")
				self.session.open(MessageBox,_("Winterzeit Eingestellt"), MessageBox.TYPE_INFO)

			elif selection[1] == "ausmachen":
				self.session.open(BOXOFF)
		
			else:
				print "\n[TIMESET] cancel\n"
				self.close(None)

		
	def cancel(self):
		print "\n[TIMESET] cancel\n"
		self.close(None)

###########################################################################
################################# TIMESET ################################
class BOXOFF(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Uhr Einstellung" >
			<widget name="BOXOFF" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Anzeige von Turn OFF", "turnoff", "turnoff", "46"))
		list.append(("Anzeige von Turno OFF und Datum", "offdate", "offdate1", "46"))
		list.append(("Anzeige von Datum", "date", "date1", "46"))
		list.append(("Display Deaktivieren", "aus", "aus1", "46"))
		
		Screen.__init__(self, session)
		self["BOXOFF"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["BOXOFF"].getCurrent()
		if selection is not None:
			if selection[1] == "turnoff":
				os.system("echo OFF > /var/config/mode")
				self.session.open(MessageBox,_("Ist die Box Runtergefahren wird TURN OFF angezeigt"), MessageBox.TYPE_INFO)

			elif selection[1] == "offdate":
				os.system("echo DATEPLUS > /var/config/mode")
				self.session.open(MessageBox,_("Ist die Box Runtergefahren wird TURN OFF und Datum in Wechselschrift angezeigt"), MessageBox.TYPE_INFO)

			elif selection[1] == "date":
				os.system("echo DATE > /var/config/mode")
				self.session.open(MessageBox,_("Ist die Box Runtergefahren wird das Datum angezeigt"), MessageBox.TYPE_INFO)
				
			elif selection[1] == "aus":
				os.system("echo BLANK > /var/config/mode")
				self.session.open(MessageBox,_("Ist die Box Runtergefahren wird das Display Abgeschalten"), MessageBox.TYPE_INFO)

		
			else:
				print "\n[BOXOFF] cancel\n"
				self.close(None)

		
	def cancel(self):
		print "\n[BOXOFF] cancel\n"
		self.close(None)

###########################################################################
class EMU(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Emu Menu" >
			<widget name="EMU" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Stoppt laufende Emus", "stop", "emustop", "46"))
		list.append(("------------- Single Emu ------------", "", "", "46"))
		list.append(("Start oder Restart Mg-Camd", "mgstart", "mgcamd", "46"))
		list.append(("Start oder Restart OS-Cam", "oscam", "oscamd", "46"))
		list.append(("Start oder Restart Vizcam", "vizcam", "vizcamd", "46"))
		list.append(("Start oder Restart MBox", "mbox", "mbox1", "46"))
		list.append(("Start oder Restart Incubus", "incubus", "incubus1", "46"))
		list.append(("Start oder Restart Camd3", "camd3", "camd31", "46"))
		list.append(("-------------- Dual Emu -------------", "", "", "46"))
		list.append(("Start Dual Emu", "dual", "dualmode", "46"))
		list.append(("------------- Emu Watchdog ----------", "", "", "46"))
		list.append(("Watchdog Einschalten", "watchon", "watchon1", "46"))
		list.append(("Watchdog Ausschalten", "watchoff", "watchoff1", "46"))
		
		Screen.__init__(self, session)
		self["EMU"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["EMU"].getCurrent()
		if selection is not None:
			if selection[1] == "stop":
				self.prombt("/var/config/emu/stop-emu.sh")

			elif selection[1] == "mgstart":
				self.prombt("/var/config/emu/start-mgcamd.sh; echo 1 > /var/emu/emudual")	

			elif selection[1] == "oscam":
				self.prombt("/var/config/emu/start-oscam.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "vizcam":
				self.prombt("/var/config/emu/start-vizcam.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "mbox":
				self.prombt("/var/config/emu/start-mbox.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "incubus":
				self.prombt("/var/config/emu/start-incubus.sh; echo 1 > /var/emu/emudual.sh")

			elif selection[1] == "camd3":
				self.prombt("/var/config/emu/start-camd3.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "dual":
				self.session.open(EMUDUAL)

			elif selection[1] == "watchon":
				os.system("echo on > /var/config/emu-watchdog; /var/config/emu/emu-watchdog.sh &")
				self.session.open(MessageBox,_("Emu Watchdog Aktiviert"), MessageBox.TYPE_INFO)

			elif selection[1] == "watchoff":
				os.system("echo off > /var/config/emu-watchdog; killall -9 emu-watchdog.sh")
				self.session.open(MessageBox,_("Emu Watchdog Deaktiviert"), MessageBox.TYPE_INFO)

			else:
				print "\n[EMU] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("EMU Menu: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[EMU] cancel\n"
		self.close(None)

###########################################################################
class EMUDUAL(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Emu Dual Menu" >
			<widget name="EMUDUAL" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Stoppt laufenden Emu", "stop", "emustop", "46"))
		list.append(("Start oder Restart Mg-Camd", "mgstart2", "mgcamd", "46"))
		list.append(("Start oder Restart MBox", "mbox2", "mbox1", "46"))
		list.append(("Start oder Restart Incubus", "incubus2", "incubus1", "46"))
		list.append(("Start oder Restart Camd3", "camd32", "camd31", "46"))
		
		Screen.__init__(self, session)
		self["EMUDUAL"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["EMUDUAL"].getCurrent()
		if selection is not None:
			if selection[1] == "stop":
				self.prombt("/var/config/emu/stop-emu.sh")

			elif selection[1] == "mgstart2":
				self.prombt("/var/config/emu/start-mgcamd2.sh; echo 2 > /var/emu/emudual")	

			elif selection[1] == "mbox2":
				self.prombt("/var/config/emu/start-mbox2.sh; echo 2 > /var/emu/emudual")

			elif selection[1] == "incubus2":
				self.prombt("/var/config/emu/start-incubus2.sh; echo 2 > /var/emu/emudual.sh")

			elif selection[1] == "camd32":
				self.prombt("/var/config/emu/start-camd32.sh; echo 2 > /var/emu/emudual")


			else:
				print "\n[EMUDUAL] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("EMU Dual Menu: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[EMUDUAL] cancel\n"
		self.close(None)

###########################################################################

class SYSTEM(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="System Infos" >
			<widget name="SYSTEM" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Netzwerk Infos", "netstat", "com_one", "46"))
		list.append(("Geladen Module Anzeigen", "lsmod", "runlsmod", "46"))
		list.append(("Freier Speicher", "free", "runfree", "46"))
		list.append(("Online Update", "ONLINE", "UPDATE", "46"))
		list.append(("Image Version Infomation", "IMG", "IMGVER", "46"))
		list.append(("Letztes FSCK Log Anzeigen", "FSCK", "LOG", "46"))
		
		Screen.__init__(self, session)
		self["SYSTEM"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["SYSTEM"].getCurrent()
		
		if selection is not None:
			if selection[1] == "netstat":
				self.prombt("/bin/netstat")
					
			elif selection[1] == "lsmod":
				self.prombt("/sbin/lsmod")

			elif selection[1] == "free":
				self.prombt("free")

			elif selection[1] == "ONLINE":
				self.prombt("/var/config/updatecheck.sh")
				
			elif selection[1] == "IMG":
				self.prombt("/var/config/sysversion.sh")

			elif selection[1] == "FSCK":
				self.prombt("/var/config/system/fsck.sh")
		
			else:
				print "\n[SYSTEM] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("SYS INFO: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[SYSTEM] cancel\n"
		self.close(None)

###########################################################################

class BACKUP(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="BackUp Menu" >
			<widget name="BACKUP" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("System Full Backup erstellen", "backupsys", "sback", "46"))
		list.append(("System Install Backup erstellen", "backupinstallsys", "sback", "46"))
		list.append(("Kanal-listen Sichern", "ksave", "save", "46"))
		list.append(("Kanal-listen Installieren", "kinstall", "install", "46"))
		
		Screen.__init__(self, session)
		self["BACKUP"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["BACKUP"].getCurrent()
		if selection is not None:
			if selection[1] == "backupsys":
				self.session.open(SYSBACKUP)

			if selection[1] == "backupinstallsys":
				self.session.open(SYSINSTALLBACKUP)

			elif selection[1] == "ksave":
				self.prombt("/var/config/tools/sender_sichern.sh")	

			elif selection[1] == "kinstall":
				self.prombt("/var/config/tools/sender_install.sh")
		
			else:
				print "\n[BACKUP] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("BackUp Menu: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[BACKUP] cancel\n"
		self.close(None)

###########################################################################

class TUNER(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Tuner Menu" >
			<widget name="TUNER" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("------ VIP1 Tuner Treiber ---------", "", "", "46"))
		list.append(("ST-Tuner Opti,VIP1,VIP2", "tuner", "tunervip1", "46"))
		list.append(("RB-Tuner Opti,VIP1", "tuner2", "tunervip", "46"))
		list.append(("VIP1 Kabel Tuner", "tuner1kabel", "tunervip1kabel", "46"))
		list.append(("VIP1 DVB-T Tuner", "tuner1dvbt", "tunervipdvbt", "46"))
		list.append(("------ VIP1v2 Tuner Treiber ---------", "", "", "46"))
		list.append(("Sharp Tuner VIP1v2", "tunervip1v2", "tunervip1v2vip2", "46"))
		list.append(("LG Kabel Tuner VIP1v2", "tunervip1v2kabel", "tunervip1v2kabel", "46"))
		list.append(("Sharp DVB-T Tuner VIP1v2", "tunervip1v2dvbt", "tunervip1v2dvbt", "46"))
		list.append(("------ VIP2 Tuner Treiber ---------", "", "", "46"))
		list.append(("Sharp Tuner VIP2", "tunervip2", "tunervip2vip2", "46"))
		list.append(("Sharp DVB-S2 und Kabel LG VIP2", "tuners2lg", "tuners2lgvip2", "46"))
		list.append(("2x Kabel LG VIP2", "tuner2xlg", "tuner2xlgvip2", "46"))
		list.append(("Kabel LG und DVB-T VIP2", "tunerlgdvbt", "tunerlgdvbtvip2", "46"))
		list.append(("Sharp DVB-S2 und DVB-T VIP2", "tunerdvbs2dvbt", "tunerdvbs2dvbtvip2", "46"))

		
		Screen.__init__(self, session)
		self["TUNER"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["TUNER"].getCurrent()
		if selection is not None:
			if selection[1] == "tuner":
				os.system("echo vip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("OPTI VIP ST-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner2":
				os.system("echo rbvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("OPTI VIP RB-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner1kabel":
				os.system("echo vip1kabel > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("VIP1 LG Kabel-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner1dvbt":
				os.system("echo vip1dvbt > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("VIP1 DVB-T-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuners2lg":
				os.system("echo s2lgvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp DVB-S2 LG DVB-C Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner2xlg":
				os.system("echo 2xlgvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("2x DVB-C LG Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunerlgdvbt":
				os.system("echo lgdvbtvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("LG DVB-C und DVB-T Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunerdvbs2dvbt":
				os.system("echo dvbs2dvbt > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp DVB-S2 und DVB-T Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip1v2":
				os.system("echo vip1v2 > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp VIP1v2 Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip1v2kabel":
				os.system("echo vip1v2kabel > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("LG VIP1v2 Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip1v2dvbt":
				os.system("echo vip1v2dvbt > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp DVB-T VIP1v2 Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip2":
				os.system("echo vip2 > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("VIP2 Sharp Tuner gesetzt"), MessageBox.TYPE_INFO)

			else:
				print "\n[TUNER] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[TUNER] cancel\n"
		self.close(None)

###########################################################################

class BENUTZER(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Benutzerdaten Menu" >
			<widget name="BENUTZER" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("------- CCcam Client ---------", "", "", "46"))
		list.append(("Benutzername eingeben", "benutzername", "name", "46"))
		list.append(("Passwort eingeben", "password", "pass", "46"))
		list.append(("IP oder Dyndns eingeben", "dyndns", "dyn", "46"))
		list.append(("CCcam Port", "cccam", "ccc", "46"))
		list.append(("------- Newcamd Client ---------", "", "", "46"))
		list.append(("Benutzername eingeben", "benutzername", "name", "46"))
		list.append(("Passwort eingeben", "password", "pass", "46"))
		list.append(("IP oder Dyndns eingeben", "dyndns", "dyn", "46"))
		list.append(("MG-Camd Port1", "mgport1", "mg1", "46"))
		list.append(("MG-Camd Port2", "mgport2", "mg2", "46"))
		list.append(("-------- Camd3 Client ----------", "", "", "46"))
		list.append(("Benutzername eingeben", "benutzername", "name", "46"))
		list.append(("Passwort eingeben", "password", "pass", "46"))
		list.append(("IP oder Dyndns eingeben", "dyndns", "dyn", "46"))
		list.append(("Camd3 Port", "camd3", "cam", "46"))
		list.append(("--- Generelle Einstellungen ----", "", "", "46"))
		list.append(("Client Protocol", "server", "serv", "46"))
		list.append(("Emu Config Daten erstellen", "emudaten", "emuconf", "46"))
		list.append(("Fernbedienung waehlen", "fbw", "fernb", "46"))
		
		Screen.__init__(self, session)
		self["BENUTZER"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["BENUTZER"].getCurrent()
		if selection is not None:
			if selection[1] == "benutzername":
				self.session.open(USER)

			elif selection[1] == "password":
				self.session.open(PASS)

			elif selection[1] == "dyndns":
				self.session.open(DYN)

			elif selection[1] == "server":
				self.session.open(SERVER)

			elif selection[1] == "cccam":
				self.session.open(CCPORT)

			elif selection[1] == "mgport1":
				self.session.open(MGPORT)

			elif selection[1] == "mgport2":
				self.session.open(MGPORT1)

			elif selection[1] == "camd3":
				self.session.open(CAMD3)

			elif selection[1] == "emudaten":
				self.prombt("/var/config/tools/Benutzerdaten.sh")

			elif selection[1] == "fbw":
				self.session.open(FERNB)


			else:
				print "\n[BENUTZER] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[BENUTZER] cancel\n"
		self.close(None)

###########################################################################
class FERNB(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Fernbedienung Menu" >
			<widget name="FERNB" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("ArgusVIP neue FB Rotes Blinken", "ArgusVIPneu", "vipneu", "46"))
		list.append(("ArgusVIP neue FB Gruenes Blinken", "ArgusVIPneugruen", "vipneugruen", "46"))
		list.append(("ArgusVIP alte FB Rotes Blinken", "ArgusVIPalt", "vipalt", "46"))
		list.append(("ArgusVIP alte FB Gruenes Blinken", "ArgusVIPaltgruen", "vipaltgruen", "46"))
		list.append(("Opticum FB", "Opticum", "opti", "46"))
		list.append(("Pingolux FB", "Pingolux", "pingo", "46"))
		list.append(("System Neustart", "neustart", "neu", "46"))
		
		Screen.__init__(self, session)
		self["FERNB"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["FERNB"].getCurrent()
		if selection is not None:
			if selection[1] == "ArgusVIPalt":
				os.system("cp /etc/lircd_alt.conf /etc/lircd.conf; echo alt > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB1.xml /usr/local/share/enigma2/keymap.xml; echo vip1 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP alt Mode Rot"), MessageBox.TYPE_INFO)

			elif selection[1] == "ArgusVIPaltgruen":
				os.system("cp /etc/lircd_alt_gruen.conf /etc/lircd.conf; echo alt > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB1.xml /usr/local/share/enigma2/keymap.xml; echo vip1 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP alt Mode Gruen"), MessageBox.TYPE_INFO)

			elif selection[1] == "ArgusVIPneu":
				os.system("cp /etc/lircd_neu.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo vip2 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP neu Mode Rot"), MessageBox.TYPE_INFO)

			elif selection[1] == "ArgusVIPneugruen":
				os.system("cp /etc/lircd_neu_gruen.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo vip2 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP neu Mode Gruen"), MessageBox.TYPE_INFO)

			elif selection[1] == "Opticum":
				os.system("cp /etc/lircd_opti.conf /etc/lircd.conf; echo opti > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_Opti.xml /usr/local/share/enigma2/keymap.xml; echo opti > /var/config/boxtype")
				self.session.open(MessageBox,_("FB Opticum"), MessageBox.TYPE_INFO)

			elif selection[1] == "Pingolux":
				os.system("cp /etc/lircd_pingolux.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_Opti.xml /usr/local/share/enigma2/keymap.xml; echo Pingolux > /var/config/boxtype")
				self.session.open(MessageBox,_("FB Pingolux gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "neustart":
				os.system("/var/config/shutdown/reboot.sh &")

			else:
				print "\n[FERNB] cancel\n"
				self.close(None)
		
	def cancel(self):
		print "\n[FERNB] cancel\n"
		self.close(None)
############################ Benutzername #################################

class USER(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="Benutzername Setzen" >
			<widget name="USER" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["USER"] = Label(_("Wollen Sie einen Benutzer eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.BENUTZERNAMEimput,
			"cancel": self.cancel
		}, -1)

	def BENUTZERNAMEimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte geben Sie den Benutzernamen ein!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze User: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/user; echo User gesetzt" % word])

	def cancel(self):
		print "\n[USER] cancel\n"
		self.close(None)

############################ Password #################################

class PASS(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="Password Setzen" >
			<widget name="PASS" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["PASS"] = Label(_("Wollen Sie ein Passwort eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.PASSWORDimput,
			"cancel": self.cancel
		}, -1)

	def PASSWORDimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte geben Sie das Passwort ein!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze Password: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/pass; echo Password gesetzt" % word])

	def cancel(self):
		print "\n[PASS] cancel\n"
		self.close(None)

############################ Password #################################

class DYN(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="IP DNS Setzen" >
			<widget name="DYN" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["DYN"] = Label(_("IP, DYNDNS eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.DYNimput,
			"cancel": self.cancel
		}, -1)

	def DYNimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte IP, DYNDNS eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze IP DYN: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/dyndns; echo IP dyndns gesetzt" % word])

	def cancel(self):
		print "\n[DYN] cancel\n"
		self.close(None)

############################ Server #################################

class SERVER(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Client Menu" >
			<widget name="SERVER" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("CCcam Client Aktivieren", "CCCAM", "", "46"))
		list.append(("NewCamd Client Aktivieren", "NEWCAMD", "name", "46"))
		
		Screen.__init__(self, session)
		self["SERVER"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["SERVER"].getCurrent()
		if selection is not None:
			if selection[1] == "NEWCAMD":
				os.system("echo mgcamd > /var/keys/Benutzerdaten/.emu/mgcamd_oder_cccam")
				self.session.open(MessageBox,_("CCcam wurde als Client definiert"), MessageBox.TYPE_INFO)

			elif selection[1] == "CCCAM":
				os.system("echo cccam > /var/keys/Benutzerdaten/.emu/mgcamd_oder_cccam")
				self.session.open(MessageBox,_("Newcamd wurde als Client definiert"), MessageBox.TYPE_INFO)


			else:
				print "\n[SERVER] cancel\n"
				self.close(None)

	def cancel(self):
		print "\n[SERVER] cancel\n"
		self.close(None)

############################ cccam port #################################

class CCPORT(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="CCcam Port Setzen" >
			<widget name="CCPORT" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["CCPORT"] = Label(_("Wollen Sie den CCcam Port eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.CCPORTimput,
			"cancel": self.cancel
		}, -1)

	def CCPORTimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Port eingeben !"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze CCcam Port: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/portcccam; echo CCcam Port gesetzt" % word])

	def cancel(self):
		print "\n[CCPORT] cancel\n"
		self.close(None)

############################ MG-Camd port1 #################################

class MGPORT(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="MG-Camd Port1 Setzen" >
			<widget name="MGPORT" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["MGPORT"] = Label(_("Wollen Sie einen MG-Camd Port eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.MGPORTimput,
			"cancel": self.cancel
		}, -1)

	def MGPORTimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Port eingeben !"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze Port: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/portnewcamd1; echo Newcamd Port gesetzt" % word])

	def cancel(self):
		print "\n[MGPORT] cancel\n"
		self.close(None)

############################ MG-Camd port2 #################################

class MGPORT1(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="MG-Camd Port2 Setzen" >
			<widget name="MGPORT1" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["MGPORT1"] = Label(_("Wollen Sie einen MG-Camd Port eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.MGPORT1imput,
			"cancel": self.cancel
		}, -1)

	def MGPORT1imput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Port eingeben !"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze Port: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/portnewcamd2; echo Newcamd Port2 gesetzt" % word])

	def cancel(self):
		print "\n[MGPORT1] cancel\n"
		self.close(None)

############################ Camd3 port #################################

class CAMD3(Screen):
	skin = """
		<screen position="center,center" size="460,150" title="Camd3 Port Setzen" >
			<widget name="CAMD3" position="10,60" size="200,40" font="Regular;20"/>
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)

		self["CAMD3"] = Label(_("Wollen Sie einen Camd3 Port eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.CAMD3imput,
			"cancel": self.cancel
		}, -1)

	def CAMD3imput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Port eingeben !"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Setze Port: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.emu/camd3; echo Camd3 Port gesetzt" % word])

	def cancel(self):
		print "\n[CAMD3] cancel\n"
		self.close(None)

#################### W-Lan ########################################

class WLAN(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="W-Lan Menu" >
			<widget name="WLAN" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("W-Lan 8192cu.ko Treiber Modul", "1", "11", "46"))
		list.append(("W-Lan 8712u.ko Treiber Modul", "2", "22", "46"))
		list.append(("W-Lan rt2870sta.ko Treiber Modul", "3", "33", "46"))
		list.append(("W-Lan rt3070sta.ko Treiber Modul", "4", "44", "46"))
		list.append(("W-Lan rt5370sta.ko Treiber Modul", "5", "55", "46"))
		list.append(("W-Lan rt73.ko Treiber Modul", "6", "66", "46"))
		list.append(("W-Lan zydas.ko Treiber Modul", "7", "77", "46"))
		list.append(("W-Lan Deaktivieren", "8", "88", "46"))

		
		Screen.__init__(self, session)
		self["WLAN"] = MenuList(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["WLAN"].getCurrent()
		if selection is not None:
			if selection[1] == "1":
				os.system("echo 1 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul 8192cu.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "2":
				os.system("echo 2 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul 8712u.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "3":
				os.system("echo 3 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul rt2870sta.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "4":
				os.system("echo 4 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul rt3070sta.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "5":
				os.system("echo 5 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul rt5370sta.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "6":
				os.system("echo 6 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul rt73.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)
				
			elif selection[1] == "7":
				os.system("echo 7 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul zydas.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "8":
				os.system("echo 0 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Treiber Deaktiviert, Neustart erforderlich"), MessageBox.TYPE_INFO)
				
			else:
				print "\n[WLAN] cancel\n"
				self.close(None)

	
	def cancel(self):
		print "\n[WLAN] cancel\n"
		self.close(None)
#################### Addon Manager ################################

def AddOnCategoryComponent(name, png):
	res = [ name ]
	
	res.append(MultiContentEntryText(pos=(140, 5), size=(300, 25), font=0, text=name))
	res.append(MultiContentEntryPixmapAlphaTest(pos=(10, 0), size=(100, 50), png = png))
	
	return res


def AddOnDownloadComponent(plugin, name):
	res = [ plugin ]
	
	res.append(MultiContentEntryText(pos=(140, 5), size=(300, 25), font=0, text=name))
	res.append(MultiContentEntryText(pos=(140, 26), size=(450, 17), font=1, text=plugin.description))

	if plugin.icon is None:
		png = LoadPixmap(resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/icons/plugin.png"))
	else:
		png = plugin.icon

	res.append(MultiContentEntryPixmapAlphaTest(pos=(10, 0), size=(100, 50), png = png))

	if plugin.statusicon is None:
		png1 = LoadPixmap(resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/icons/plugin.png"))
	else:
		png1 = plugin.statusicon

	res.append(MultiContentEntryPixmapAlphaTest(pos=(120, 17), size=(12, 12), png = png1))
	
	return res

class AddOnDescriptor:
	def __init__(self, name = "", what = "", description = "", status = 0, version = "", icon = None, statusicon = None):
		self.name = name
		self.what = what
		self.description = description
		self.status = status
		self.version = version
		if icon is None:
			self.icon = None
		else:
			self.icon = icon
		
		if statusicon is None:
			self.statusicon = None
		else:
			self.statusicon = statusicon

class AddOn:
	def __init__(self, name = "", version = "", description = "", status = 0):
		self.name = name
		self.version = version
		self.description = description
		self.status = status

class MerlinDownloadBrowser(Screen):

	skin = """
		<screen name="Addon Manager" position="center,center" size="560,420" title="Addon Manager">
			<widget name="text" position="0,0" zPosition="1" size="560,430" font="Regular;20" halign="center" valign="center" />
			<widget name="list" position="10,10" zPosition="2" size="540,405" scrollbarMode="showOnDemand" />
		</screen>"""
		

	def __init__(self, session, args = None):
		Screen.__init__(self, session)
		
		self.container = eConsoleAppContainer()
		self.container.appClosed.append(self.runFinished)
		self.container.dataAvail.append(self.dataAvail)
		self.onLayoutFinish.append(self.startRun)
		self.onShown.append(self.setWindowTitle)
		
		self.list = []
		self["list"] = PluginList(self.list)
		self.pluginlist = []
		self.expanded = []
		self.addoninstalled = []
		self.found = 0
		
		self["text"] = Label(_("Downloading Addon Information. Bitte Warten..."))
		
		self.run = 0

		self.remainingdata = ""

		self["actions"] = ActionMap(["WizardActions"], 
		{
			"ok": self.go,
			"back": self.close,
		})

	def go(self):
		sel = self["list"].l.getCurrentSelection()

		if sel is None:
			return

		if type(sel[0]) is str: # category
			if sel[0] in self.expanded:
				self.expanded.remove(sel[0])
			else:
				self.expanded.append(sel[0])
			self.updateList()
		else:
			if sel[0].status == 0:
				self.session.openWithCallback(self.runInstall, MessageBox, _("Moechtest du folgendes \nAddon Downloaden\n \"%s\"?") % sel[0].name)
			elif sel[0].status == 1:
				self.session.openWithCallback(self.runInstall, MessageBox, _("Moechtest du folgendes \nAddon Loeschen\n \"%s\"?") % sel[0].name)
			elif sel[0].status == 2:
				self.session.openWithCallback(self.runDeleteUpdateCallBack, DialogUpdateDelete, _("Das Addon \"%s\" ist bereits Installiert.\nWas moechten sie nun tun?") % sel[0].name)

	def runInstall(self, val):
		if val:
			if self["list"].l.getCurrentSelection()[0].status != 1:
				self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg install " + self["list"].l.getCurrentSelection()[0].name])
			else:
				self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg remove " + self["list"].l.getCurrentSelection()[0].name])
	
	def runDeleteUpdateCallBack(self, answer):
		print "answer:", answer
		if answer == 1:
			self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg install " + self["list"].l.getCurrentSelection()[0].name])
		elif answer == 0:
			self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg remove " + self["list"].l.getCurrentSelection()[0].name])


	def setWindowTitle(self):
		self.setTitle(_("AddOn Browser"))

	def startRun(self):
		print "startRun(self):"
		self["list"].instance.hide()
		self.container.execute("opkg update")

	def installFinished(self):
		# was ist eigentlich passiert? Aktualisiere...
		self["list"].instance.hide()
		try:
			f = open("/usr/lib/opkg/info/"+self["list"].l.getCurrentSelection()[0].name+".control", "r")
			addoncontent = f.read()
			f.close()
		except:
			addoncontent = ""
		name = ""
		version = ""
		description = ""
		addoncontentInfo = addoncontent.split("\n")
		for line in addoncontentInfo:
			if line.startswith("Package: "):
				name = line[9:]
			if line.startswith("Version: "):
				version = line[9:]
			if line.startswith("Description: "):
				description = line[13:]
		if name != "" and version != "":
			for aa in self.pluginlist:
				if aa.name == name:
					if version == self["list"].l.getCurrentSelection()[0].version:
						aa.status = 1
					else:
						aa.status = 2
		else:
			for aa in self.pluginlist:
				if aa.name == self["list"].l.getCurrentSelection()[0].name:
					aa.status = 0
		self.updateList()
		plugins.readPluginList(resolveFilename(SCOPE_PLUGINS))
		self["list"].instance.show()

	def runFinished(self, retval):
		self.remainingdata = ""
		if self.run == 0:
			self.run = 1
			self.container.execute("opkg list-installed enigma2-*")
		elif self.run == 1:
			self.run = 2
			self.container.execute("opkg list enigma2-*")
		elif self.run == 2:
			if len(self.pluginlist) > 0:
				self.updateList()
				self["list"].instance.show()
			else:
				self["text"].setText("Neue Plugins gefunden...")

	def dataAvail(self, str):
		#prepend any remaining data from the previous call
		str = self.remainingdata + str
		#split in lines
		lines = str.split('\n')
		#'str' should end with '\n', so when splitting, the last line should be empty. If this is not the case, we received an incomplete line
		if len(lines[-1]):
			#remember this data for next time
			self.remainingdata = lines[-1]
			lines = lines[0:-1]
		else:
			self.remainingdata = ""
		for x in lines:
			plugin = x.split(" - ")
			if len(plugin) >= 2 and self.run == 1:
				self.addoninstalled.append(AddOn(name = plugin[0], version = plugin[1], status = 1))
			elif len(plugin) == 3 and self.run == 2:
				flagStatus = 0 # nicht installiert
				for cb in self.addoninstalled:
					if plugin[0] == cb.name:
						if plugin[1] == cb.version:
							if cb.status != 2:
								flagStatus = 1 # installiert
							else:
								flagStatus = -1 # brauchen wir nicht, da schon als update gekennzeichnet
						else:
							cb.status = 2
							flagStatus = 2 # update
				if flagStatus != -1:
					self.pluginlist.append(AddOn(name = plugin[0], version = plugin[1], description = plugin[2], status = flagStatus))

	def updateList(self):
		self.list = []
		expandableIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/green_plus.png"))
		expandedIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/red_minus.png"))
		verticallineIcon = LoadPixmap(resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/verticalline-plugins.png"))
		installedIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/green.png"))
		notinstalledIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/red.png"))
		updateIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/blue.png"))
		self.plugins = {}
		for x in self.pluginlist:
			temp = ""
			temp1 = x.name
			if x.name.startswith('enigma2-skin-') or x.name.startswith('enigma2-cams-') or x.name.startswith('enigma2-configs-') or x.name.startswith('enigma2-picons-'):
				temp = x.name[8:]
			elif x.name.startswith('enigma2-plugin-'):
				temp = x.name[15:]
			else:
				continue
			split = temp.split('-')
			if len(split) < 2:
				continue
			if split[0] == "skin":
				split[0] = "skins" # manuelle Korrektur, damit ich die CVS Skins nicht neu erstellen muss...
			if not self.plugins.has_key(split[0]):
				self.plugins[split[0]] = []
			if x.status == 0:			
				pngstatus = notinstalledIcon
			elif x.status == 1:
				pngstatus = installedIcon
			elif x.status == 2:
				pngstatus = updateIcon
			else:
				pngstatus = None
			self.plugins[split[0]].append((AddOnDescriptor(name = x.name, what = split[0], description = x.description, icon = verticallineIcon, status = x.status, version = x.version, statusicon = pngstatus), split[1]))
		for x in self.plugins.keys():
			if x in self.expanded:
				self.list.append(AddOnCategoryComponent(x, expandedIcon))
				for plugin in self.plugins[x]:
					self.list.append(AddOnDownloadComponent(plugin[0], plugin[1]))
			else:
				self.list.append(AddOnCategoryComponent(x, expandableIcon))
		self["list"].l.setList(self.list)

class DialogUpdateDelete(Screen):

	skin = """
		<screen name="DialogUpdateDelete" position="60,245" size="600,10" title="AddOnManager">
		<widget name="text" position="65,8" size="520,0" font="Regular;22" />
		<widget name="QuestionPixmap" pixmap="skin_default/icons/input_question.png" position="5,5" size="53,53" alphatest="on" />
		<widget name="list" position="100,100" size="480,375" />
		<applet type="onLayoutFinish">
# this should be factored out into some helper code, but currently demonstrates applets.
from enigma import eSize, ePoint

orgwidth = self.instance.size().width()
orgpos = self.instance.position()
textsize = self[&quot;text&quot;].getSize()

# y size still must be fixed in font stuff...
textsize = (textsize[0] + 50, textsize[1] + 50)
offset = 0
offset = 60
wsizex = textsize[0] + 60
wsizey = textsize[1] + offset
if (280 &gt; wsizex):
	wsizex = 280
wsize = (wsizex, wsizey)


# resize
self.instance.resize(eSize(*wsize))

# resize label
self[&quot;text&quot;].instance.resize(eSize(*textsize))

# move list
listsize = (wsizex, 50)
self[&quot;list&quot;].instance.move(ePoint(0, textsize[1]))
self[&quot;list&quot;].instance.resize(eSize(*listsize))

# center window
newwidth = wsize[0]
self.instance.move(ePoint(orgpos.x() + (orgwidth - newwidth)/2, orgpos.y()))
		</applet>
	</screen>"""

	def __init__(self, session, text,):
		Screen.__init__(self, session)
 		self["text"] = Label(text)
		self["Text"] = StaticText(text)
		self.text = text
		self["QuestionPixmap"] = Pixmap()
		self.list = []
		self.list = [ (_("Update Addon"), 0), (_("Delete Addon"), 1) ]
		self["list"] = MenuList(self.list)
		self["actions"] = ActionMap(["MsgBoxActions", "DirectionActions"], 
			{
				"cancel": self.cancel,
				"ok": self.ok,
				"up": self.up,
				"down": self.down,
				"left": self.left,
				"right": self.right,
				"upRepeated": self.up,
				"downRepeated": self.down,
				"leftRepeated": self.left,
				"rightRepeated": self.right
			}, -1)

	def __onShown(self):
		self.onShown.remove(self.__onShown)
	def cancel(self):
		self.close(-1)
	def ok(self):
		self.close(self["list"].getCurrent()[1] == 0)
	def up(self):
		self.move(self["list"].instance.moveUp)
	def down(self):
		self.move(self["list"].instance.moveDown)
	def left(self):
		self.move(self["list"].instance.pageUp)
	def right(self):
		self.move(self["list"].instance.pageDown)
	def move(self, direction):
		self["list"].instance.moveSelection(direction)
	def __repr__(self):
		return str(type(self)) + "(" + self.text + ")"


############################# Backup #####################################

class SYSBACKUP(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="System Backup" >
			<widget name="myText" position="10,10" size="400,300" valign="center" halign="center" zPosition="2"  foregroundColor="white" font="Regular;22"/>
			<widget name="myRedBtn" position="10,340" size="100,40" backgroundColor="red" valign="center" halign="center" zPosition="2"  foregroundColor="white" font="Regular;20"/>
			<widget name="myGreenBtn" position="120,340" size="100,40" backgroundColor="green" valign="center" halign="center" zPosition="2"  foregroundColor="white" font="Regular;20"/>
		</screen>"""

	def __init__(self, session, args = 0):
		self.session = session
		Screen.__init__(self, session)
		
		self.text="System Full Backup erstellen ?\nDas Backup benoetigt ca. 90 Min\nes kann im Hintergrund\nausgefuehrt werden so das das\nSystem weiter verwendet werden\nkann (VIP1v2 und VIP2 user bitte\nnicht Zappen) bei Fertigstellung\nbefindet sich das Backup in\n/Enigma2_System_Ordner/Backups\nDieses Backup ist ein Update Backup\nbitte entpacken nach /media/sda1 !!!"
		self["myText"] = Label()
		self["myRedBtn"] = Label(_("Cancel"))
		self["myGreenBtn"] = Label(_("OK"))
		self["myActionsMap"] = ActionMap(["SetupActions", "ColorActions"],
		{
			"ok": self.startbackup,
			"green": self.startbackup,
			"red": self.cancel,
			"cancel": self.cancel,
		}, -1)
		self.onShown.append(self.setMyText)

	def setMyText(self):
		self["myText"].setText(self.text)
		
	def startbackup(self):
		os.system("/var/config/system/backup.sh &")
		self.close(None)

	def cancel(self):
		print "\n[SYSBACKUP] cancel\n"
		self.close(None)
############################# Backup #####################################

class SYSINSTALLBACKUP(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="System Backup" >
			<widget name="myText" position="10,10" size="400,300" valign="center" halign="center" zPosition="2"  foregroundColor="white" font="Regular;22"/>
			<widget name="myRedBtn" position="10,340" size="100,40" backgroundColor="red" valign="center" halign="center" zPosition="2"  foregroundColor="white" font="Regular;20"/>
			<widget name="myGreenBtn" position="120,340" size="100,40" backgroundColor="green" valign="center" halign="center" zPosition="2"  foregroundColor="white" font="Regular;20"/>
		</screen>"""

	def __init__(self, session, args = 0):
		self.session = session
		Screen.__init__(self, session)
		
		self.text1="System Install Backup erstellen ?\nDas Backup benoetigt ca. 90 Min\nes kann im Hintergrund\nausgefuehrt werden so das das\nSystem weiter verwendet werden\nkann (VIP1v2 und VIP2 user bitte\nnicht Zappen) bei Fertigstellung\nbefindet sich das Backup in\n/Enigma2_System_Ordner/Backups\nDieses Backup ist ein Install Backup\nbitte entpacken auf ext2 Stick !!!"
		self["myText"] = Label()
		self["myRedBtn"] = Label(_("Cancel"))
		self["myGreenBtn"] = Label(_("OK"))
		self["myActionsMap"] = ActionMap(["SetupActions", "ColorActions"],
		{
			"ok": self.startsysbackup,
			"green": self.startsysbackup,
			"red": self.cancel,
			"cancel": self.cancel,
		}, -1)
		self.onShown.append(self.setMyText)

	def setMyText(self):
		self["myText"].setText(self.text1)
		
	def startsysbackup(self):
		os.system("/var/config/system/install_backup.sh &")
		self.close(None)

	def cancel(self):
		print "\n[SYSINSTALLBACKUP] cancel\n"
		self.close(None)
###########################################################################

def main(session, **kwargs):
	print "\n[MyMenu] start\n"	
	session.open(MyMenu)

###########################################################################
def menu(menuid, **kwargs):
	if menuid == "mainmenu":
		return [(_("TeamCS Menu"), main, "MyMenu", 46)]
	return []

def Plugins(**kwargs):
	return [
		PluginDescriptor(name="TeamCS Menu", description="Das TeamCS Menu", where = PluginDescriptor.WHERE_PLUGINMENU, icon="../ihad_tut.png", fnc=main),
		PluginDescriptor(name="TeamCS Menu", description="TeamCS Multi Menu", where = PluginDescriptor.WHERE_MENU, fnc=menu)]
