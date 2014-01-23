#!/bin/sh

echo
echo -e "####################"
echo -e "# nhd2_newest.diff #"
echo -e "####################"

diff -u ../apps/neutrino-hd2-exp.org/src/driver/vfd.cpp ../apps/neutrino-hd2-exp/src/driver/vfd.cpp > nhd2_newest.diff
sleep 1 
echo -e "src/driver/vfd.cpp \t\t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/src/driver/vfd.h ../apps/neutrino-hd2-exp/src/driver/vfd.h >> nhd2_newest.diff 
sleep 1 
echo -e "src/driver/vfd.h \t\t\t --> Created"
cat nhd2_newest.diff | sed 's/\.\.\/apps\///g' | sed 's/neutrino-hd2-exp\.org/neutrino-hd2-exp/g' > nhd2_newest_tmp.diff
sleep 1
mv nhd2_newest_tmp.diff nhd2_newest.diff

echo
echo -e "####################"
echo -e "# nhd2_teamcs.diff #"
echo -e "####################"

diff -u ../apps/neutrino-hd2-exp.org/src/gui/Makefile.am ../apps/neutrino-hd2-exp/src/gui/Makefile.am > nhd2_teamcs.diff 
sleep 1 
echo -e "src/gui/Makefile.am \t\t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/data/locale/deutsch.locale ../apps/neutrino-hd2-exp/data/locale/deutsch.locale >> nhd2_teamcs.diff 
sleep 1 
echo -e "data/locale/deutsch.locale \t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/data/locale/english.locale ../apps/neutrino-hd2-exp/data/locale/english.locale >> nhd2_teamcs.diff 
sleep 1 
echo -e "data/locale/english.locale \t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/src/system/locals.h ../apps/neutrino-hd2-exp/src/system/locals.h >> nhd2_teamcs.diff 
sleep 1 
echo -e "src/system/locals.h \t\t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/src/system/locals_intern.h ../apps/neutrino-hd2-exp/src/system/locals_intern.h >> nhd2_teamcs.diff 
sleep 1 
echo -e "src/system/locals_intern.h \t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/src/neutrino.cpp ../apps/neutrino-hd2-exp/src/neutrino.cpp >> nhd2_teamcs.diff 
sleep 1 
echo -e "src/neutrino.cpp \t\t\t --> Created"
diff -u ../apps/neutrino-hd2-exp.org/src/neutrino_menue.cpp ../apps/neutrino-hd2-exp/src/neutrino_menue.cpp >> nhd2_teamcs.diff 
sleep 1 
echo -e "src/neutrino_menue.cpp \t\t\t --> Created"
cat nhd2_teamcs.diff | sed 's/\.\.\/apps\///g' | sed 's/neutrino-hd2-exp\.org/neutrino-hd2-exp/g' > nhd2_teamcs_tmp.diff
sleep 1
mv nhd2_teamcs_tmp.diff nhd2_teamcs.diff

echo
