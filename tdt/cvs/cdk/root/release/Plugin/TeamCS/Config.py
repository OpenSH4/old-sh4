from enigma import eTimer
from Screens.Screen import Screen
from Screens.Standby import TryQuitMainloop
from Screens.ServiceInfo import ServiceInfoList, ServiceInfoListEntry
from Components.ActionMap import ActionMap, NumberActionMap
from Components.Pixmap import Pixmap, MovingPixmap
from Components.Label import Label
from Screens.MessageBox import MessageBox
from Components.Sources.List import List
from Components.Sources.StaticText import StaticText
from Components.MenuList import MenuList
from Components.ConfigList import ConfigList, ConfigListScreen
from Components.Console import Console
from Components.ScrollLabel import ScrollLabel
from Components.config import *

from Components.Button import Button

from Tools.Directories import resolveFilename, fileExists, pathExists, createDir, SCOPE_MEDIA
from Components.FileList import FileList
from Components.AVSwitch import AVSwitch
from Plugins.Plugin import PluginDescriptor

config.plugins.TeamCS_globalsettings = ConfigSubsection()
config.plugins.TeamCS_globalsettings.showemu = ConfigYesNo(default=False)
config.plugins.TeamCS_globalsettings.showaddon = ConfigYesNo(default=False)
config.plugins.TeamCS_globalsettings.showsysinfo = ConfigYesNo(default=False)

class Config(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)

		self["actions"] = NumberActionMap(["SetupActions","OkCancelActions"],
		{
			"save": self.keyGREEN,
			"cancel": self.close,
			"left": self.keyLeft,
			"right": self.keyRight
		}, -1)
		self["key_green"] = Label(_("Save"))
		
		self.list = []
		self.list.append(getConfigListEntry(_("Zeige Emu Menu in Hauptmenu"), config.plugins.TeamCS_globalsettings.showemu))
		self.list.append(getConfigListEntry(_("Zeige Addon Manager in Hauptmenu"), config.plugins.TeamCS_globalsettings.showaddon))
		self.list.append(getConfigListEntry(_("Zeige SystemInfo in Hauptmenu"), config.plugins.TeamCS_globalsettings.showsysinfo))
		self["configlist"] = ConfigList(self.list)
		
	def keyLeft(self):
		self["configlist"].handleKey(KEY_LEFT)

	def keyRight(self):
		self["configlist"].handleKey(KEY_RIGHT)

	def keyGREEN(self):
		config.plugins.TeamCS_globalsettings.save()
		self.close()