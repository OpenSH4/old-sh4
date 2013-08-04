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

#include "teamcsbackup.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsbackup::teamcsbackup()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsbackup::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcsbackup = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsbackup->addItem(GenericMenuBack);
        teamcsbackup->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsbackup->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSBACKUP_CONF_CH_SAVE, true, "", this, "conf_ch_save", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
        teamcsbackup->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsbackup->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSBACKUP_CONF_CH_INSTALL, true, "", this, "conf_ch_install", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsbackup->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsbackup->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSBACKUP_CH_DOWNLOAD, true, "", this, "ch_download", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));



      teamcsbackup->exec (NULL, "");
      teamcsbackup->hide ();
      delete teamcsbackup;

      
   }
   else if (actionKey == "conf_ch_save")
   {

      	cprompt = popen("/var/config/tools/sender_sichern.sh", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
		strcat(cprompthint,ctext);
      		}
	pclose(cprompt);

       //ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "conf_ch_install")
   {

      	cprompt = popen("/var/config/tools/sender_install.sh", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
		strcat(cprompthint,ctext);
      		}
	pclose(cprompt);

       //ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "ch_download")
   {

      	cprompt = popen("/var/config/tools/piloten-settings.sh", "r");
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


void teamcsbackup::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsbackup::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
