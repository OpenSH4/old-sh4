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

#include "teamcsemu.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsemu::teamcsemu()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsemu::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcsemu = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsemu->addItem(GenericMenuBack);
        teamcsemu->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_EMUSTOP1, true, "", this, "emustop1", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
        teamcsemu->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_MGCAMD1, true, "", this, "mgcamd1", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_OSCAM1, true, "", this, "oscam1", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_VIZCAM1, true, "", this, "vizcam1", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_MBOX1, true, "", this, "mbox1", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_INCUBUS1, true, "", this, "incubus1", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_CAMD31, true, "", this, "camd31", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
        teamcsemu->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
        teamcsemu->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_MGCAMD2, true, "", this, "mgcamd2", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_MBOX2, true, "", this, "mbox2", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_INCUBUS2, true, "", this, "incubus2", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_CAMD32, true, "", this, "camd32", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
        teamcsemu->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
        teamcsemu->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
teamcsemu->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSEMU_KeyUpdate, true, "", this, "keyupdate", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));


      teamcsemu->exec (NULL, "");
      teamcsemu->hide ();
      delete teamcsemu;

      
   }
   else if (actionKey == "emustop1")
   {
      // system("/var/config/emu/stop-emu.sh");
      //CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, g_Locale->getText(LOCALE_SERVICEMENU_GETPLUGINS_HINT));

      	cprompt = popen("/var/config/emu/stop-emu.sh", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }	
   else if (actionKey == "mgcamd1")
   {
      //system("/var/config/emu/start-mgcamd.sh; echo 1 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-mgcamd.sh; echo 1 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "oscam1")
   {
      //system("/var/config/emu/start-oscam.sh; echo 1 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-oscam.sh; echo 1 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);   
   }
   else if (actionKey == "vizcam1")
   {
      //system("/var/config/emu/start-vizcam.sh; echo 1 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-vizcam.sh; echo 1 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "mbox1")
   {
      //system("/var/config/emu/start-mbox.sh; echo 1 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-mbox.sh; echo 1 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "incubus1")
   {
      //system("/var/config/emu/start-incubus.sh; echo 1 > /var/emu/emudual.sh");

      	cprompt = popen("/var/config/emu/start-incubus.sh; echo 1 > /var/emu/emudual.sh", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "camd31")
   {
      //system("/var/config/emu/start-camd3.sh; echo 1 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-camd3.sh; echo 1 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "mgcamd2")
   {
      //system("/var/config/emu/start-mgcamd2.sh; echo 2 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-mgcamd2.sh; echo 2 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "mbox2")
   {
      //system("/var/config/emu/start-mbox2.sh; echo 2 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-mbox2.sh; echo 2 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "incubus2")
   {
      //system("/var/config/emu/start-incubus2.sh; echo 2 > /var/emu/emudual.sh");

      	cprompt = popen("/var/config/emu/start-incubus2.sh; echo 2 > /var/emu/emudual.sh", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "camd32")
   {
      //system("/var/config/emu/start-camd32.sh; echo 2 > /var/emu/emudual");

      	cprompt = popen("/var/config/emu/start-camd32.sh; echo 2 > /var/emu/emudual", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "keyupdate")
   {

        cprompt = popen("/var/config/emu/SoftCam-Update.sh", "r");
 		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
			strcat(cprompthint,ctext);
      		}
		pclose(cprompt);

		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }


   return res;
}


void teamcsemu::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsemu::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
