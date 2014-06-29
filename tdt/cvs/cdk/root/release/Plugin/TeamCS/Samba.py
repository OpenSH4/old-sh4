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

class SAMBASET(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Samba AN", "SAMBAAN", "samba", "46"))
		list.append(("Samba AUS", "SAMBAAUS", "samba", "46"))
		
		self["SAMBASET"] = List(list)
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
		