# tuxbox/enigma2

#if ENABLE_MEDIAFWGSTREAMER
#MEDIAFW = gstreamer
#else
#MEDIAFW = eplayer4
#endif
E_CONFIG_OPTS =

if ENABLE_EXTERNALLCD
E_CONFIG_OPTS += --with-graphlcd
endif

$(DEPDIR)/enigma2-pli-amiko.do_prepare:
	REVISION=""; \
	DIFF="0"; \
	rm -rf $(appsdir)/enigma2-pli-amiko; \
	rm -rf $(appsdir)/enigma2-pli-amiko.org; \
	rm -rf $(appsdir)/enigma2-pli-amiko.newest; \
	rm -rf $(appsdir)/enigma2-pli-amiko.patched; \
	clear; \
	echo "Media Framwork: $(MEDIAFW)"; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) inactive"; \
	echo "2) inactive"; \
	echo "3) inactive"; \
	echo "4) inactive"; \
	echo "5) inactive"; \
	echo "6) inactive"; \
	echo "7) inactive"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="0" && HEAD="last"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "2" ] && DIFF="2" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "3" ] && DIFF="3" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "4" ] && DIFF="4" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "5" ] && DIFF="5" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "6" ] && DIFF="6" && HEAD="" && REVISION=""; \
	echo "Revision: " $$REVISION; \
	[ -d "$(appsdir)/enigma2-pli-amiko" ] && \
	git pull $(appsdir)/enigma2-pli-amiko $$HEAD;\
	[ -d "$(appsdir)/enigma2-pli-amiko" ] || \
	git clone -b $$HEAD git://github.com/technic/amiko-e2-pli.git $(appsdir)/enigma2-pli-amiko; \
	cp -ra $(appsdir)/enigma2-pli-amiko $(appsdir)/enigma2-pli-amiko.newest; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-pli-amiko; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/enigma2-pli-amiko $(appsdir)/enigma2-pli-amiko.org; \
	cd $(appsdir)/enigma2-pli-amiko && patch -p1 < "../../cdk/Patches/enigma2-pli-amiko.$$DIFF.diff"
	cp -ra $(appsdir)/enigma2-pli-amiko $(appsdir)/enigma2-pli-amiko.patched
	touch $@

$(appsdir)/enigma2-pli-amiko/config.status: bootstrap opkg ethtool fontconfig libfreetype libexpat libpng libjpeg lcms \
		libgif libmme_host libmmeimage libfribidi libid3tag libmad libsigc libreadline libdvbsipp \
		python libxml2 libxslt elementtree zope_interface twisted twistedweb2 pyopenssl pythonwifi \
		pilimaging pyusb pycrypto lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 \
		$(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(appsdir)/enigma2-pli-amiko && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			--prefix=/usr \
			--datadir=/usr/local/share \
			--sysconfdir=/etc \
			--with-boxtype=none \
			$(E_CONFIG_OPTS) \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)


$(DEPDIR)/enigma2-pli-amiko.do_compile: $(appsdir)/enigma2-pli-amiko/config.status
	cd $(appsdir)/enigma2-pli-amiko && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-pli-amiko: enigma2-pli-amiko.do_prepare enigma2-pli-amiko.do_compile
	$(MAKE) -C $(appsdir)/enigma2-pli-amiko install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
	fi
	touch $@

enigma2-pli-amiko-clean enigma2-pli-amiko-distclean:
	rm -f $(DEPDIR)/enigma2-pli-amiko
	rm -f $(DEPDIR)/enigma2-pli-amiko.do_compile
	rm -f $(DEPDIR)/enigma2-pli-amiko.do_prepare
	rm -rf $(appsdir)/enigma2-pli-amiko
	rm -rf $(appsdir)/enigma2-pli-amiko.newest
	rm -rf $(appsdir)/enigma2-pli-amiko.org
	rm -rf $(appsdir)/enigma2-pli-amiko.patched

#
# dvb/libdvbsi++
#
$(appsdir)/dvb/libdvbsi++/config.status: bootstrap
	cd $(appsdir)/dvb/libdvbsi++ && $(CONFIGURE) CPPFLAGS="$(CPPFLAGS) -I$(driverdir)/dvb/include"

$(DEPDIR)/libdvbsi++: $(appsdir)/dvb/libdvbsi++/config.status
	$(MAKE) -C $(appsdir)/dvb/libdvbsi++ all install
	touch $@
