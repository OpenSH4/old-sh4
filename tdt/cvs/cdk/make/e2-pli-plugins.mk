$(DEPDIR)/e2-pli-plugins.do_prepare:
	REVISION=""; \
	HEAD="master"; \
	DIFF="0"; \
	REPO="git://github.com/schpuntik/enigma2-plugins-sh4.git"; \
	rm -rf $(appsdir)/e2-pli-plugins; \
	[ -d "$(archivedir)/e2-pli-plugins.git" ] && \
	(cd $(archivedir)/e2-pli-plugins.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/e2-pli-plugins.git" ] || \
	git clone -b $$HEAD $$REPO $(archivedir)/e2-pli-plugins.git; \
	cp -ra $(archivedir)/e2-pli-plugins.git $(appsdir)/e2-pli-plugins; \
	touch $@

$(appsdir)/e2-pli-plugins/config.status: e2-pli-plugins.do_prepare
	cd $(appsdir)/e2-pli-plugins && \
		autoreconf -i -I$(hostprefix)/share/aclocal && \
		sed -e 's|#!/usr/bin/python|#!$(hostprefix)/bin/python|' -i xml2po.py && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--datadir=/usr/share \
			--libdir=/usr/lib \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-sysroot=$(targetprefix) \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS) $(E_CONFIG_OPTS) \
			CXXFLAGS=-I$(targetprefix)/usr/include/enigma2

$(DEPDIR)/e2-pli-plugins.do_compile: $(appsdir)/e2-pli-plugins/config.status
	cd $(appsdir)/e2-pli-plugins && \
		$(MAKE) all
	touch $@

$(DEPDIR)/e2-pli-plugins: e2-pli-plugins.do_prepare e2-pli-plugins.do_compile
	rm -rf $(targetprefix)/../release_e2-pli-plugins
	mkdir -p $(appsdir)/e2-pli-plugins.maked
	$(MAKE) -C $(appsdir)/e2-pli-plugins install DESTDIR=$(appsdir)/e2-pli-plugins.maked
	mkdir -p $(targetprefix)/../release_e2-pli-plugins
	cp -rfP $(appsdir)/e2-pli-plugins.maked/* $(targetprefix)/../release_e2-pli-plugins/
	rm -r $(appsdir)/e2-pli-plugins.maked
	touch $@

e2-pli-plugins-clean:
	rm -f $(DEPDIR)/e2-pli-plugins
	rm -f $(DEPDIR)/e2-pli-plugins.do_compile

e2-pli-plugins-distclean: e2-pli-plugins-clean
	rm -f $(DEPDIR)/e2-pli-plugins.do_prepare
	rm -rf $(appsdir)/e2-pli-plugins

