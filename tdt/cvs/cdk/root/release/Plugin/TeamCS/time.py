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

class TIMESET(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Display Reset", "display", "timer", "46"))
		list.append(("Display Uhr Aktivieren", "an", "timer", "46"))
		list.append(("Display Uhr Deaktivieren", "aus", "timer", "46"))
		list.append(("Sommerzeit Einstellen", "sommer", "timer", "46"))
		list.append(("Winterzeit Einstellen", "winter", "timer", "46"))
		list.append(("Display Auschalt Anzeige", "ausmachen", "timer", "46"))
		
		Screen.__init__(self, session)
		self["TIMESET"] = List(list)
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
				self.session.open(TIMESHUTDOWN)
		
			else:
				print "\n[TIMESET] cancel\n"
				self.close(None)

	def cancel(self):
		print "\n[TIMESET] cancel\n"
		self.close(None)

class TIMESHUTDOWN(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		list = []
		list.append(("Anzeige von Turn OFF", "turnoff", "timer", "46"))
		list.append(("Anzeige von Turno OFF und Datum", "offdate", "timer", "46"))
		list.append(("Anzeige von Datum", "date", "timer", "46"))
		list.append(("Display Deaktivieren", "aus", "timer", "46"))
		
		self["TIMESHUTDOWN"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["TIMESHUTDOWN"].getCurrent()
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

	def cancel(self):
		print "\n[TIMESET] cancel\n"
		self.close(None)