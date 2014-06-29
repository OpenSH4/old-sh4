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
from Components.config import getConfigListEntry
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

class BENUTZER(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("------- CCcam Client ---------", "", "user", "46"))
		list.append(("Benutzername eingeben", "benutzername", "user", "46"))
		list.append(("Passwort eingeben", "password", "user", "46"))
		list.append(("IP oder Dyndns eingeben", "dyndns", "user", "46"))
		list.append(("CCcam Port", "cccam", "user", "46"))
		list.append(("------- Newcamd Client ---------", "", "user", "46"))
		list.append(("Benutzername eingeben", "benutzername", "user", "46"))
		list.append(("Passwort eingeben", "password", "user", "46"))
		list.append(("IP oder Dyndns eingeben", "dyndns", "user", "46"))
		list.append(("MG-Camd Port1", "mgport1", "user", "46"))
		list.append(("MG-Camd Port2", "mgport2", "user", "46"))
		list.append(("-------- Camd3 Client ----------", "", "user", "46"))
		list.append(("Benutzername eingeben", "benutzername", "user", "46"))
		list.append(("Passwort eingeben", "password", "user", "46"))
		list.append(("IP oder Dyndns eingeben", "dyndns", "user", "46"))
		list.append(("Camd3 Port", "camd3", "user", "46"))
		list.append(("--- Generelle Einstellungen ----", "", "user", "46"))
		list.append(("Client Protocol", "server", "user", "46"))
		list.append(("Emu Config Daten erstellen", "emudaten", "user", "46"))
		list.append(("Fernbedienung waehlen", "fbw", "user", "46"))
		
		Screen.__init__(self, session)
		self["BENUTZER"] = List(list)
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
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("---------- Empfaenger -----------", "ArgusVIPneu", "user", "46"))
		list.append(("STM Box Intern ( Default )", "stm", "user", "46"))
		list.append(("MCE2005 USB", "mce2005", "user", "46"))
		list.append(("TechnoTrend USB", "techno", "user", "46"))
		list.append(("--------- Fernbedienung ---------", "ArgusVIPneu", "user", "46"))
		list.append(("ArgusVIP neue FB Rotes Blinken", "ArgusVIPneu", "user", "46"))
		list.append(("ArgusVIP neue FB Gruenes Blinken", "ArgusVIPneugruen", "user", "46"))
		list.append(("ArgusVIP alte FB Rotes Blinken", "ArgusVIPalt", "user", "46"))
		list.append(("ArgusVIP alte FB Gruenes Blinken", "ArgusVIPaltgruen", "user", "46"))
		list.append(("Opticum FB", "Opticum", "user", "46"))
		list.append(("Pingolux FB", "Pingolux", "user", "46"))
		list.append(("MediaCenter FB", "mediacenter", "user", "46"))
		list.append(("TechnoTrend FB", "technotrend", "user", "46"))
		list.append(("System Neustart", "neustart", "user", "46"))
		
		self["FERNB"] = List(list)
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
				os.system("cp /etc/lircd_alt.conf /etc/lircd.conf; echo alt > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB1.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; echo vip1 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP alt Mode Rot"), MessageBox.TYPE_INFO)

			elif selection[1] == "stm":
				os.system("echo stm > /var/config/system/remote")
				self.session.open(MessageBox,_("STM Default Treiber Aktiviert - Reboot"), MessageBox.TYPE_INFO)

			elif selection[1] == "mce2005":
				os.system("echo mce2005 > /var/config/system/remote")
				self.session.open(MessageBox,_("MCE USB Treiber Aktiviert - Reboot"), MessageBox.TYPE_INFO)

			elif selection[1] == "techno":
				os.system("echo techno > /var/config/system/remote")
				self.session.open(MessageBox,_("TechnoTrend USB Treiber Aktiviert - Reboot"), MessageBox.TYPE_INFO)

			elif selection[1] == "ArgusVIPaltgruen":
				os.system("cp /etc/lircd_alt_gruen.conf /etc/lircd.conf; echo alt > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB1.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; echo vip1 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP alt Mode Gruen"), MessageBox.TYPE_INFO)

			elif selection[1] == "ArgusVIPneu":
				os.system("cp /etc/lircd_neu.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_neu.conf /var/tuxbox/config/keymap.conf; echo vip2 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP neu Mode Rot"), MessageBox.TYPE_INFO)

			elif selection[1] == "ArgusVIPneugruen":
				os.system("cp /etc/lircd_neu_gruen.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo vip2 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB ArgusVIP neu Mode Gruen"), MessageBox.TYPE_INFO)

			elif selection[1] == "Opticum":
				os.system("cp /etc/lircd_opti.conf /etc/lircd.conf; echo opti > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_Opti.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_opti.conf /var/tuxbox/config/keymap.conf; echo opti > /var/config/boxtype")
				self.session.open(MessageBox,_("FB Opticum"), MessageBox.TYPE_INFO)

			elif selection[1] == "Pingolux":
				os.system("cp /etc/lircd_pingolux.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_Opti.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; echo Pingolux > /var/config/boxtype")
				self.session.open(MessageBox,_("FB Pingolux gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "mediacenter":
				os.system("cp /etc/lircd_mce2005.conf /etc/lircd.conf; echo mce2005 > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo mce2005 > /var/config/boxtype")
				self.session.open(MessageBox,_("FB MediaCenter gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "technotrend":
				os.system("cp /etc/lircd_techno.conf /etc/lircd.conf; echo techno > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo techno > /var/config/boxtype")
				self.session.open(MessageBox,_("FB TechnoTrend gesetzt"), MessageBox.TYPE_INFO)

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
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("CCcam Client Aktivieren", "CCCAM", "user", "46"))
		list.append(("NewCamd Client Aktivieren", "NEWCAMD", "user", "46"))
		
		self["SERVER"] = List(list)
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
				self.session.open(MessageBox,_("Newcamd wurde als Client definiert"), MessageBox.TYPE_INFO)

			elif selection[1] == "CCCAM":
				os.system("echo cccam > /var/keys/Benutzerdaten/.emu/mgcamd_oder_cccam")
				self.session.open(MessageBox,_("CCcam wurde als Client definiert"), MessageBox.TYPE_INFO)


			else:
				print "\n[SERVER] cancel\n"
				self.close(None)

	def cancel(self):
		print "\n[SERVER] cancel\n"
		self.close(None)

############################ cccam port #################################

class CCPORT(Screen):
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