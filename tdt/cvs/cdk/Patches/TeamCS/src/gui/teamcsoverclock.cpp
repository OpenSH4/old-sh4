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

#include "teamcsoverclock.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsoverclock::teamcsoverclock()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsoverclock::exec(CMenuTarget* parent, const std::string &actionKey)
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
	ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Das Overclocking geschieht auf eigene Gefahr,\njeder muss selber wissen was er seiner Box Antut,\ngetestet sind diese Einstellungen, dennoch kann\nes sich bei jeder Box anders Verhalten oder Auswirken !",500,1800);

      //Menu aufbauen
      CMenuWidget* teamcsoverclock = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsoverclock->addItem(GenericMenuBack);
        teamcsoverclock->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_BOOTHEAD, true, "", this, "boothead", NULL, NULL , "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_266BOOT, true, "", this, "266boot", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_300BOOT, true, "", this, "300boot", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_333BOOT, true, "", this, "333boot", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_366BOOT, true, "", this, "366boot", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_400BOOT, true, "", this, "400boot", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
        teamcsoverclock->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_FIXHEAD, true, "", this, "fixhead", NULL, NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_300FIX, true, "", this, "300fix", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_333FIX, true, "", this, "333fix", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_366FIX, true, "", this, "366fix", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_400FIX, true, "", this, "400fix", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_266FIX, true, "", this, "266fix", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
	teamcsoverclock->addItem( new CMenuSeparator(CMenuSeparator::LINE) );
      teamcsoverclock->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSOVERCLOCK_TEST, true, "", this, "test", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

      teamcsoverclock->exec (NULL, "");
      teamcsoverclock->hide ();
      delete teamcsoverclock;

      
   }
   else if (actionKey == "266boot")
   {

      	system("echo off > /var/keys/Benutzerdaten/.system/overclock; echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die CPU wird Standart auf 266 Mhz getacktet",50,1800);
    }	
   else if (actionKey == "300boot")
   {

      	system("echo 300on > /var/keys/Benutzerdaten/.system/overclock");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die CPU wird waerend des Booten auf 300 Mhz getacktet",50,1800);
   }
   else if (actionKey == "333boot")
   {

      	system("echo 333on > /var/keys/Benutzerdaten/.system/overclock");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die CPU wird waerend des Booten auf 333 Mhz getacktet",50,1800);
   }
   else if (actionKey == "366boot")
   {

      	system("echo 366on > /var/keys/Benutzerdaten/.system/overclock");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die CPU wird waerend des Booten auf 366 Mhz getacktet",50,1800);
   }
   else if (actionKey == "400boot")
   {

      	system("echo 400on > /var/keys/Benutzerdaten/.system/overclock");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Die CPU wird waerend des Booten auf 400 Mhz getacktet",50,1800);
   }
   else if (actionKey == "300fix")
   {

      	system("echo 300daueron > /var/keys/Benutzerdaten/.system/overclock; echo 25609 > /proc/cpu_frequ/pll0_ndiv_mdiv");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Aktuelle CPU Freq. auf 300 Mhz getacktet und fest gestellt fuer jeden Boot",50,1800);
   }
   else if (actionKey == "333fix")
   {

      	system("echo 333daueron > /var/keys/Benutzerdaten/.system/overclock; echo 9475 > /proc/cpu_frequ/pll0_ndiv_mdiv");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Aktuelle CPU Freq. auf 333 Mhz getacktet und fest gestellt fuer jeden Boot",50,1800);
   }
   else if (actionKey == "366fix")
   {

      	system("echo 366daueron > /var/keys/Benutzerdaten/.system/overclock; echo 31241 > /proc/cpu_frequ/pll0_ndiv_mdiv"); 
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Aktuelle CPU Freq. auf 366 Mhz getacktet und fest gestellt fuer jeden Boot",50,1800);		
   }
   else if (actionKey == "400fix")
   {

      	system("echo 400daueron > /var/keys/Benutzerdaten/.system/overclock; echo 22790 > /proc/cpu_frequ/pll0_ndiv_mdiv");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Aktuelle CPU Freq. auf 400 Mhz getacktet und fest gestellt fuer jeden Boot",50,1800);
   }
   else if (actionKey == "266fix")
   {

      	system("echo daueroff > /var/keys/Benutzerdaten/.system/overclock; echo 15110 > /proc/cpu_frequ/pll0_ndiv_mdiv");
		//ShowHintUTF(LOCALE_MESSAGEBOX_INFO,TEXTINHALT,MENÜBREITE,TIMEOUT[sec]);
        ShowHintUTF(LOCALE_MESSAGEBOX_INFO,"Aktuelle CPU Freq. auf 266 Mhz getacktet und fest gestellt fuer jeden Boot",50,1800);
    }
   else if (actionKey == "test")
   {
        cprompt = popen("cat /proc/cpu_frequ/pll0_ndiv_mdiv", "r");
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


void teamcsoverclock::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsoverclock::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
