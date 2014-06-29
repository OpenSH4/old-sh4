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

class EMU(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Emu Menu" >
			<widget name="EMU" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Stoppt laufende Emus", "stop", "dual", "46"))
		list.append(("------------- Single Emu ------------", "", "dual", "46"))
		list.append(("Start oder Restart Mg-Camd", "mgstart", "dual", "46"))
		list.append(("Start oder Restart OS-Cam", "oscam", "dual", "46"))
		list.append(("Start oder Restart Vizcam", "vizcam", "dual", "46"))
		list.append(("Start oder Restart MBox", "mbox", "dual", "46"))
		list.append(("Start oder Restart Incubus", "incubus", "dual", "46"))
		list.append(("Start oder Restart Camd3", "camd3", "dual", "46"))
		list.append(("-------------- Dual Emu -------------", "", "dual", "46"))
		list.append(("Start Dual Emu", "dual", "dual", "46"))
		list.append(("------------- Emu Watchdog ----------", "", "dual", "46"))
		list.append(("Watchdog Einschalten", "watchon", "dual", "46"))
		list.append(("Watchdog Ausschalten", "watchoff", "dual", "46"))
		
		Screen.__init__(self, session)
		self["EMU"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["EMU"].getCurrent()
		if selection is not None:
			if selection[1] == "stop":
				self.prombt("/var/config/emu/stop-emu.sh")

			elif selection[1] == "mgstart":
				self.prombt("/var/config/emu/start-mgcamd.sh; echo 1 > /var/emu/emudual")	

			elif selection[1] == "oscam":
				self.prombt("/var/config/emu/start-oscam.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "vizcam":
				self.prombt("/var/config/emu/start-vizcam.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "mbox":
				self.prombt("/var/config/emu/start-mbox.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "incubus":
				self.prombt("/var/config/emu/start-incubus.sh; echo 1 > /var/emu/emudual.sh")

			elif selection[1] == "camd3":
				self.prombt("/var/config/emu/start-camd3.sh; echo 1 > /var/emu/emudual")

			elif selection[1] == "dual":
				self.session.open(EMUDUAL)

			elif selection[1] == "watchon":
				os.system("echo on > /var/config/emu-watchdog; /var/config/emu/emu-watchdog.sh &")
				self.session.open(MessageBox,_("Emu Watchdog Aktiviert"), MessageBox.TYPE_INFO)

			elif selection[1] == "watchoff":
				os.system("echo off > /var/config/emu-watchdog; killall -9 emu-watchdog.sh")
				self.session.open(MessageBox,_("Emu Watchdog Deaktiviert"), MessageBox.TYPE_INFO)

			else:
				print "\n[EMU] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("EMU Menu: %s") % (com), ["%s" % com])

	def cancel(self):
		print "\n[EMU] cancel\n"
		self.close(None)

class EMUDUAL(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="Emu Dual Menu" >
			<widget name="EMUDUAL" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("Stoppt laufenden Emu", "stop", "dual", "46"))
		list.append(("Start oder Restart Mg-Camd", "mgstart2", "dual", "46"))
		list.append(("Start oder Restart MBox", "mbox2", "dual", "46"))
		list.append(("Start oder Restart Incubus", "incubus2", "dual", "46"))
		list.append(("Start oder Restart Camd3", "camd32", "dual", "46"))
		
		Screen.__init__(self, session)
		self["EMUDUAL"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["EMUDUAL"].getCurrent()
		if selection is not None:
			if selection[1] == "stop":
				self.prombt("/var/config/emu/stop-emu.sh")

			elif selection[1] == "mgstart2":
				self.prombt("/var/config/emu/start-mgcamd2.sh; echo 2 > /var/emu/emudual")	

			elif selection[1] == "mbox2":
				self.prombt("/var/config/emu/start-mbox2.sh; echo 2 > /var/emu/emudual")

			elif selection[1] == "incubus2":
				self.prombt("/var/config/emu/start-incubus2.sh; echo 2 > /var/emu/emudual.sh")


			elif selection[1] == "camd32":
				self.prombt("/var/config/emu/start-camd32.sh; echo 2 > /var/emu/emudual")


			else:
				print "\n[EMUDUAL] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("EMU Dual Menu: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[EMUDUAL] cancel\n"
		self.close(None)