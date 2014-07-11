import os
from Screens.Screen import Screen
from Screens.Console import Console
from Screens.ChoiceBox import ChoiceBox
from Screens.MessageBox import MessageBox
from Screens.InputBox import InputBox
from Components.MenuList import MenuList
from Components.ActionMap import ActionMap, NumberActionMap
from Components.Pixmap import Pixmap
from Components.Sources.StaticText import StaticText
from Components.Sources.List import List
from Components.Label import Label
from Components.PluginComponent import plugins
from Components.PluginList import *
from Components.ConfigList import ConfigList
from Components.config import *
from Components.Input import Input
from Tools.Directories import resolveFilename, SCOPE_PLUGINS, SCOPE_SKIN_IMAGE, fileExists
from Tools.LoadPixmap import LoadPixmap
from twisted.web.client import getPage
from Plugins.Plugin import PluginDescriptor
from enigma import eConsoleAppContainer, loadPNG, ePicLoad, eListboxPythonStringContent, eListbox, eTimer

# include Submenues
from Addon import *
from Benutzer import *
from usbserial import *
from system import *
from emu import *
from time import *
from Backup import *
from Swap import *
from OverClock import *
from Config import *
from network import *

###########################################################################

class MyMenu(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)

		list = []
		list.append(("Emu Menu", "EMU", "EMUMANAGER", "46"))
		list.append(("Addon Manager", "addon", "addonmanager", "46"))
		list.append(("Display Uhr Einstellen", "time", "timer", "46"))
		list.append(("USB zu Serial Treiber", "usbtoserial", "usbtoserial", "46"))
		list.append(("Backup, Install Menu", "BACKUP", "BACKUPINSTALL", "46"))
		list.append(("System Information", "SYSTEM", "SYSINFO", "46"))
		list.append(("Online Update", "ONLINE", "update", "46"))
		list.append(("Network Menu", "network", "NETZ", "46"))
		list.append(("Benutzerdaten Einstellen", "benutzerdaten", "setbenutzer", "46"))
		list.append(("Swap Einrichten", "swap", "swappart", "46"))
		list.append(("CPU Overclocking", "CPUO", "CPUOVER", "46"))
		list.append(("NeutrinoHD2 Subsystem Switch", "NHD2", "subsystem", "46"))		

		self["menu"] = List(list)

		self["myActionMap"] = ActionMap(["MinuteInputActions", "MenuActions"],
		{
			"ok": self.go,
			"cancel": self.cancel,
			"menu": self.config
		}, -1)

	def config(self):
		print "Open Configuration"
		self.session.open(Config)

	def go(self):
		print "okbuttonClick"
		selection = self["menu"].getCurrent()
		if selection is not None:
			if selection[1] == "EMU":
				self.session.open(EMU)

			elif selection[1] == "addon":
				self.session.open(MerlinDownloadBrowser)

			elif selection[1] == "ONLINE":
				self.prombt("/var/config/updatecheck.sh")

			elif selection[1] == "SYSTEM":
				self.session.open(SYSTEM)

			elif selection[1] == "time":
				self.session.open(TIMESET)

			elif selection[1] == "network":
				self.session.open(network)

			elif selection[1] == "swap":
				self.session.open(SWAPPART)

			elif selection[1] == "BACKUP":
				self.session.open(BACKUP)

			elif selection[1] == "network":
				self.session.open(network)
			
			elif selection[1] == "wol":
				self.session.open(WOLSET)

			elif selection[1] == "benutzerdaten":
				self.session.open(BENUTZER)	

			elif selection[1] == "CPUO":
				self.session.open(OVERCLOCK)

			elif selection[1] == "NHD2":
				self.session.open(MessageBox,_("Enigma2 wird beendet, NeutrinoHD2 wird gestartet... Bitte warten"), MessageBox.TYPE_INFO)
				os.system("/var/config/system/nhd_switch.sh &")				

			elif selection[1] == "usbtoserial":
				self.session.open(USBSERIAL)
		
			else:
				print "\n[MyMenu] cancel\n"
				self.close(None)
	
	def prombt(self, com):
		self.session.open(Console,_("Diplay Reset: %s") % (com), ["%s" % com])

	def cancel(self):
		print "\n[MyMenu] cancel\n"
		self.close(None)


###########################################################################

def main(session, **kwargs):
	print "\n[MyMenu] start\n"	
	session.open(MyMenu)

def mainemu(session, **kwargs):
	print "\n[Addon] start\n"	
	session.open(EMU)

def mainsys(session, **kwargs):
	print "\n[Addon] start\n"	
	session.open(SYSTEM)

def mainaddon(session, **kwargs):
	print "\n[Addon] start\n"	
	session.open(MerlinDownloadBrowser)

###########################################################################
def menu(menuid, **kwargs):
	if menuid == "mainmenu":
	  	if config.plugins.TeamCS_globalsettings.showemu.value == True and config.plugins.TeamCS_globalsettings.showsysinfo.value == True and config.plugins.TeamCS_globalsettings.showaddon.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("Emu Menu"), mainemu, "EMU", 46),
				(_("Addon Manager"), mainaddon, "MerlinDownloadBrowser", 46),
				(_("System Information"), mainsys, "SYSTEM", 46)]		  
		elif config.plugins.TeamCS_globalsettings.showemu.value == True and config.plugins.TeamCS_globalsettings.showsysinfo.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("Emu Menu"), mainemu, "EMU", 46),
				(_("System Information"), mainsys, "SYSTEM", 46)]
		elif config.plugins.TeamCS_globalsettings.showemu.value == True and config.plugins.TeamCS_globalsettings.showaddon.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("Emu Menu"), mainemu, "EMU", 46),
				(_("Addon Manager"), mainaddon, "MerlinDownloadBrowser", 46)]
		elif config.plugins.TeamCS_globalsettings.showaddon.value == True and config.plugins.TeamCS_globalsettings.showsysinfo.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("Addon Manager"), mainaddon, "MerlinDownloadBrowser", 46),
				(_("System Information"), mainsys, "SYSTEM", 46)]
		elif config.plugins.TeamCS_globalsettings.showsysinfo.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("System Information"), mainsys, "SYSTEM", 46)]
		elif config.plugins.TeamCS_globalsettings.showemu.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("Emu Menu"), mainemu, "EMU", 46)]
		elif config.plugins.TeamCS_globalsettings.showaddon.value == True:
			return [(_("TeamCS Menu"), main, "MyMenu", 46),
				(_("Addon Manager"), mainaddon, "MerlinDownloadBrowser", 46)]
		else:
			return [(_("TeamCS Menu"), main, "MyMenu", 46)]
	return []

def Plugins(**kwargs):
	return [
		PluginDescriptor(name="Emu Menu", description="Emu Menu", where = PluginDescriptor.WHERE_MENU, fnc=menu),
		PluginDescriptor(name="Addon Manager", description="Addon Manager", where = PluginDescriptor.WHERE_MENU, fnc=menu),
		PluginDescriptor(name="TeamCS Menu", description="Das TeamCS Menu", where = PluginDescriptor.WHERE_PLUGINMENU, icon="../ihad_tut.png", fnc=main),
		PluginDescriptor(name="TeamCS Menu", description="TeamCS Multi Menu", where = PluginDescriptor.WHERE_MENU, fnc=menu),
		PluginDescriptor(name="System Information", description="SystemInfo", where = PluginDescriptor.WHERE_MENU, fnc=menu)]