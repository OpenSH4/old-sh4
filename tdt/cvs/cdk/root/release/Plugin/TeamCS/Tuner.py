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

class TUNER(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Auto Tuner Ermitteln", "ate", "tuner", "46"))

		self["TUNER"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["TUNER"].getCurrent()
		if selection is not None:
			if selection[1] == "tuner":
				os.system("echo vip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("OPTI VIP ST-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner2":
				os.system("echo rbvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("OPTI VIP RB-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner1kabel":
				os.system("echo vip1kabel > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("VIP1 LG Kabel-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner1dvbt":
				os.system("echo vip1dvbt > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("VIP1 DVB-T-Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuners2lg":
				os.system("echo s2lgvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp DVB-S2 LG DVB-C Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tuner2xlg":
				os.system("echo 2xlgvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("2x DVB-C LG Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunerlgdvbt":
				os.system("echo lgdvbtvip > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("LG DVB-C und DVB-T Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunerdvbs2dvbt":
				os.system("echo dvbs2dvbt > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp DVB-S2 und DVB-T Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip1v2":
				os.system("echo vip1v2 > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp VIP1v2 Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip1v2kabel":
				os.system("echo vip1v2kabel > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("LG VIP1v2 Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip1v2dvbt":
				os.system("echo vip1v2dvbt > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("Sharp DVB-T VIP1v2 Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "tunervip2":
				os.system("echo vip2 > /var/keys/Benutzerdaten/.system/tuner")
				self.session.open(MessageBox,_("VIP2 Sharp Tuner gesetzt"), MessageBox.TYPE_INFO)

			elif selection[1] == "ate":
				#os.system("/bin/autoswitch -b; /bin/autoswitch -t")
				self.prombt("/bin/autoswitch -b; /bin/autoswitch -t")
				#self.session.open(MessageBox,_("Tuner wurden ermittelt, bitte Neustarten"), MessageBox.TYPE_INFO)

			else:
				print "\n[TUNER] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[TUNER] cancel\n"
		self.close(None)