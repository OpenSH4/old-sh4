#
# Makefile to build NEUTRINO
#
$(targetprefix)/var/etc/.version:
	echo "imagename=Neutrino" > $@
	echo "homepage=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "creator=`id -un`" >> $@
	echo "docs=http://gitorious.org/open-duckbox-project-sh4/pages/Home" >> $@
	echo "forum=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "version=0200`date +%Y%m%d%H%M`" >> $@
	echo "git=`git describe`" >> $@

#
#
#
N_CPPFLAGS = -I$(driverdir)/bpamem

if BOXTYPE_SPARK
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

if BOXTYPE_SPARK7162
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

if BOXTYPE_HL101
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

if BOXTYPE_TF7700
N_CPPFLAGS += -I$(driverdir)/frontcontroller/tffp
endif

N_CONFIG_OPTS = --enable-silent-rules --enable-freesatepg
N_CONFIG_SILENT = --enable-silent-rules
N_CONFIG_FREESAT = --enable-freesatepg
N_CONFIG_GRAPHLCD = 

if ENABLE_EXTERNALLCD
N_CONFIG_OPTS += --enable-graphlcd
N_CONFIG_GRAPHLCD += --enable-graphlcd
endif

#
# LIBSTB-HAL
#
$(DEPDIR)/libstb-hal.do_prepare:
	rm -rf $(appsdir)/libstb-hal
	rm -rf $(appsdir)/libstb-hal.org
	[ -d "$(archivedir)/libstb-hal.git" ] && \
	(cd $(archivedir)/libstb-hal.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal.git" ] || \
	git clone git://gitorious.org/~max10/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal.git; \
	cp -ra $(archivedir)/libstb-hal.git $(appsdir)/libstb-hal;\
	cp -ra $(appsdir)/libstb-hal $(appsdir)/libstb-hal.org
	touch $@

$(appsdir)/libstb-hal/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/libstb-hal && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal.do_compile: $(appsdir)/libstb-hal/config.status
	cd $(appsdir)/libstb-hal && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal: libstb-hal.do_prepare libstb-hal.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-clean:
	rm -f $(DEPDIR)/libstb-hal
	cd $(appsdir)/libstb-hal && \
		$(MAKE) distclean

libstb-hal-distclean:
	rm -f $(DEPDIR)/libstb-hal*

#
# LIBSTB-HAL-EXP
#
$(DEPDIR)/libstb-hal-exp.do_prepare:
	rm -rf $(appsdir)/libstb-hal-exp
	rm -rf $(appsdir)/libstb-hal-exp.org
	[ -d "$(archivedir)/libstb-hal-exp.git" ] && \
	(cd $(archivedir)/libstb-hal-exp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal-exp.git" ] || \
	git clone -b experimental git://gitorious.org/~max10/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal-exp.git; \
	cp -ra $(archivedir)/libstb-hal-exp.git $(appsdir)/libstb-hal-exp;\
	cp -ra $(appsdir)/libstb-hal-exp $(appsdir)/libstb-hal-exp.org
	touch $@

$(appsdir)/libstb-hal-exp/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/libstb-hal-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal-exp.do_compile: $(appsdir)/libstb-hal-exp/config.status
	cd $(appsdir)/libstb-hal-exp && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal-exp: libstb-hal-exp.do_prepare libstb-hal-exp.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal-exp install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-exp-clean:
	rm -f $(DEPDIR)/libstb-hal-exp
	cd $(appsdir)/libstb-hal-exp && \
		$(MAKE) distclean

libstb-hal-exp-distclean:
	rm -f $(DEPDIR)/libstb-hal-exp*

#
# NEUTRINO MP
#
$(DEPDIR)/neutrino-mp.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec libboost openssl libopenthreads libusb2 libalsa libstb-hal
	rm -rf $(appsdir)/neutrino-mp
	rm -rf $(appsdir)/neutrino-mp.org
	[ -d "$(archivedir)/neutrino-mp.git" ] && \
	(cd $(archivedir)/neutrino-mp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp.git" ] || \
	git clone git://gitorious.org/~max10/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp.git; \
	cp -ra $(archivedir)/neutrino-mp.git $(appsdir)/neutrino-mp; \
	cp -ra $(appsdir)/neutrino-mp $(appsdir)/neutrino-mp.org
	touch $@

$(appsdir)/neutrino-mp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp.do_compile: $(appsdir)/neutrino-mp/config.status
	cd $(appsdir)/neutrino-mp && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp: neutrino-mp.do_prepare neutrino-mp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-clean:
	rm -f $(DEPDIR)/neutrino-mp
	cd $(appsdir)/neutrino-mp && \
		$(MAKE) distclean

neutrino-mp-distclean:
	rm -f $(DEPDIR)/neutrino-mp*

neutrino-mp-updateyaud: neutrino-mp-clean neutrino-mp
	mkdir -p $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	mkdir -p $(prefix)/release_neutrino/usr/local/sbin
	cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_neutrino/usr/local/sbin/

#
# NEUTRINO MP EXP
#
$(DEPDIR)/neutrino-mp-exp.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec libboost openssl libopenthreads libusb2 libalsa libstb-hal-exp
	rm -rf $(appsdir)/neutrino-mp-exp
	rm -rf $(appsdir)/neutrino-mp-exp.org
	[ -d "$(archivedir)/neutrino-mp-exp.git" ] && \
	(cd $(archivedir)/neutrino-mp-exp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp-exp.git" ] || \
	git clone -b experimental git://gitorious.org/~max10/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp-exp.git; \
	cp -ra $(archivedir)/neutrino-mp-exp.git $(appsdir)/neutrino-mp-exp; \
	cp -ra $(appsdir)/neutrino-mp-exp $(appsdir)/neutrino-mp-exp.org
	touch $@

$(appsdir)/neutrino-mp-exp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal-exp/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal-exp \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp-exp.do_compile: $(appsdir)/neutrino-mp-exp/config.status
	cd $(appsdir)/neutrino-mp-exp && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp-exp: neutrino-mp-exp.do_prepare neutrino-mp-exp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp-exp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-exp-clean:
	rm -f $(DEPDIR)/neutrino-mp-exp
	cd $(appsdir)/neutrino-mp-exp && \
		$(MAKE) distclean

neutrino-mp-exp-distclean:
	rm -f $(DEPDIR)/neutrino-mp-exp*

neutrino-mp-exp-updateyaud: neutrino-mp-exp-clean neutrino-mp-exp
	mkdir -p $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	mkdir -p $(prefix)/release_neutrino/usr/local/sbin
	cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_neutrino/usr/local/sbin/

#
# NEUTRINO TWIN
#
$(DEPDIR)/neutrino-twin.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libgif_current libid3tag libcurl libmad libvorbisidec libboost openssl libopenthreads libusb2 libalsa libstb-hal
	rm -rf $(appsdir)/neutrino-twin
	rm -rf $(appsdir)/neutrino-twin.org
	[ -d "$(archivedir)/cst-public-gui-neutrino.git" ] && \
	(cd $(archivedir)/cst-public-gui-neutrino.git; git pull ; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/cst-public-gui-neutrino.git" ] || \
	git clone git://c00lstreamtech.de/cst-public-gui-neutrino.git $(archivedir)/cst-public-gui-neutrino.git; \
	cp -ra $(archivedir)/cst-public-gui-neutrino.git $(appsdir)/neutrino-twin; \
	(cd $(appsdir)/neutrino-twin; git checkout --track -b dvbsi++ origin/dvbsi++; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/neutrino-twin $(appsdir)/neutrino-twin.org
	cd $(appsdir)/neutrino-twin && patch -p1 < "$(buildprefix)/Patches/neutrino-twin.diff"
	touch $@

$(appsdir)/neutrino-twin/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-twin && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--enable-giflib \
			--enable-fb_blit \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS) -DFB_BLIT"

$(DEPDIR)/neutrino-twin.do_compile: $(appsdir)/neutrino-twin/config.status
	cd $(appsdir)/neutrino-twin && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-twin: neutrino-twin.do_prepare neutrino-twin.do_compile
	$(MAKE) -C $(appsdir)/neutrino-twin install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-twin-clean:
	rm -f $(DEPDIR)/neutrino-twin
	cd $(appsdir)/neutrino-twin && \
		$(MAKE) distclean

neutrino-twin-distclean:
	rm -f $(DEPDIR)/neutrino-twin*

#
# neutrino-hd2-exp branch
#
#
$(DEPDIR)/neutrino-hd2-exp.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libfreetype libjpeg libpng libgif libid3tag libcurl libmad libvorbisidec libboost libflac openssl libdvbsipp openssl libusb2 libalsa libungif
	clear; \
	echo ""; \
	echo "Choose between the following revisions:"; \
	echo "========================================================================================================"; \
	echo " 0) Newest		- NHD2 libplayer3    			(Can fail due to outdated patch)"; \
	echo " 1) Newest (TeamCS)	- NHD2 libplayer3 + TeamCS-Menu   	(Can fail due to outdated patch)"; \
	echo " 2) inactive"; \
	echo " 3) Sun,  06 Sep 2013	- NHD2 libplayer3 + TeamCS-Menu		(SVN 1622)"; \
	echo "========================================================================================================"; \
	echo "Media Framwork : $(MEDIAFW) (MediaFW will always be libeplayer3 for NHD2)"; \
	echo "External LCD   : $(EXTERNALLCD)"; \
	read -p "Select         : "; \
	[ "$$REPLY" == "0" ] && NHDselect=0; \
	[ "$$REPLY" == "1" ] && NHDselect=1; \
	[ "$$REPLY" == "2" ] && NHDselect=2; \
	[ "$$REPLY" == "3" ] && NHDselect=3 && REVISION=1622; \
	echo "Revision       : "$$REVISION; \
	echo "";\
	rm -rf $(appsdir)/neutrino-hd2-exp; \
	rm -rf $(appsdir)/neutrino-hd2-exp.org; \ 
	if [ $$NHDselect == 0 ]; then \
		[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] && \
		(cd $(archivedir)/neutrino-hd2-exp.svn; svn up ; cd "$(buildprefix)";); \
		[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] || \
		svn co http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(archivedir)/neutrino-hd2-exp.svn; \
		cp -ra $(archivedir)/neutrino-hd2-exp.svn $(appsdir)/neutrino-hd2-exp; \
		cp -ra $(appsdir)/neutrino-hd2-exp $(appsdir)/neutrino-hd2-exp.org; \
		$(if $(HL101)$(VIP1v2)$(VIP2v1),cd $(appsdir)/neutrino-hd2-exp && \ 
		patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp-newest.diff";) \
                $(if $(TF7700),cd $(appsdir)/neutrino-hd2-exp && \
		patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp-newest-tf7700.diff";) \
		cp -f $(buildprefix)/root/svn_version.h $(appsdir)/neutrino-hd2-exp/src/gui/ ;\
		echo done && sleep 3 && cd $(buildprefix) && \
		touch $@; \
	elif [ $$NHDselect == 1 ]; then \
		[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] && \
		(cd $(archivedir)/neutrino-hd2-exp.svn; svn up ; cd "$(buildprefix)";); \
		[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] || \
		svn co http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(archivedir)/neutrino-hd2-exp.svn; \
		cp -ra $(archivedir)/neutrino-hd2-exp.svn $(appsdir)/neutrino-hd2-exp; \
		cp -ra $(appsdir)/neutrino-hd2-exp $(appsdir)/neutrino-hd2-exp.org; \
		$(if $(HL101)$(VIP1v2)$(VIP2v1),cd $(appsdir)/neutrino-hd2-exp && \
		patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp-newest.diff";) \
		$(if $(TF7700),cd $(appsdir)/neutrino-hd2-exp && \
		patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp-newest-tf7700.diff";) \
		cp -f $(buildprefix)/root/svn_version.h $(appsdir)/neutrino-hd2-exp/src/gui/ ;\
		cd $(appsdir)/neutrino-hd2-exp && patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp-teamcs.diff" && \
		cp -rf $(buildprefix)/Patches/TeamCS/* $(appsdir)/neutrino-hd2-exp/ && \
		echo done && sleep 3 && cd $(buildprefix) && \
		touch $@; \
	elif [ $$NHDselect == 3 ]; then \
		rm -rf $(archivedir)/neutrino-hd2-exp.svn; \
		[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] && \
		(cd $(archivedir)/neutrino-hd2-exp.svn; svn up ; cd "$(buildprefix)";); \
		[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] || \
		svn co -r$$REVISION  http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(archivedir)/neutrino-hd2-exp.svn; \
		cp -ra $(archivedir)/neutrino-hd2-exp.svn $(appsdir)/neutrino-hd2-exp; \
		cp -ra $(appsdir)/neutrino-hd2-exp $(appsdir)/neutrino-hd2-exp.org; \
		$(if $(HL101)$(VIP1v2)$(VIP2v1),cd $(appsdir)/neutrino-hd2-exp && \
                patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp.diff";) \
                $(if $(TF7700),cd $(appsdir)/neutrino-hd2-exp && \
                patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp--tf7700.diff";) \
		cp -f $(buildprefix)/root/svn_version.h $(appsdir)/neutrino-hd2-exp/src/gui/ ;\
		cd $(appsdir)/neutrino-hd2-exp && patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp-teamcs.diff" && \
		cp -rf $(buildprefix)/Patches/TeamCS/* $(appsdir)/neutrino-hd2-exp/ && \
		echo done && sleep 3 && cd $(buildprefix) && \
		touch $@; \
	fi


if ENABLE_HL101
NHD2_BOXTYPE = vip
else
if ENABLE_VIP1_V2
NHD2_BOXTYPE = vip
else
if ENABLE_VIP2_V1
NHD2_BOXTYPE = vip
else
if ENABLE_CLASSIC
NHD2_BOXTYPE = vip
else
if ENABLE_TF7700
NHD2_BOXTYPE = topfield
else
NHD2_BOXTYPE = $(BOXTYPE)
endif
endif
endif
endif
endif

$(appsdir)/neutrino-hd2-exp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-hd2-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_SILENT) \
			$(N_CONFIG_FREESAT) \
			$(N_CONFIG_GRAPHLCD) \
			--enable-radiotext \
			--with-boxtype=$(NHD2_BOXTYPE) \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--enable-libeplayer3 \
			--enable-scart \
			--enable-ci \
			--enable-standalonepluigns \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-hd2-exp: neutrino-hd2-exp.do_prepare neutrino-hd2-exp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-hd2-exp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

$(DEPDIR)/neutrino-hd2-exp.do_compile: $(appsdir)/neutrino-hd2-exp/config.status
	cd $(appsdir)/neutrino-hd2-exp && \
		$(MAKE) all
	touch $@

neutrino-hd2-exp-clean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	cd $(appsdir)/neutrino-hd2-exp && \
		$(MAKE) clean

neutrino-hd2-exp-distclean:
	rm -f $(DEPDIR)/neutrino-hd2-exp*

#
#NORMAL
#
$(appsdir)/neutrino/config.status: bootstrap $(EXTERNALLCD_DEP) libfreetype libpng libid3tag openssl libcurl libmad libboost libgif
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--without-libsdl \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/local/share \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/usr/local/share/config \
			--with-gamesdir=/usr/local/share/games \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/neutrino.do_prepare:
	touch $@

$(DEPDIR)/neutrino.do_compile: $(appsdir)/neutrino/config.status
	cd $(appsdir)/neutrino && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino: neutrino.do_prepare neutrino.do_compile
	$(MAKE) -C $(appsdir)/neutrino install DESTDIR=$(targetprefix) DATADIR=$(targetprefix)/usr/local/share/
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-clean neutrino-distclean:
	rm -f $(DEPDIR)/neutrino
	rm -f $(DEPDIR)/neutrino.do_compile
	rm -f $(DEPDIR)/neutrino.do_prepare
	cd $(appsdir)/neutrino && \
		$(MAKE) distclean

