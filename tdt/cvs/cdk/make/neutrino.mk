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

if BOXTYPE_HL101
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
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
	echo " 3) Fri,  20 Nov 2013	- NHD2 libplayer3 + TeamCS-Menu		(SVN 1891)"; \
	echo "========================================================================================================"; \
	echo "Media Framwork : $(MEDIAFW) (MediaFW will always be libeplayer3 for NHD2)"; \
	echo "External LCD   : $(EXTERNALLCD)"; \
	read -p "Select         : "; \
	[ "$$REPLY" == "0" ] && NHDselect=0; \
	[ "$$REPLY" == "1" ] && NHDselect=1; \
	[ "$$REPLY" == "2" ] && NHDselect=2; \
	[ "$$REPLY" == "3" ] && NHDselect=3 && REVISION=1891; \
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
NHD2_BOXTYPE = $(BOXTYPE)
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
			--enable-netzkino \
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
