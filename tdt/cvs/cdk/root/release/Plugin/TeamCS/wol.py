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

class WOLSET(Screen):
	skin = """
		<screen position="center,center" size="460,400" title="WakeOnLan Menu" >
			<widget name="WOLSET" position="10,10" size="420,380" scrollbarMode="showOnDemand" />
		</screen>"""

	def __init__(self, session):
		Screen.__init__(self, session)
		
		list = []
		list.append(("WakeOnLan AN", "WOLAN", "wol", "46"))
		list.append(("WakeOnLan AUS", "WOLAUS", "wol", "46"))
		list.append(("MAC Adresse", "mac", "wol", "46"))
		list.append(("Port", "WOLMACPORT", "wol", "46"))
		list.append(("Zeit in Sec fuer wiederholung", "WOLTIME", "wol", "46"))
		
		self["WOLSET"] = List(list)
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.go,
			"cancel": self.cancel
		}, -1)

	def go(self):
		print "okbuttonClick"
		selection = self["WOLSET"].getCurrent()
		if selection is not None:
			if selection[1] == "WOLAN":
				os.system("echo an > /var/keys/Benutzerdaten/.system/wol")
				self.session.open(MessageBox,_("WOL Eingeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "WOLAUS":
				os.system("echo aus > /var/keys/Benutzerdaten/.system/wol")
				self.session.open(MessageBox,_("WOL Ausgeschalten"), MessageBox.TYPE_INFO)

			elif selection[1] == "mac":
				self.session.open(MAC)
				
			elif selection[1] == "WOLMACPORT":
				self.session.open(WOLPORT)
				
			elif selection[1] == "WOLTIME":
				self.session.open(WOLTIMESET)

			else:
				print "\n[BENUTZER] cancel\n"
				self.close(None)

	def prombt(self, com):
		self.session.open(Console,_("Configs erstellen: %s") % (com), ["%s" % com])
		
	def cancel(self):
		print "\n[WOLSET] cancel\n"
		self.close(None)
		
############################ MWOLPORT #################################

class WOLTIMESET(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)

		self["WOLTIMESET"] = Label(_("Zeit eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.TIMEimput,
			"cancel": self.cancel
		}, -1)

	def TIMEimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte die Zeit in Sec eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("Zeit Einstellung: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.system/MACTIME; echo Zeit eingestellt" % word])

	def cancel(self):
		print "\n[WOLTIMESET] cancel\n"
		self.close(None)
		
############################ MWOLPORT #################################

class WOLPORT(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)

		self["WOLPORT"] = Label(_("Port eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.PORTimput,
			"cancel": self.cancel
		}, -1)

	def PORTimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte den Port eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("MAC Adresse: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.system/MACPORT; echo Port eingestellt" % word])

	def cancel(self):
		print "\n[WOLPORT] cancel\n"
		self.close(None)
		
############################ MAC#################################

class MAC(Screen):
	def __init__(self, session):
		Screen.__init__(self, session)

		self["MAC"] = Label(_("MAC Adresse eingeben?"))
		self["myActionMap"] = ActionMap(["SetupActions"],
		{
			"ok": self.MACimput,
			"cancel": self.cancel
		}, -1)

	def MACimput(self):
		self.session.openWithCallback(self.askForWord, InputBox, title=_("Bitte die MAC Adresse eingeben!"), text=" " * 55, maxSize=55, type=Input.TEXT)

	def askForWord(self, word):
		if word is None:
			pass
		else:
			self.session.open(Console,_("MAC Adresse: %s") % (word), ["echo %s > /var/keys/Benutzerdaten/.system/MAC; echo MAC eingestellt" % word])

	def cancel(self):
		print "\n[MAC] cancel\n"
		self.close(None)