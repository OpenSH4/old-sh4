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

class BACKUP(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("System Full Backup erstellen", "backupsys", "sback", "46"))
		list.append(("System Install Backup erstellen", "backupinstallsys", "sback", "46"))
		list.append(("Kanal-listen Sichern", "ksave", "sback", "46"))
		list.append(("Kanal-listen Installieren", "kinstall", "sback", "46"))
		list.append(("-------- Settings Download -------", "", "sback", "46"))
		list.append(("Piloten Kanallisten Download", "piloten", "sback", "46"))

		
		Screen.__init__(self, session)
		self["BACKUP"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["BACKUP"].getCurrent()
		if selection is not None:
			if selection[1] == "backupsys":
				self.session.open(SYSBACKUP)

			if selection[1] == "backupinstallsys":
				self.session.open(SYSINSTALLBACKUP)

			elif selection[1] == "ksave":
				self.prombt("/var/config/tools/sender_sichern.sh")	

			elif selection[1] == "kinstall":
				self.prombt("/var/config/tools/sender_install.sh")

			elif selection[1] == "piloten":
				self.prombt("/var/config/tools/piloten-settings.sh")
		
			else:
				print "\n[BACKUP] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("BackUp Menu: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[BACKUP] cancel\n"
		self.close(None)
############################# Backup #####################################

class SYSBACKUP(Screen):
	def __init__(self, session, args = 0):
		self.session = session
		Screen.__init__(self, session)
		
		self.text="System Full Backup erstellen ?\nDas Backup benoetigt ca. 90 Min\nes kann im Hintergrund\nausgefuehrt werden so das das\nSystem weiter verwendet werden\nkann (VIP1v2 und VIP2 user bitte\nnicht Zappen) bei Fertigstellung\nbefindet sich das Backup in\n/Enigma2_System_Ordner/Backups\nDieses Backup ist ein Update Backup\nbitte entpacken nach /media/sda1 !!!"
		self["myText"] = Label()
		self["myRedBtn"] = Label(_("Cancel"))
		self["myGreenBtn"] = Label(_("OK"))
		self["myActionsMap"] = ActionMap(["SetupActions", "ColorActions"],
		{
			"ok": self.startbackup,
			"green": self.startbackup,
			"red": self.cancel,
			"cancel": self.cancel,
		}, -1)
		self.onShown.append(self.setMyText)

	def setMyText(self):
		self["myText"].setText(self.text)
		
	def startbackup(self):
		self.close(None)
		os.system("sleep 10; /var/config/system/backup.sh &")

	def cancel(self):
		print "\n[SYSBACKUP] cancel\n"
		self.close(None)
############################# Backup #####################################

class SYSINSTALLBACKUP(Screen):
	def __init__(self, session, args = 0):
		self.session = session
		Screen.__init__(self, session)
		
		self.text1="System Install Backup erstellen ?\nDas Backup benoetigt ca. 90 Min\nes kann im Hintergrund\nausgefuehrt werden so das das\nSystem weiter verwendet werden\nkann (VIP1v2 und VIP2 user bitte\nnicht Zappen) bei Fertigstellung\nbefindet sich das Backup in\n/Enigma2_System_Ordner/Backups\nDieses Backup ist ein Install Backup\nbitte entpacken auf ext2 Stick !!!"
		self["myText"] = Label()
		self["myRedBtn"] = Label(_("Cancel"))
		self["myGreenBtn"] = Label(_("OK"))
		self["myActionsMap"] = ActionMap(["SetupActions", "ColorActions"],
		{
			"ok": self.startsysbackup,
			"green": self.startsysbackup,
			"red": self.cancel,
			"cancel": self.cancel,
		}, -1)
		self.onShown.append(self.setMyText)

	def setMyText(self):
		self["myText"].setText(self.text1)
		
	def startsysbackup(self):
		self.close(None)
		os.system("sleep 10; /var/config/system/install_backup.sh &")

	def cancel(self):
		print "\n[SYSINSTALLBACKUP] cancel\n"
		self.close(None)