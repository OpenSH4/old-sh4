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

class USBSERIAL(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("USB to Serial FTDI Treiber Modul", "USB1", "usbserial", "46"))
		list.append(("USB to Serial PL2303 Treiber Modul", "USB2", "usbserial", "46"))
		list.append(("USB to Serial PL2303 und FTDI Treiber Laden", "USB4", "usbserial", "46"))
		list.append(("USB to Serial Deaktivieren", "USB3", "usbserial", "46"))
		
		self["USBSERIAL"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["USBSERIAL"].getCurrent()
		if selection is not None:
			if selection[1] == "USB1":
				os.system("echo 1 > /var/keys/Benutzerdaten/.system/serial")
				self.session.open(MessageBox,_("FTDI wird geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "USB2":
				os.system("echo 2 > /var/keys/Benutzerdaten/.system/serial")
				self.session.open(MessageBox,_("PL2303 wird geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "USB4":
				os.system("echo 3 > /var/keys/Benutzerdaten/.system/serial")
				self.session.open(MessageBox,_("PL2303 und FTDI wird geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			elif selection[1] == "USB3":
				os.system("echo 0 > /var/keys/Benutzerdaten/.system/serial")
				self.session.open(MessageBox,_("Treiber wird nicht geladen, Neustart erforderlich"), MessageBox.TYPE_INFO)

			else:
				print "\n[USBSERIAL] cancel\n"
				self.close(None)

	
	def cancel(self):
		print "\n[USBSERIAL] cancel\n"
		self.close(None)