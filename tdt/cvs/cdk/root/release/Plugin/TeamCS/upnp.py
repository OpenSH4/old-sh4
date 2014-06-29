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

class UPNPSET(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("UPNP Client Aktivieren", "UPNPAN", "upnp", "46"))
		list.append(("UPNP Client Deaktivieren", "UPNPAUS", "upnp", "46"))
		list.append(("UPNP Client Autostart Aktivieren", "UPNPAUTOAN", "upnp", "46"))
		list.append(("UPNP Client Autostart Deaktivieren", "UPNPAUTOAUS", "upnp", "46"))

		self["UPNPSET"] = List(list)
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