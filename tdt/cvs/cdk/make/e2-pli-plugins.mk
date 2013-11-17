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
	while read line; do plugin="$$line"; \
	$(MAKE) -C $(appsdir)/e2-pli-plugins/$$plugin install DESTDIR=$(prefix)/e2-pli-plugins/$$plugin; \
	done <$(buildprefix)/make/_Plugin-Script/plugins.list
#	Und jetzt Mundgerecht für den Addonmanager
	mkdir -p $(prefix)/e2-pli-plugins/_Addon-Manager_
	while read line; do plugin="$$line"; \
	cd $(prefix)/e2-pli-plugins/$$plugin && \
	tar --format=oldgnu -czf $(prefix)/e2-pli-plugins/_Addon-Manager_/$$plugin.tar.gz *; \
	echo "Erstelle Archiv fuer $$plugin"; \
	done <$(buildprefix)/make/_Plugin-Script/plugins.list
	touch $@

e2-pli-plugins-clean:
	rm -f $(DEPDIR)/e2-pli-plugins
	rm -f $(DEPDIR)/e2-pli-plugins.do_compile

e2-pli-plugins-distclean: e2-pli-plugins-clean
	rm -f $(DEPDIR)/e2-pli-plugins.do_prepare
	rm -rf $(appsdir)/e2-pli-plugins

