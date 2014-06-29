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

class OVERCLOCK(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("---------- Boot Overclocking -----------", "", "over", "46"))
		list.append(("Aktivieren 266 Mhz -- default", "OVEROFF", "over", "46"))
		list.append(("Aktivieren 300 Mhz", "300OVERON", "over", "46"))
		list.append(("Aktivieren 333 Mhz", "333OVERON", "over", "46"))
		list.append(("Aktivieren 366 Mhz", "366OVERON", "over", "46"))
		list.append(("Aktivieren 400 Mhz", "400OVERON", "over", "46"))
		list.append(("--------- Dauer Overclocking -----------", "", "over", "46"))
		list.append(("Aktivieren 300 Mhz", "300DAUEROVERON", "over", "46"))
		list.append(("Aktivieren 333 Mhz", "333DAUEROVERON", "over", "46"))
		list.append(("Aktivieren 366 Mhz", "366DAUEROVERON", "over", "46"))
		list.append(("Aktivieren 400 Mhz", "400DAUEROVERON", "over", "46"))
		list.append(("Deaktiviert Overclocking", "DAUEROVEROFF", "over", "46"))
		list.append(("----------------------------------------", "", "over", "46"))
		list.append(("Overclock Frequence Check", "OCCHECK", "over", "46"))
		list.append(("----------------------------------------", "", "over", "46"))
		list.append(("Das Overclocking geschieht auf eigene", "", "over", "46"))
		list.append(("Gefahr, jeder muss selber wissen was er", "", "over", "46"))
		list.append(("seiner Box Antut, getestet sind diese ", "", "over", "46"))
		list.append(("Einstellungen, dennoch kann es sich bei", "", "over", "46"))
		list.append(("jeder Box anders Verhalten oder Auswirken !", "", "over", "46"))
		
		self["OVERCLOCK"] = List(list)
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
				