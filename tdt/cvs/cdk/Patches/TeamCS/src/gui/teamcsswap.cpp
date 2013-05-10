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

#include "teamcsswap.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsswap::teamcsswap()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsswap::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcsswap = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsswap->addItem(GenericMenuBack);
        teamcsswap->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsswap->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSWAP_DEV, true, "", this, "dev", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsswap->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSWAP_RAM, true, "", this, "ram", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsswap->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSWAP_HDD, true, "", this, "hdd", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
teamcsswap->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
teamcsswap->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsswap->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSWAP_HDDCREATE, true, "", this, "hddcreate", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
teamcsswap->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSSWAP_SDA3, true, "", this, "sda3", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

      teamcsswap->exec (NULL, "");
      teamcsswap->hide ();
      delete teamcsswap;

      
   }
   else if (actionKey == "dev")
   {
      //CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, g_Locale->getText(LOCALE_SERVICEMENU_GETPLUGINS_HINT));

      	system("echo swapdev > /var/config/SWAP");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Swap /dev Eingeschalten");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }	
   else if (actionKey == "ram")
   {

      	system("echo ramzswap > /var/config/SWAP");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "RamZswap Eingeschalten");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "hdd")
   {

        system("echo swapfile > /var/config/SWAP");
        CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Swapfile auf HDD Eingeschalten");
        hintBox->paint();

                while( msg != CRCInput::RC_ok )
                {
                g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
                usleep(5000);
                }

        hintBox->hide();
        delete hintBox;
   }
   else if (actionKey == "hddcreate")
   {

        cprompt = popen("/var/config/swap/swapfile.sh; echo swapfile > /var/config/SWAP", "r");
                while( fgets(ctext, sizeof(ctext), cprompt)!=NULL )
                {
                strcat(cprompthint,ctext);
                }
        pclose(cprompt);

       //ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,cprompthint,50,1800);
   }
   else if (actionKey == "sda3")
   {

        cprompt = popen("/var/config/swap/swapdev.sh; echo swapdev > /var/config/SWAP", "r");
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

void teamcsswap::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsswap::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
