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

class ETHMAC(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Benutze MAC 00:80:E1:12:06:30 -- default", "MAC1", "mac", "46"))
		list.append(("Benutze MAC 00:81:E1:12:06:30", "MAC2", "mac", "46"))
		list.append(("Benutze MAC 00:82:E1:12:06:30", "MAC3", "mac", "46"))
		list.append(("Benutze MAC 00:83:E1:12:06:30", "MAC4", "mac", "46"))
		list.append(("Benutze MAC 00:84:E1:12:06:30", "MAC5", "mac", "46"))

		Screen.__init__(self, session)
		self["ETHMAC"] = List(list)
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