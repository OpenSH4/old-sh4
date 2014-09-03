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

echo -e "\nKernel:"
echo "   1) STM 24 P0211 (recommended)"
echo "   2) STM 24 P0215 (experimental)"
#echo "   3) STM 24 P0308 (experimental)"
case $2 in
        [1-3]) REPLY=$2
        echo -e "\nSelected kernel: $REPLY\n"
        ;;
        *)
        read -p "Select kernel (1-3)? ";;
esac

case "$REPLY" in
        1)  KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";PKERNEL=P0211;;
        2)  KERNEL="--enable-stm24 --enable-p0215";STMFB="stm24";PKERNEL=P0215;;
	3)  KERNEL="--enable-stm24 --enable-p0308";STMFB="stm24";PKERNEL=P0308;;
        *)  KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";PKERNEL=P0211;;
esac
CONFIGPARAM="$CONFIGPARAM $KERNEL"

##############################################
CONFIGPARAM="$CONFIGPARAM --enable-hl101 --with-boxtype=hl101"
#CONFIGPARAM="$CONFIGPARAM --enable-stm24 --enable-p0211"
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
echo -e "\nDo you use newer OS? (e.g. Ubunut 14.04)"
if [ "$3" ]; then
        REPLY="$3"
        echo "Activate NewOS (y/N)? "
        echo -e "\nSelected option: $REPLY\n"
else
        REPLY=N
        read -p "Activate NewOS (y/N)? "
fi
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-newos";newos=Yes
##############################################
echo -e "\nGCC-Version:"
echo "   1) GCC 4.6 (recommended)"
echo "   2) GCC 4.7 (experimental)"
echo "   3) GCC 4.8 (experimental & NewOS only)"
case $2 in
        [1-3]) REPLY=$2
        echo -e "\nSelected Version: $REPLY\n"
        ;;
        *)
        read -p "Select Version (1-3)? ";;
esac

case "$REPLY" in
        1)  GCC_VER="";GCC=4.6;;
        2)  GCC_VER="--enable-gcc47";GCC=4.7;;
        3)  GCC_VER="--enable-gcc48";GCC=4.8;;
        *)  GCC_VER="";GCC=4.6;;
esac
CONFIGPARAM="$CONFIGPARAM $GCC_VER"

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
echo "Kernel $PKERNEL"
echo "Debug=$REPLY"
echo "Multicom324"
echo "GraphLCD"
echo "Framebuffer"
echo "GCC=$GCC"
echo "NewOS=$newos"
echo "*********************"
echo "Your next step could be:"
echo "----------------------------------------"
echo "make yaud-neutrino-hd2-exp"
echo "make yaud-enigma2-pli-amiko"
echo "make yaud-ducktrick-multiimage"
echo "----------------------------------------"
echo "make yaud-oscam"
echo "----------------------------------------"
