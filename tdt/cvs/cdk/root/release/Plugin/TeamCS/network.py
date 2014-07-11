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

from wlan import *
from wol import *
from upnp import *
from OpenVPN import *
from Samba import *
from Mac_Switch import *

class network(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("ETH0 MAC Switcher", "MACSWITCH", "eth0mac", "46"))
		list.append(("WakeOnLan Einstellen", "wol", "woltimer", "46"))
		list.append(("UPNP Media-Server-Client", "upnp", "upnpms", "46"))
		list.append(("OpenVPN Client", "ovpn", "openvpn", "46"))
		list.append(("Samba Menu", "samba", "sambamenu", "46"))
		list.append(("W-Lan Einstellungen", "wlan", "wlansettings", "46"))
		
		self["network"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["network"].getCurrent()
		if selection is not None:
			if selection[1] == "MACSWITCH":
				self.session.open(ETHMAC)
			
			elif selection[1] == "wol":
				self.session.open(WOLSET)
				
			elif selection[1] == "ovpn":
				self.session.open(OPENSET)			

			elif selection[1] == "upnp":
				self.session.open(UPNPSET)
				
			elif selection[1] == "samba":
				self.session.open(SAMBASET)		

			elif selection[1] == "wlan":
				self.session.open(WLAN)

		
	def cancel(self):
		print "\n[network] cancel\n"
		self.close(None)
				