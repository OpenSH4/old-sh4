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

#include "teamcsmac.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsmac::teamcsmac()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsmac::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcsmac = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsmac->addItem(GenericMenuBack);
        teamcsmac->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsmac->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSMAC_MAC1, true, "", this, "mac1", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsmac->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSMAC_MAC2, true, "", this, "mac2", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsmac->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSMAC_MAC3, true, "", this, "mac3", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsmac->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSMAC_MAC4, true, "", this, "mac4", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcsmac->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSMAC_MAC5, true, "", this, "mac5", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

      teamcsmac->exec (NULL, "");
      teamcsmac->hide ();
      delete teamcsmac;

      
   }
   else if (actionKey == "mac1")
   {
      	system("echo 1 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:80:E1:12:06:30");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die neu MAC lautet 00:80:E1:12:06:30",50,1800);
   }	
   else if (actionKey == "mac2")
   {
      	system("echo 2 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:81:E1:12:06:30");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die neu MAC lautet 00:81:E1:12:06:30",50,1800);
   }	
   else if (actionKey == "mac3")
   {
      	system("echo 3 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:82:E1:12:06:30");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die neu MAC lautet 00:82:E1:12:06:30",50,1800);
   }	
   else if (actionKey == "mac4")
   {
      	system("echo 4 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:83:E1:12:06:30");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die neu MAC lautet 00:83:E1:12:06:30",50,1800);
   }	
   else if (actionKey == "mac5")
   {
      	system("echo 5 > /var/keys/Benutzerdaten/.system/mac; ifconfig eth0 hw ether 00:84:E1:12:06:30");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die neu MAC lautet 00:84:E1:12:06:30",50,1800);
   }	


   return res;
}


void teamcsmac::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsmac::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
