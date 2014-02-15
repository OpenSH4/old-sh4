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

#include "teamcsfb.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsfb::teamcsfb()
{
frameBuffer = CFrameBuffer::getInstance();
width = 600;
hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
height = hheight+13*mheight+ 10;

x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsfb::exec(CMenuTarget* parent, const std::string &actionKey)
{
int res = menu_return::RETURN_REPAINT;
int shortcutTeamCS = 1;
FILE *cprompt;
char ctext [4096];
char cprompthint[4096]={0};
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
	CMenuWidget* teamcsfb = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsfb->addItem(GenericMenuBack);
	teamcsfb->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_REMOTEHEAD, true, "", this, "remotehead", NULL, NULL , "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_VIPNEU, true, "", this, "vipneu", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_VIPNEUGRUEN, true, "", this, "vipneugruen", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_VIPALT, true, "", this, "vipalt", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_VIPALTGRUEN, true, "", this, "vipaltgruen", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_OPTI, true, "", this, "opti", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_PINGO, true, "", this, "pingo", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_TECHNOFB, true, "", this, "technofb", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_MCEFB, true, "", this, "mcefb", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_IRHEAD, true, "", this, "irhead", NULL, NULL , "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_STM, true, "", this, "stm", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_MCE2005, true, "", this, "mce2005", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_TECHNO, true, "", this, "techno", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsfb->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
	teamcsfb->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSFB_NEUSTART, true, "", this, "neustart", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	

	teamcsfb->exec (NULL, "");
	teamcsfb->hide ();
	delete teamcsfb;

	
}
else if (actionKey == "vipneu")
{

		system("cp /etc/lircd_neu.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_neu.conf /var/tuxbox/config/keymap.conf; echo vip2 > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB ArgusVIP neu Mode Rot",50,1800);
}	
else if (actionKey == "vipneugruen")
{

		system("cp /etc/lircd_neu_gruen.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml;  rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_neu.conf /var/tuxbox/config/keymap.conf; echo vip2 > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB ArgusVIP neu Mode Gruen",50,1800);
}
else if (actionKey == "vipalt")
{

		system("cp /etc/lircd_alt.conf /etc/lircd.conf; echo alt > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB1.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_volume.conf /var/tuxbox/config/keymap.conf; echo vip1 > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB ArgusVIP alt Mode Rot",50,1800);
}
else if (actionKey == "vipaltgruen")
{

		system("cp /etc/lircd_alt_gruen.conf /etc/lircd.conf; echo alt > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB1.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_volume.conf /var/tuxbox/config/keymap.conf; echo vip1 > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB ArgusVIP alt Mode Gruen",50,1800);
}
else if (actionKey == "opti")
{

		system("cp /etc/lircd_opti.conf /etc/lircd.conf; echo opti > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_Opti.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; cp /var/tuxbox/config/keymap_opti.conf /var/tuxbox/config/keymap.conf; echo opti > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB Opticum",50,1800);
}	
else if (actionKey == "pingo")
{

		system("cp /etc/lircd_pingolux.conf /etc/lircd.conf; echo neu > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_Opti.xml /usr/local/share/enigma2/keymap.xml; rm -f /var/tuxbox/config/keymap.conf; echo Pingolux > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB Pingolux gesetzt",50,1800);
}
else if (actionKey == "mcefb")
{

		system("cp /etc/lircd_mce2005.conf /etc/lircd.conf; echo mce2005 > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo mce2005 > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB MediaCenter gesetzt",50,1800);
}
else if (actionKey == "technofb")
{

		system("cp /etc/lircd_techno.conf /etc/lircd.conf; echo techno > /var/keys/Benutzerdaten/.system/fernbedienung; cp /usr/local/share/enigma2/keymap_FB2.xml /usr/local/share/enigma2/keymap.xml; echo techno > /var/config/boxtype");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FB TechnoTrend gesetzt",50,1800);
}	
else if (actionKey == "techno")
{

		system("echo techno > /var/config/system/remote");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"TechnoTrend USB Treiber Aktiviert - Reboot",50,1800);
}
else if (actionKey == "mce2005")
{

		system("echo mce2005 > /var/config/system/remote");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"MCE USB Treiber Aktiviert - Reboot",50,1800);
}
else if (actionKey == "stm")
{

		system("echo stm > /var/config/system/remote");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"STM Default Treiber Aktiviert - Reboot",50,1800);
}
else if (actionKey == "neustart")
{

		system("/var/config/shutdown/reboot.sh &");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"System wird jetzt neugestartet",50,1800);
}

return res;
}


void teamcsfb::hide()
{
frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsfb::paint()
{
printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
