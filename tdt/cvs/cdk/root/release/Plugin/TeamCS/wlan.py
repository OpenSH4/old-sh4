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

class WLAN(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("W-Lan 8192cu.ko Treiber Modul", "1", "wlan", "46"))
		list.append(("W-Lan 8712u.ko Treiber Modul", "2", "wlan", "46"))
		list.append(("W-Lan rt2870sta.ko Treiber Modul", "3", "wlan", "46"))
		list.append(("W-Lan rt3070sta.ko Treiber Modul", "4", "wlan", "46"))
		list.append(("W-Lan rt5370sta.ko Treiber Modul", "5", "wlan", "46"))
		list.append(("W-Lan rt73.ko Treiber Modul", "6", "wlan", "46"))
		list.append(("W-Lan zydas.ko Treiber Modul", "7", "wlan", "46"))
		list.append(("W-Lan 8188eu.ko Treiber Modul", "8", "wlan", "46"))
		list.append(("W-Lan 8812au.ko Treiber Modul", "10", "wlan", "46"))
		list.append(("W-Lan Deaktivieren", "9", "wlan", "46"))

		self["WLAN"] = List(list)
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
				os.system("echo 8 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul 8188eu.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "10":
				os.system("echo 9 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Modul 8812au.ko Geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "9":
				os.system("echo 0 > /var/keys/Benutzerdaten/.system/wlan")
				self.session.open(MessageBox,_("W-Lan Treiber Deaktiviert, Neustart erforderlich"), MessageBox.TYPE_INFO)
		
			else:
				print "\n[WLAN] cancel\n"
				self.close(None)

	
	def cancel(self):
		print "\n[WLAN] cancel\n"
		self.close(None)