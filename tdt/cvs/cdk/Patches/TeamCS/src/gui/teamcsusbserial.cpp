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
#include <sys/mount.h>i
#include <string.h>

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

#include "teamcsusbserial.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsusbserial::teamcsusbserial()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsusbserial::exec(CMenuTarget* parent, const std::string &actionKey)
{
   int res = menu_return::RETURN_REPAINT;
   int shortcutTeamCS = 1;
   FILE *cprompt;
   char ctext[20000];
   char cprompthint[20000]={0};
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
      CMenuWidget* teamcsusbserial = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsusbserial->addItem(GenericMenuBack);
        teamcsusbserial->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsusbserial->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUSBSERIAL_USB1, true, "", this, "usb1", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsusbserial->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUSBSERIAL_USB2, true, "", this, "usb2", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsusbserial->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUSBSERIAL_USB4, true, "", this, "usb4", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsusbserial->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUSBSERIAL_USB3, true, "", this, "usb3", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));

      teamcsusbserial->exec (NULL, "");
      teamcsusbserial->hide ();
      delete teamcsusbserial;

      
   }
   else if (actionKey == "usb1")
   {

      	system("echo 1 > /var/keys/Benutzerdaten/.system/serial");

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"FTDI wird geladen, Neustart erforderlich",50,1800);

   }	
   else if (actionKey == "usb2")
   {

      	system("echo 2 > /var/keys/Benutzerdaten/.system/serial");

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"PL2303 wird geladen, Neustart erforderlich",50,1800);

   }	
   else if (actionKey == "usb4")
   {

      	system("echo 4 > /var/keys/Benutzerdaten/.system/serial");

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"PL2303 und FTDI wird geladen, Neustart erforderlich",50,1800);

   }	
   else if (actionKey == "usb3")
   {

      	system("echo 0 > /var/keys/Benutzerdaten/.system/serial");

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Treiber wird nicht geladen, Neustart erforderlich",50,1800);

   }	

   return res;
}


void teamcsusbserial::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsusbserial::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
