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

class OPENSET(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("OpenVPN Client Aktivieren", "VPNAN", "openvpn", "46"))
		list.append(("OpenVPN Client Deaktivieren", "VPNAUS", "openvpn", "46"))
		list.append(("OpenVPN Client Autostart Aktivieren", "VPNAUTOAN", "openvpn", "46"))
		list.append(("OpenVPN Client Autostart Deaktivieren", "VPNAUTOAUS", "openvpn", "46"))
		
		self["OPENSET"] = List(list)

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