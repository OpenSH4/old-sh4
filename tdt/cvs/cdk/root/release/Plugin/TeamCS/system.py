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

class SYSTEM(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Netzwerk Infos", "netstat", "sysinfo", "46"))
		list.append(("Geladen Module Anzeigen", "lsmod", "sysinfo", "46"))
		list.append(("Freier Speicher", "free", "sysinfo", "46"))
		list.append(("Image Version Infomation", "IMG", "sysinfo", "46"))
		list.append(("Letztes FSCK Log Anzeigen", "FSCK", "sysinfo", "46"))
		list.append(("Nand Speicher Menu", "NAND", "sysinfo", "46"))

		self["SYSTEM"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["SYSTEM"].getCurrent()
		
		if selection is not None:
			if selection[1] == "netstat":
				self.prombt("/bin/netstat")
					
			elif selection[1] == "lsmod":
				self.prombt("/sbin/lsmod")

			elif selection[1] == "free":
				self.prombt("free")

			elif selection[1] == "NAND":
				self.session.open(NANDMENU)
				
			elif selection[1] == "IMG":
				self.prombt("/var/config/sysversion.sh")

			elif selection[1] == "FSCK":
				self.prombt("/var/config/system/fsck.sh")
		
			else:
				print "\n[SYSTEM] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("SYS INFO: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[SYSTEM] cancel\n"
		self.close(None)
###########################################################################

class NANDMENU(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Nand fur Enigma2 verwenden", "NE2", "sysinfo", "46"))
		list.append(("Nand Backup wieder zurck Spielen", "NBACK", "sysinfo", "46"))
		list.append(("Komplett Nand Flash ILTV Vip1,Vip1v2", "NFV1", "sysinfo", "46"))
		list.append(("Komplett Nand Flash ILTV Vip2", "NFV2", "sysinfo", "46"))
		list.append(("Komplett Nand Flash ILTV Opticum", "NFVO", "sysinfo", "46"))
		
		self["NANDMENU"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],

		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["NANDMENU"].getCurrent()
		
		if selection is not None:
			if selection[1] == "NE2":
				self.prombt("/var/config/system/mtd/mtd1-jffs2.sh")
					
			elif selection[1] == "NBACK":
				self.prombt("/var/config/system/mtd/mtd1-jffs2-backup.sh")

			elif selection[1] == "NFV1":
				self.prombt("/var/config/system/mtd/mtd3-vip1.sh")

			elif selection[1] == "NFV2":
				self.prombt("/var/config/system/mtd/mtd3-vip2.sh")
				
			elif selection[1] == "NFVO":
				self.session.open(OPTI)
		
			else:
				print "\n[NANDMENU] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Nand: %s") % (com), ["%s" % com])
		
	def cancel(self):

		print "\n[NANDMENU] cancel\n"
		self.close(None)

###########################################################################

class OPTI(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("ILTV fur Opticum mit RB Tuner", "ILTVRB", "sysinfo", "46"))
		list.append(("ILTV fur Opticum mit ST Tuner", "ILTVST", "sysinfo", "46"))
		
		self["OPTI"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["OPTI"].getCurrent()
		
		if selection is not None:
			if selection[1] == "ILTVRB":
				self.prombt("/var/config/system/mtd/mtd3-opti-rb.sh")
					
			elif selection[1] == "ILTVST":
				self.prombt("/var/config/system/mtd/mtd3-opti-st.sh")

			else:
				print "\n[OPTI] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Nand: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[OPTI] cancel\n"
		self.close(None)