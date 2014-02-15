#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <dlfcn.h>
#include <sys/mount.h>

#include <global.h>
#include <neutrino.h>
#include <gui/widget/icons.h>
#include "gui/widget/menue.h"
#include "gui/widget/stringinput.h"
#include "gui/widget/messagebox.h"
#include "gui/widget/hintbox.h"
#include "gui/widget/progresswindow.h"

#include "system/setting_helpers.h"
#include "system/settings.h"
#include "system/debug.h"
#include <dvb-ci.h>
#include <sectionsd/edvbstring.h>

#include <driver/encoding.h>
#include <driver/framebuffer.h>
#include <driver/fontrenderer.h>
#include <driver/rcinput.h>
#include <driver/stream2file.h>
#include <driver/vcrcontrol.h>
#include <driver/shutdown_count.h>
#include <driver/screen_max.h>

#include "teamcswlan.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcswlan::teamcswlan()
{
frameBuffer = CFrameBuffer::getInstance();
width = 600;
hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
height = hheight+13*mheight+ 10;

x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcswlan::exec(CMenuTarget* parent, const std::string &actionKey)
{
int res = menu_return::RETURN_REPAINT;
int shortcutTeamCS = 1;
FILE *cprompt;
char ctext [512];
char cprompthint[512]={0};
neutrino_msg_t      msg;
neutrino_msg_data_t data;
unsigned long long TimeoutEnd;

if (parent)
{
	parent->hide();
}
paint();

if (actionKey.empty())
{
	//Menu aufbauen
	CMenuWidget* teamcswlan = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcswlan->addItem(GenericMenuBack);
		teamcswlan->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL1, true, "", this, "8192cu", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL2, true, "", this, "8712u", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL3, true, "", this, "rt2870sta", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL4, true, "", this, "rt3070sta", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL5, true, "", this, "rt5370sta", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL6, true, "", this, "rt73", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL7, true, "", this, "zydas", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_MODUL8, true, "", this, "8188eu", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcswlan->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSWLAN_AUS, true, "", this, "aus", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

	teamcswlan->exec (NULL, "");
	teamcswlan->hide ();
	delete teamcswlan;

	
}
else if (actionKey == "8192cu")
{
		system("echo 1 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul 8192cu.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "8712u")
{
		system("echo 2 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul 8712u.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "rt2870sta")
{
		system("echo 3 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul rt2870sta.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "rt3070sta")
{
		system("echo 4 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul rt3070sta.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "rt5370sta")
{
		system("echo 5 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul rt5370sta.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "rt73")
{
		system("echo 6 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul rt73.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "zydas")
{
		system("echo 7 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul zydas.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "8188eu")
{
		system("echo 8 > /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan Modul 8188eu.ko Geladen, Neustart erforderlich",50,1800);
}
else if (actionKey == "aus")
{
		system("rm -rf /var/keys/Benutzerdaten/.system/wlan");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"W-Lan deaktiviert, Neustart erforderlich",50,1800);
}

return res;
}


void teamcswlan::hide()
{
frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcswlan::paint()
{
printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
