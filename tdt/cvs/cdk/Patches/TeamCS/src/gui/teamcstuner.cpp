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

#include "teamcstuner.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcstuner::teamcstuner()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcstuner::exec(CMenuTarget* parent, const std::string &actionKey)
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
      CMenuWidget* teamcstuner = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcstuner->addItem(GenericMenuBack);
        teamcstuner->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_STTUNER, true, "", this, "sttuner", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_RBTUNER, true, "", this, "rbtuner", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP1_KABEL, true, "", this, "vip1kabel", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP1_DVBT, true, "", this, "vip1dvbt", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP1V2_SHARP, true, "", this, "vip1v2sharp", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP1V2_LGKABEL, true, "", this, "vip1v2lgkabel", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP1V2_DVBTSHARP, true, "", this, "vip1v2dvbtsharp", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP2_SHARP, true, "", this, "vip2sharp", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP2_DVBS2SHARP_LGKABEL, true, "vip2sharplg", this, "vip2sharplg", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP2_KABELLG2, true, "", this, "vip2kabellg2", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP2_LGKABEL_DVBT, true, "", this, "vip2lgkabeldvbt", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));
      teamcstuner->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSTUNER_VIP2_DVBS2SHARP_DVBT, true, "", this, "vip2sharpdvbt", CRCInput::convertDigitToKey(shortcutTeamCS++), NULL, "nix", LOCALE_HELPTEXT_NIX));

      teamcstuner->exec (NULL, "");
      teamcstuner->hide ();
      delete teamcstuner;

      
   }
   else if (actionKey == "sttuner")
   {
      //CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, g_Locale->getText(LOCALE_SERVICEMENU_GETPLUGINS_HINT));

      	system("echo vip > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "OPTI VIP ST-Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }	
   else if (actionKey == "rbtuner")
   {

      	system("echo rbvip > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "OPTI VIP RB-Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip1kabel")
   {

      	system("echo vip1kabel > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "VIP1 LG Kabel-Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;   
   }
   else if (actionKey == "vip1dvbt")
   {

      	system("echo vip1dvbt > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "VIP1 DVB-T-Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip1v2sharp")
   {

      	system("echo vip1v2 > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Sharp VIP1v2 Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip1v2lgkabel")
   {

      	system("echo vip1v2kabel > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "LG VIP1v2 Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip1v2dvbtsharp")
   {

      	system("echo dvbs2dvbt > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Sharp DVB-S2 und DVB-T Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip2sharp")
   {

      	system("echo vip2 > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "VIP2 Sharp Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip2sharplg")
   {

      	system("echo s2lgvip > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Sharp DVB-S2 LG DVB-C Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip2kabellg2")
   {

      	system("echo 2xlgvip > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "2x DVB-C LG Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip2lgkabeldvbt")
   {

      	system("echo lgdvbtvip > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "LG DVB-C und DVB-T Tuner gesetzt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "vip2sharpdvbt")
   {

      	system("echo dvbs2dvbt > /var/keys/Benutzerdaten/.system/tuner");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "Sharp DVB-S2 und DVB-T Tuner gesetzt");	
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


void teamcstuner::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcstuner::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////
