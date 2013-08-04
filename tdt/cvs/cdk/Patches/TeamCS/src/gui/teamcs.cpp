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

#include "teamcs.h"
#include "teamcsemu.h"
#include "teamcsuhr.h"
#include "teamcswlan.h"
#include "teamcssystem.h"
#include "teamcstuner.h"
#include "teamcsfb.h"
#include "teamcsupnp.h"
#include "teamcssamba.h"
#include "teamcsswap.h"
#include "teamcsoverclock.h"
#include "teamcsmac.h"
#include "teamcsbackup.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcs::teamcs()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcs::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcs = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
      //teamcs->addItem(GenericMenuSeparator);
      //teamcs->addItem(GenericMenuBack);
      //teamcs->addItem(GenericMenuSeparatorLine);
	teamcs->addItem(GenericMenuBack);
        teamcs->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_EMU, true, "", new teamcsemu(), NULL, CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_ADDON, true, "", this, "addon", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_UHR, true, "", new teamcsuhr(), NULL, CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_WLAN, true, "", new teamcswlan, NULL, CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_SYSTEM, true, "", new teamcssystem(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_TUNER, true, "", new teamcstuner(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_FERNBEDIENUNG, true, "", new teamcsfb(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_UPNP, true, "", new teamcsupnp(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_SAMBA, true, "", new teamcssamba(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_SWAP, true, "", new teamcsswap(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_OVERCLOCK, true, "", new teamcsoverclock(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_MAC, true, "", new teamcsmac(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_BACKUP, true, "", new teamcsbackup(), NULL, CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcs->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCS_ENIGMA, true, "", this, "enigma", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

      teamcs->exec (NULL, "");
      teamcs->hide ();
      delete teamcs;

      
   }
   else if (actionKey == "addon")
   {
      	system("echo Nur innerhalb von Enigma aufrufbar");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Nur innerhalb von Enigma aufrufbar");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "enigma")
   {
        system("echo Enigma2 > /var/config/subsystem; echo switch > /var/config/subswitch");
        CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Enigma2 wird beim naechsten Systemstart ausgefuehrt");
        hintBox->paint();

                while( msg != CRCInput::RC_ok )
                {
                g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
                usleep(5000);
                }
 
        hintBox->hide();
        delete hintBox;
   }

   return res;
}


void teamcs::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcs::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
