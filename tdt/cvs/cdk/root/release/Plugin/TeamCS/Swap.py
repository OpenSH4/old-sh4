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

class SWAPPART(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("------------ Swap Aktivieren -------------", "", "swap", "46"))
		list.append(("Swap Partition Aktivieren -- default", "swapdev", "swap", "46"))
		list.append(("Ramzswap Aktivieren", "ramzswap", "swap", "46"))
		list.append(("Swapfile auf HDD Aktivieren", "swaphdd", "swap", "46"))
		list.append(("------------ Swap Anlegen -------------", "", "swap", "46"))
		list.append(("Swapfile auf HDD Erstellen", "swapfileerstellen", "swap", "46"))
		list.append(("Swappartition /dev/sda3 Formatieren", "swapfileerstellensda", "swap", "46"))
		
		self["SWAPPART"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["SWAPPART"].getCurrent()
		if selection is not None:
			if selection[1] == "swapdev":
				os.system("echo swapdev > /var/config/SWAP")
				self.session.open(MessageBox,_("Swap /dev/sda2 Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "ramzswap":
				os.system("echo ramzswap > /var/config/SWAP")
				self.session.open(MessageBox,_("RamZswap Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "swaphdd":
				os.system("echo swapfile > /var/config/SWAP")
				self.session.open(MessageBox,_("Swapfile auf HDD Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "swapfileerstellen":
				self.prombt("/var/config/swap/swapfile.sh; echo swapfile > /var/config/SWAP")

			elif selection[1] == "swapfileerstellensda":
				self.prombt("/var/config/swap/swapdev.sh; echo swapdev > /var/config/SWAP")

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[SWAPPART] cancel\n"
		self.close(None)
				