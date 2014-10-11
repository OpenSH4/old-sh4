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
from Screens.Standby import TryQuitMainloop

def AddOnCategoryComponent(name, png):
	res = [ name ]
	
	res.append(MultiContentEntryText(pos=(140, 5), size=(300, 25), font=0, text=name))
	res.append(MultiContentEntryPixmapAlphaTest(pos=(10, 0), size=(100, 50), png = png))
	
	return res


def AddOnDownloadComponent(plugin, name):
	res = [ plugin ]
	
	res.append(MultiContentEntryText(pos=(140, 5), size=(300, 25), font=0, text=name))
	res.append(MultiContentEntryText(pos=(140, 26), size=(450, 17), font=1, text=plugin.description))

	if plugin.icon is None:
		png = LoadPixmap(resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/icons/plugin.png"))
	else:
		png = plugin.icon

	res.append(MultiContentEntryPixmapAlphaTest(pos=(10, 0), size=(100, 50), png = png))

	if plugin.statusicon is None:
		png1 = LoadPixmap(resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/icons/plugin.png"))
	else:
		png1 = plugin.statusicon

	res.append(MultiContentEntryPixmapAlphaTest(pos=(120, 17), size=(12, 12), png = png1))
	
	return res

class AddOnDescriptor:
	def __init__(self, name = "", what = "", description = "", status = 0, version = "", icon = None, statusicon = None):
		self.name = name
		self.what = what
		self.description = description
		self.status = status
		self.version = version
		if icon is None:
			self.icon = None
		else:
			self.icon = icon
		
		if statusicon is None:
			self.statusicon = None
		else:
			self.statusicon = statusicon

class AddOn:
	def __init__(self, name = "", version = "", description = "", status = 0):
		self.name = name
		self.version = version
		self.description = description
		self.status = status

class MerlinDownloadBrowser(Screen):
	def __init__(self, session, args = None):
		Screen.__init__(self, session)
		
		self.container = eConsoleAppContainer()
		self.container.appClosed.append(self.runFinished)
		self.container.dataAvail.append(self.dataAvail)
		self.onLayoutFinish.append(self.startRun)
		self.onShown.append(self.setWindowTitle)
		
		self.list = []
		self["list"] = PluginList(self.list)
		self.pluginlist = []
		self.expanded = []
		self.addoninstalled = []
		self.found = 0
		self.msgstate = 1
		
		self["text"] = Label(_("Downloading Addon Information. Bitte Warten..."))
		
		self.run = 0

		self.remainingdata = ""

		self["actions"] = ActionMap(["WizardActions"], 
		{

			"ok": self.go,
			"back": self.close,
		})

	def go(self):
		sel = self["list"].l.getCurrentSelection()

		if sel is None:
			return

		if type(sel[0]) is str: # category
			if sel[0] in self.expanded:
				self.expanded.remove(sel[0])
			else:
				self.expanded.append(sel[0])
			self.updateList()
		else:
			if sel[0].status == 0:
				self.session.openWithCallback(self.runInstall, MessageBox, _("Moechtest du folgendes \nAddon Downloaden\n \"%s\"?") % sel[0].name)
			elif sel[0].status == 1:
				self.session.openWithCallback(self.runInstall, MessageBox, _("Moechtest du folgendes \nAddon Loeschen\n \"%s\"?") % sel[0].name)
			elif sel[0].status == 2:
				self.session.openWithCallback(self.runDeleteUpdateCallBack, DialogUpdateDelete, _("Das Addon \"%s\" ist bereits Installiert.\nWas moechten sie nun tun?") % sel[0].name)

	def runInstall(self, val):
		if val:
			if self["list"].l.getCurrentSelection()[0].status != 1:
				self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg install " + self["list"].l.getCurrentSelection()[0].name])
			else:
				self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg remove " + self["list"].l.getCurrentSelection()[0].name])
	
	def runDeleteUpdateCallBack(self, answer):
		print "answer:", answer
		if answer == 1:
			self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg install " + self["list"].l.getCurrentSelection()[0].name])
		elif answer == 0:
			self.session.openWithCallback(self.installFinished, Console, cmdlist = ["opkg remove " + self["list"].l.getCurrentSelection()[0].name])


	def setWindowTitle(self):
		self.setTitle(_("AddOn Browser"))

	def startRun(self):
		print "startRun(self):"
		self["list"].instance.hide()
		self.container.execute("opkg update")

	def installFinished(self):
		# was ist eigentlich passiert? Aktualisiere...
		self["list"].instance.hide()
		try:
			f = open("/usr/lib/opkg/info/"+self["list"].l.getCurrentSelection()[0].name+".control", "r")
			addoncontent = f.read()
			f.close()
		except:
			addoncontent = ""
		name = ""
		version = ""
		description = ""
		addoncontentInfo = addoncontent.split("\n")
		for line in addoncontentInfo:
			if line.startswith("Package: "):
				name = line[9:]
			if line.startswith("Version: "):
				version = line[9:]
			if line.startswith("Description: "):
				description = line[13:]
		if name != "" and version != "":
			for aa in self.pluginlist:
				if aa.name == name:
					if version == self["list"].l.getCurrentSelection()[0].version:
						aa.status = 1
					else:
						aa.status = 2
		else:
			for aa in self.pluginlist:
				if aa.name == self["list"].l.getCurrentSelection()[0].name:
					aa.status = 0
		self.updateList()
		plugins.readPluginList(resolveFilename(SCOPE_PLUGINS))
		self["list"].instance.show()

	def runFinished(self, retval):
		self.remainingdata = ""
		if self.run == 0:
			self.run = 1
			self.container.execute("opkg list-installed")
		elif self.run == 1:
			self.run = 2
			self.container.execute("opkg list")
		elif self.run == 2:
			if len(self.pluginlist) > 0:
				self.updateList()
				self["list"].instance.show()
			else:
				self["text"].setText("Keine Plugins gefunden...\n\nNetzwerk Pruefen ...")

	def dataAvail(self, str):
		#prepend any remaining data from the previous call
		str = self.remainingdata + str
		#split in lines
		lines = str.split('\n')
		#'str' should end with '\n', so when splitting, the last line should be empty. If this is not the case, we received an incomplete line
		if len(lines[-1]):
			#remember this data for next time
			self.remainingdata = lines[-1]
			lines = lines[0:-1]
		else:
			self.remainingdata = ""
		for x in lines:
			plugin = x.split(" - ")
			if len(plugin) >= 2 and self.run == 1:
				self.addoninstalled.append(AddOn(name = plugin[0], version = plugin[1], status = 1))
			elif len(plugin) == 3 and self.run == 2:
				flagStatus = 0 # nicht installiert
				for cb in self.addoninstalled:
					if plugin[0] == cb.name:
						if plugin[1] == cb.version:
							if cb.status != 2:
								flagStatus = 1 # installiert
							else:
								flagStatus = -1 # brauchen wir nicht, da schon als update gekennzeichnet
						else:
							cb.status = 2
							flagStatus = 2 # update
				if flagStatus != -1:
					self.pluginlist.append(AddOn(name = plugin[0], version = plugin[1], description = plugin[2], status = flagStatus))

	def callMsg(self, result):
		if result:
			self.msgstate = 2
			self.session.openWithCallback(self.startRun, Console, cmdlist = ["opkg upgrade"])
		else:
			self.msgstate = 0

	def callMsgReboot(self, result):
		if result:
			self.session.open(TryQuitMainloop, 3)
			#os.system("/var/config/system/gui.sh &")
		else:
			self.msgstate = 0

	def updateList(self):
		self.list = []
		expandableIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/green_plus.png"))
		expandedIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/red_minus.png"))
		verticallineIcon = LoadPixmap(resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/verticalline-plugins.png"))
		installedIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/green.png"))
		notinstalledIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/red.png"))
		updateIcon = LoadPixmap(resolveFilename(SCOPE_PLUGINS, "Extensions/TeamCS/icons/blue.png"))
		self.plugins = {}
		for x in self.pluginlist:
			temp = ""
			temp1 = x.name
			if x.name.startswith('enigma2-skin-') or x.name.startswith('enigma2-cams-') or x.name.startswith('enigma2-configs-') or x.name.startswith('enigma2-picons-'):
				temp = x.name[8:]
			elif x.name.startswith('enigma2-plugin-'):
				temp = x.name[15:]
			elif x.name.startswith('autonews') or x.name.startswith('nfs-kernel-server') or x.name.startswith('ffmpeg') or x.name.startswith('mtd_utils'):
				# uebergibt name ab stelle 0
				temp = x.name[0:]
			else:
				continue
			
			if x.name.startswith('autonews') or x.name.startswith('nfs-kernel-server') or x.name.startswith('ffmpeg') or x.name.startswith('mtd_utils'):
				# macht kein split aber uebergibt den namen um nach updates zu pruefen
				split = temp
			else:
				split = temp.split('-')
			
			if len(split) < 2:
				continue
			if not self.plugins.has_key(split[0]):
				self.plugins[split[0]] = []
			if self.msgstate == 2:
				# stellt frage fuer Gui reboot
				self.msgstate = 0
				self.session.openWithCallback(self.callMsgReboot, MessageBox, _("Updates wurden Installiert\n\nGui Reboot notwendig, jetzt Durchfuehren ?"), MessageBox.TYPE_YESNO)
			if x.status == 0:			
				pngstatus = notinstalledIcon
			elif x.status == 1:
				pngstatus = installedIcon
			elif x.status == 2:
				updatelist = []
				for updatename in self.pluginlist:
					if updatename.status == 2:
						updatelist.append(updatename.name + '\n')
				if self.msgstate == 1:
					self.msgstate = 0
					self.session.openWithCallback(self.callMsg, MessageBox, _("Es sind Updates verfuegbar !!!\nWollen Sie alle Installierten Plugins Updaten\nsofern Updates fuer diese Verfuegbar sind ?\nAnschliessend ist ein Gui Neustart noetig um die Plugins neu zu laden !!!\nUpdatebare Plugins:\n%s" % str(updatelist).split('[')[1].split(']')[0].replace(",","").replace("'","").replace(" ","")), MessageBox.TYPE_YESNO)
				pngstatus = updateIcon
			else:
				pngstatus = None
			# sorgt dafuer das die Plugins nicht in der liste stehen
			if x.name.startswith('autonews') or x.name.startswith('nfs-kernel-server') or x.name.startswith('ffmpeg') or x.name.startswith('mtd_utils'):
				continue
			else:
				self.plugins[split[0]].append((AddOnDescriptor(name = x.name, what = split[0], description = x.description, icon = verticallineIcon, status = x.status, version = x.version, statusicon = pngstatus), split[1]))

		for x in self.plugins.keys():
			if x in self.expanded:
				if x == "a" or x == "n" or x == "f" or x == "m":
					continue
				else:
					self.list.append(AddOnCategoryComponent(x, expandedIcon))
					for plugin in self.plugins[x]:
						self.list.append(AddOnDownloadComponent(plugin[0], plugin[1]))
			else:
				if x == "a" or x == "n" or x == "f" or x == "m":
					continue
				else:
					self.list.append(AddOnCategoryComponent(x, expandableIcon))
		self["list"].l.setList(self.list)

class DialogUpdateDelete(Screen):
	def __init__(self, session, text,):
		Screen.__init__(self, session)
 		self["text"] = Label(text)
		self["Text"] = StaticText(text)
		self.text = text
		self["QuestionPixmap"] = Pixmap()
		self.list = []
		self.list = [ (_("Update Addon"), 0), (_("Delete Addon"), 1) ]
		self["list"] = MenuList(self.list)
		self["actions"] = ActionMap(["MsgBoxActions", "DirectionActions"], 
			{
				"cancel": self.cancel,
				"ok": self.ok,
				"up": self.up,
				"down": self.down,
				"left": self.left,
				"right": self.right,
				"upRepeated": self.up,
				"downRepeated": self.down,
				"leftRepeated": self.left,
				"rightRepeated": self.right
			}, -1)

	def __onShown(self):
		self.onShown.remove(self.__onShown)
	def cancel(self):
		self.close(-1)
	def ok(self):
		self.close(self["list"].getCurrent()[1] == 0)
	def up(self):
		self.move(self["list"].instance.moveUp)
	def down(self):
		self.move(self["list"].instance.moveDown)
	def left(self):
		self.move(self["list"].instance.pageUp)
	def right(self):
		self.move(self["list"].instance.pageDown)
	def move(self, direction):
		self["list"].instance.moveSelection(direction)
	def __repr__(self):
		return str(type(self)) + "(" + self.text + ")"