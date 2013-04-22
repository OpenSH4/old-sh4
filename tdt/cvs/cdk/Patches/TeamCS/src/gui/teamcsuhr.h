#ifndef __teamcsuhr__
#define __teamcsuhr__

#include <string>
#include <vector>

#include <driver/framebuffer.h>
#include <system/lastchannel.h>
#include <system/setting_helpers.h>

using namespace std;

// unser eigenes Menu wird von CMenuTarget abgeleitet
class teamcsuhr : public CMenuTarget
{
   private:

      CFrameBuffer *frameBuffer;
      int x;
      int y;
      int width;
      int height;
      int hheight,mheight;    // head/menu font height

      void paint();

   public:

      // Konstruktor
      teamcsuhr();

      void hide();
      int exec(CMenuTarget* parent, const std::string & actionKey);
      
};
#endif
