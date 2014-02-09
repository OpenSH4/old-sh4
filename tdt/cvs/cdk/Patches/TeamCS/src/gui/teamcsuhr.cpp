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

#include "teamcsuhr.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsuhr::teamcsuhr()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsuhr::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcsuhr = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsuhr->addItem(GenericMenuBack);
        teamcsuhr->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_DISPLAYRESET, true, "", this, "displayreset", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_UHRAN, true, "", this, "uhran", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_UHRAUS, true, "", this, "uhraus", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_SOMMER, true, "", this, "sommer", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_WINTER, true, "", this, "winter", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
        teamcsuhr->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
        teamcsuhr->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_AUS_TURNOFF, true, "", this, "aust", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_AUS_TURNOFFDATE, true, "", this, "austd", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_AUS_DATE, true, "", this, "ausd", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsuhr->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUHR_AUS_OFF, true, "", this, "ausoff", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));


      teamcsuhr->exec (NULL, "");
      teamcsuhr->hide ();
      delete teamcsuhr;

      
   }
   else if (actionKey == "displayreset")
   {
      	system("/var/config/tools/display.sh");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Display Reset durchgefuehrt",50,1800);
    }
   else if (actionKey == "uhran")
   {
      	system("echo an > /var/keys/Benutzerdaten/.system/uhr");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Display Uhr Eingeschalten",50,1800);
   }
   else if (actionKey == "uhraus")
   {
      	system("echo aus > /var/keys/Benutzerdaten/.system/uhr");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Display Uhr Ausgeschalten",50,1800);
   }
   else if (actionKey == "sommer")
   {
      	system("echo 2 > /var/keys/Benutzerdaten/.system/timezone");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Sommerzeit Eingestellt",50,1800);
   }
   else if (actionKey == "winter")
   {
      	system("echo 1 > /var/keys/Benutzerdaten/.system/timezone");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Winterzeit Eingestellt",50,1800);
   }
   else if (actionKey == "aust")
   {
      	system("echo OFF > /var/config/mode");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Anzeige von Turn OFF",50,1800);
    }
   else if (actionKey == "austd")
   {
      	system("echo DATEPLUS > /var/config/mode");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Anzeige von Turno OFF und Datum",50,1800);
    }
   else if (actionKey == "ausd")
   {
      	system("echo DATE > /var/config/mode");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Anzeige von Datum",50,1800);
   }
   else if (actionKey == "ausoff")
   {
      	system("echo BLANK > /var/config/mode");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Display Deaktivieren",50,1800);
   }


   return res;
}


void teamcsuhr::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsuhr::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
