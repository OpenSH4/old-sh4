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

#include "teamcsnand.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsnand::teamcsnand()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsnand::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcsnand = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsnand->addItem(GenericMenuBack);
        teamcsnand->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

	  teamcsnand->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSNAND_NANDE2, true, "", this, "nande2", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsnand->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSNAND_NANDBACK, true, "", this, "nandback", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsnand->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSNAND_NANDVIP1, true, "", this, "vnandvip1", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsnand->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSNAND_NANDVIP2, true, "", this, "nandvip2", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcsnand->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSNAND_NANDOPTIRB, true, "", this, "nandoptirb", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsnand->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSNAND_NANDOPTIST, true, "", this, "nandoptist", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

      teamcsnand->exec (NULL, "");
      teamcsnand->hide ();
      delete teamcsnand;

      
   }
   else if (actionKey == "nande2")
   {
		ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Flashing...Bitte warten, kann bis zu 20min dauern\nBeliebige Taste zum Starten drücken!\n\nFlashing... Please wait, this can take 20min\nPress any key to start!",50,1800);
        cprompt = popen("/var/config/system/mtd/mtd1-jffs2.sh", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

   }
   else if (actionKey == "nandback")
   {
		ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Flashing...Bitte warten, kann bis zu 20min dauern\nBeliebige Taste zum Starten drücken!\n\nFlashing... Please wait, this can take 20min\nPress any key to start!",50,1800);
        cprompt = popen("/var/config/system/mtd/mtd1-jffs2-backup.sh", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

   }
      else if (actionKey == "vnandvip1")
   {
		ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Flashing...Bitte warten, kann bis zu 20min dauern\nBeliebige Taste zum Starten drücken!\n\nFlashing... Please wait, this can take 20min\nPress any key to start!",50,1800);
        cprompt = popen("/var/config/system/mtd/mtd3-vip1.sh", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

   }
      else if (actionKey == "nandvip2")
   {
		ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Flashing...Bitte warten, kann bis zu 20min dauern\nBeliebige Taste zum Starten drücken!\n\nFlashing... Please wait, this can take 20min\nPress any key to start!",50,1800);
        cprompt = popen("/var/config/system/mtd/mtd3-vip2.sh", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

   }
      else if (actionKey == "nandoptirb")
   {
		ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Flashing...Bitte warten, kann bis zu 20min dauern\nBeliebige Taste zum Starten drücken!\n\nFlashing... Please wait, this can take 20min\nPress any key to start!",50,1800);
        cprompt = popen("/var/config/system/mtd/mtd3-opti-rb.sh", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

   }
      else if (actionKey == "nandoptist")
   {
		ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Flashing...Bitte warten, kann bis zu 20min dauern\nBeliebige Taste zum Starten drücken!\n\nFlashing... Please wait, this can take 20min\nPress any key to start!",50,1800);
        cprompt = popen("/var/config/system/mtd/mtd3-opti-st.sh", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

   }
   return res;
}


void teamcsnand::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsnand::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
