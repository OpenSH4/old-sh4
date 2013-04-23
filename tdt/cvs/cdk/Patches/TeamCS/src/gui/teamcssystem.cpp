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

#include "teamcssystem.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcssystem::teamcssystem()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcssystem::exec(CMenuTarget* parent, const std::string &actionKey)
{
   int res = menu_return::RETURN_REPAINT;
   int shortcutTeamCS = 1;
   FILE *cprompt;
   char ctext[8096];
   char cprompthint[8096]={0};
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
      CMenuWidget* teamcssystem = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcssystem->addItem(GenericMenuBack);
        teamcssystem->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcssystem->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSYSTEM_NETSTAT, true, "", this, "netstat", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcssystem->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSYSTEM_LSMOD, true, "", this, "lsmod", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcssystem->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSYSTEM_FREE, true, "", this, "free", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcssystem->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSYSTEM_IMG, true, "", this, "img", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));

      teamcssystem->exec (NULL, "");
      teamcssystem->hide ();
      delete teamcssystem;

      
   }
   else if (actionKey == "netstat")
   {
      //CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, g_Locale->getText(LOCALE_SERVICEMENU_GETPLUGINS_HINT));

      	cprompt = popen("/bin/netstat", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
		strcat(cprompthint,ctext);
      		}
	pclose(cprompt);

       //ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

      	/*CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, cprompthint);	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;*/
   }	
   else if (actionKey == "lsmod")
   {

        cprompt = popen("/sbin/lsmod", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

       //ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

      	/*CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, cprompthint);	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;*/
   }
   else if (actionKey == "free")
   {

      	cprompt = popen("free", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
		strcat(cprompthint,ctext);
      		}
	pclose(cprompt);

       //ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);

      	/*CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, cprompthint);	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;*/   
   }
   else if (actionKey == "img")
   {

      	cprompt = popen("/var/config/sysversion.sh", "r");
		while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
      		{
		strcat(cprompthint,ctext);
      		}
	pclose(cprompt);
	
	//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
	ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
      	
	/*CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, cprompthint);	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;*/
   }

   return res;
}


void teamcssystem::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcssystem::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
