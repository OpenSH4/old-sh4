#!/bin/bash

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}

CONFIGPARAM=" \
 --enable-maintainer-mode \
 --prefix=$KATIDIR/tufsbox \
 --with-cvsdir=$KATIDIR/cvs \
 --with-customizationsdir=$KATIDIR/custom \
 --with-flashscriptdir=$KATIDIR/flash \
 --with-archivedir=$HOME/Archive \
 --enable-ccache"

##############################################

echo "
  _______                     _____              _     _         _
 |__   __|                   |  __ \            | |   | |       | |
    | | ___  __ _ _ __ ___   | |  | |_   _  ____| | __| |_  __ _| | ___ ___
    | |/ _ \/ _\` | '_ \` _ \  | |  | | | | |/  __| |/ /| __|/ _\` | |/ _ | __|
    | |  __/ (_| | | | | | | | |__| | |_| |  (__|   < | |_| (_| | |  __|__ \\
    |_|\___|\__,_|_| |_| |_| |_____/ \__,_|\____|_|\_\ \__|\__,_|_|\___|___/

"

##############################################

# config.guess generates different answers for some packages
# Ensure that all packages use the same host by explicitly specifying it.

# First obtain the triplet
AM_VER=`automake --version | awk '{print $NF}' | grep -oEm1 "^[0-9]+.[0-9]+"`
host_alias=`/usr/share/automake-${AM_VER}/config.guess`

# Then undo Suse specific modifications, no harm to other distribution
case `echo ${host_alias} | cut -d '-' -f 1` in
	i?86) VENDOR=pc ;;
	*   ) VENDOR=unknown ;;
esac
host_alias=`echo ${host_alias} | sed -e "s/suse/${VENDOR}/"`

# And add it to the config parameters.
CONFIGPARAM="${CONFIGPARAM} --host=${host_alias} --build=${host_alias}"

##############################################
CONFIGPARAM="$CONFIGPARAM --enable-hl101 --with-boxtype=hl101"
CONFIGPARAM="$CONFIGPARAM --enable-stm24 --enable-p0211"
##############################################

echo -e "\nKernel debug:"
if [ "$3" ]; then
	REPLY="$3"
	echo "Activate debug (y/N)? "
	echo -e "\nSelected option: $REPLY\n"
else
	REPLY=N
	read -p "Activate debug (y/N)? "
fi
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"

##############################################

		cd ../driver/include/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s player2_191 player2
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null

		cd ../driver/
		if [ -L player2 ]; then
			rm player2
		fi
		ln -s player2_191 player2
		echo "export CONFIG_PLAYER_191=y" >> .config
		cd - &>/dev/null

		cd ../driver/stgfb
		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null
		MULTICOM="--enable-multicom324"
		cd ../driver/include/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s ../multicom-3.2.4/include multicom
		cd - &>/dev/null

		cd ../driver/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s multicom-3.2.4 multicom
		echo "export CONFIG_MULTICOM324=y" >> .config
		cd - &>/dev/null

##############################################

# Check this option if you want to use the version of GCC.
#CONFIGPARAM="$CONFIGPARAM --enable-gcc47"

##############################################

CONFIGPARAM="$CONFIGPARAM --enable-player191 --enable-multicom324 --enable-mediafwgstreamer --enable-externallcd"

##############################################
##############################################

echo && \
echo "Performing autogen.sh..." && \
echo "------------------------" && \
./autogen.sh && \
echo && \
echo "Performing configure..." && \
echo "-----------------------" && \
echo && \
./configure $CONFIGPARAM

##############################################
if [ ! -e ../driver/player2/player/frame_parser/gnu/stubs-32.h ]; then
	mkdir ../driver/player2/player/frame_parser/gnu
	echo "" > ../driver/player2/player/frame_parser/gnu/stubs-32.h
fi
echo $CONFIGPARAM >lastChoice
echo " "
echo "----------------------------------------"
echo "Your build enivroment is ready :-)"
echo "Aktiv Settings"
echo "*********************"
echo "Player 191"
echo "Kernel p0211"
echo "Debug=$REPLY"
echo "Multicom324"
echo "GraphLCD"
echo "Framebuffer"
echo "*********************"
echo "Your next step could be:"
echo "----------------------------------------"
echo "make yaud-neutrino-hd2-exp"
echo "make yaud-enigma2-pli-amiko"
echo "make yaud-ducktrick-multiimage"
echo "----------------------------------------"
echo "make yaud-oscam"
echo "----------------------------------------"