#
#procps_ng
#
$(DEPDIR)/procps_ng.do_prepare: bootstrap @DEPENDS_procps_ng@
	@PREPARE_procps_ng@
	touch $@

$(DEPDIR)/procps_ng.do_compile: $(DEPDIR)/procps_ng.do_prepare
	cd @DIR_procps_ng@ && \
		./autogen.sh && \
		$(BUILDENV) && \
		export ac_cv_func_malloc_0_nonnull=yes && \
		export ac_cv_func_realloc_0_nonnull=yes && \
		patch -p0 < $(buildprefix)/Patches/procps_1.diff && \
			./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-silent-rules \
			--prefix=/ && \
		patch -p0 < $(buildprefix)/Patches/procps_2.diff && \ 
		$(MAKE) all
	touch $@

$(DEPDIR)/procps_ng: \
$(DEPDIR)/%procps_ng: $(DEPDIR)/procps_ng.do_compile
	cd @DIR_procps_ng@ && \
		@INSTALL_procps_ng@
	@DISTCLEANUP_procps_ng@
	[ "x$*" = "x" ] && touch $@ || true

#
#bash
#
$(DEPDIR)/bash.do_prepare: bootstrap @DEPENDS_bash@
	@PREPARE_bash@
	touch $@

$(DEPDIR)/bash.do_compile: $(DEPDIR)/bash.do_prepare
	cd @DIR_bash@ && \
	$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-job-control \
			--prefix=/ && \
		$(MAKE)
	touch $@

$(DEPDIR)/bash: \
$(DEPDIR)/%bash: $(DEPDIR)/bash.do_compile
	cd @DIR_bash@ && \
		@INSTALL_bash@
	@DISTCLEANUP_bash@
	[ "x$*" = "x" ] && touch $@ || true

#
#alsa-utils
#
$(DEPDIR)/alsa_utils.do_prepare: bootstrap @DEPENDS_alsa_utils@
	@PREPARE_alsa_utils@
	touch $@

$(DEPDIR)/alsa_utils.do_compile: $(DEPDIR)/alsa_utils.do_prepare
	cd @DIR_alsa_utils@ && \
	$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-alsatest \
			--prefix=/ && \
		$(MAKE)
	touch $@

$(DEPDIR)/alsa_utils: \
$(DEPDIR)/%alsa_utils: $(DEPDIR)/alsa_utils.do_compile
	cd @DIR_alsa_utils@ && \
		@INSTALL_alsa_utils@
	@DISTCLEANUP_alsa_utils@
	[ "x$*" = "x" ] && touch $@ || true

#
#i2c-tools
#
$(DEPDIR)/i2ctools.do_prepare: bootstrap @DEPENDS_i2ctools@
	@PREPARE_i2ctools@
	touch $@

$(DEPDIR)/i2ctools.do_compile: $(DEPDIR)/i2ctools.do_prepare
	cd @DIR_i2ctools@ && \
	$(BUILDENV) \
		$(MAKE)
	touch $@

$(DEPDIR)/i2ctools: \
$(DEPDIR)/%i2ctools: $(DEPDIR)/i2ctools.do_compile
	cd @DIR_i2ctools@ && \
		@INSTALL_i2ctools@
	@DISTCLEANUP_i2ctools@
	[ "x$*" = "x" ] && touch $@ || true

#
#
#bzip2
#
$(DEPDIR)/bzip2.do_prepare: bootstrap @DEPENDS_bzip2@
	@PREPARE_bzip2@
	touch $@

$(DEPDIR)/bzip2.do_compile: $(DEPDIR)/bzip2.do_prepare
	cd @DIR_bzip2@ && \
		mv Makefile-libbz2_so Makefile && \
		$(MAKE) all CC=$(target)-gcc
	touch $@

$(DEPDIR)/bzip2: \
$(DEPDIR)/%bzip2: $(DEPDIR)/bzip2.do_compile
	cd @DIR_bzip2@ && \
		@INSTALL_bzip2@
	@DISTCLEANUP_bzip2@
	[ "x$*" = "x" ] && touch $@ || true

#
#gzip
#
$(DEPDIR)/gzip.do_prepare: bootstrap @DEPENDS_gzip@
	@PREPARE_gzip@
	touch $@

$(DEPDIR)/gzip.do_compile: $(DEPDIR)/gzip.do_prepare
	cd @DIR_gzip@ && \
	$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/gzip: \
$(DEPDIR)/%gzip: $(DEPDIR)/gzip.do_compile
	cd @DIR_gzip@ && \
		@INSTALL_gzip@
	@DISTCLEANUP_gzip@
	[ "x$*" = "x" ] && touch $@ || true

#
# MODULE-INIT-TOOLS
#
$(DEPDIR)/module_init_tools.do_prepare: bootstrap @DEPENDS_module_init_tools@
	@PREPARE_module_init_tools@
	touch $@

$(DEPDIR)/module_init_tools.do_compile: $(DEPDIR)/module_init_tools.do_prepare
	cd @DIR_module_init_tools@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-builddir \
			--prefix= && \
		$(MAKE)
	touch $@

$(DEPDIR)/module_init_tools: \
$(DEPDIR)/%module_init_tools: $(DEPDIR)/%lsb $(MODULE_INIT_TOOLS:%=root/etc/%) $(DEPDIR)/module_init_tools.do_compile
	cd @DIR_module_init_tools@ && \
		@INSTALL_module_init_tools@
	$(call adapted-etc-files,$(MODULE_INIT_TOOLS_ADAPTED_ETC_FILES))
	$(call initdconfig,module-init-tools)
	@DISTCLEANUP_module_init_tools@
	[ "x$*" = "x" ] && touch $@ || true

#
# GREP
#
$(DEPDIR)/grep.do_prepare: bootstrap @DEPENDS_grep@
	@PREPARE_grep@
	cd @DIR_grep@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch
	touch $@

$(DEPDIR)/grep.do_compile: $(DEPDIR)/grep.do_prepare
	cd @DIR_grep@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-nls \
			--disable-perl-regexp \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/grep: \
$(DEPDIR)/%grep: $(DEPDIR)/grep.do_compile
	cd @DIR_grep@ && \
		@INSTALL_grep@
	@DISTCLEANUP_grep@
	[ "x$*" = "x" ] && touch $@ || true

#
# LSB
#
$(DEPDIR)/lsb.do_prepare: bootstrap @DEPENDS_lsb@
	@PREPARE_lsb@
	touch $@

$(DEPDIR)/lsb.do_compile: $(DEPDIR)/lsb.do_prepare
	touch $@

$(DEPDIR)/lsb: \
$(DEPDIR)/%lsb: $(DEPDIR)/lsb.do_compile
	cd @DIR_lsb@ && \
		@INSTALL_lsb@
	@DISTCLEANUP_lsb@
	[ "x$*" = "x" ] && touch $@ || true

#
# PORTMAP
#
$(DEPDIR)/portmap.do_prepare: bootstrap @DEPENDS_portmap@
	@PREPARE_portmap@
	cd @DIR_portmap@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: S 41 10\n### BEGIN INIT INFO/g' -i debian/init.d
	touch $@

$(DEPDIR)/portmap.do_compile: $(DEPDIR)/portmap.do_prepare
	cd @DIR_portmap@ && \
		$(BUILDENV) \
		$(MAKE)
	touch $@

$(DEPDIR)/portmap: \
$(DEPDIR)/%portmap: $(DEPDIR)/%lsb $(PORTMAP_ADAPTED_ETC_FILES:%=root/etc/%) $(DEPDIR)/portmap.do_compile
	cd @DIR_portmap@ && \
		@INSTALL_portmap@
	$(call adapted-etc-files,$(PORTMAP_ADAPTED_ETC_FILES))
	$(call initdconfig,portmap)
	@DISTCLEANUP_portmap@
	[ "x$*" = "x" ] && touch $@ || true

#
# OPENRDATE
#
$(DEPDIR)/openrdate.do_prepare: bootstrap @DEPENDS_openrdate@
	@PREPARE_openrdate@
	touch $@

$(DEPDIR)/openrdate.do_compile: $(DEPDIR)/openrdate.do_prepare
	cd @DIR_openrdate@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/openrdate: \
$(DEPDIR)/%openrdate: $(OPENRDATE_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(DEPDIR)/openrdate.do_compile
	cd @DIR_openrdate@ && \
		@INSTALL_openrdate@
	( cd root/etc && for i in $(OPENRDATE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in rdate.sh ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	@DISTCLEANUP_openrdate@
	[ "x$*" = "x" ] && touch $@ || true

#
# E2FSPROGS
#
$(DEPDIR)/e2fsprogs.do_prepare: bootstrap @DEPENDS_e2fsprogs@
	@PREPARE_e2fsprogs@
	touch $@

$(DEPDIR)/e2fsprogs.do_compile: $(DEPDIR)/e2fsprogs.do_prepare
	cd @DIR_e2fsprogs@ && \
	ln -sf /bin/true ./ldconfig; \
	CFLAGS="$(TARGET_CFLAGS)" \
	CC=$(target)-gcc \
	RANLIB=$(target)-ranlib \
	PATH=$(buildprefix)/@DIR_e2fsprogs@:$(PATH) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--target=$(target) \
		--prefix=/usr \
		--libdir=/usr/lib \
		--disable-rpath \
		--disable-quota \
		--disable-testio-debug \
		--disable-defrag \
		--disable-nls \
		--enable-elf-shlibs \
		--enable-verbose-makecmds \
		--enable-symlink-install \
		--without-libintl-prefix \
		--without-libiconv-prefix \
		--with-root-prefix="" && \
	$(MAKE) && \
	$(MAKE) -C e2fsck e2fsck.static
	touch $@

$(DEPDIR)/e2fsprogs: $(DEPDIR)/e2fsprogs.do_compile
	cd @DIR_e2fsprogs@ && \
		@INSTALL_e2fsprogs@
	[ "x$*" = "x" ] && ( cd @DIR_e2fsprogs@ && \
		$(MAKE) install install-libs DESTDIR=$(targetprefix) && \
	$(INSTALL) e2fsck/e2fsck.static $(targetprefix)/sbin ) || true
	@DISTCLEANUP_e2fsprogs@
	touch $@

#
# XFSPROGS
#
$(DEPDIR)/xfsprogs.do_prepare: bootstrap $(DEPDIR)/e2fsprogs $(DEPDIR)/libreadline @DEPENDS_xfsprogs@
	@PREPARE_xfsprogs@
	touch $@

$(DEPDIR)/xfsprogs.do_compile: $(DEPDIR)/xfsprogs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_xfsprogs@ && \
		export DEBUG=-DNDEBUG && export OPTIMIZER=-O2 && \
		mv -f aclocal.m4 aclocal.m4.orig && mv Makefile Makefile.sgi || true && chmod 644 Makefile.sgi && \
		aclocal -I m4 -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix= \
			--enable-shared=yes \
			--enable-gettext=yes \
			--enable-readline=yes \
			--enable-editline=no \
			--enable-termcap=yes && \
		cp -p Makefile.sgi Makefile && export top_builddir=`pwd` && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/xfsprogs: \
$(DEPDIR)/%xfsprogs: $(DEPDIR)/xfsprogs.do_compile
	cd @DIR_xfsprogs@ && \
		export top_builddir=`pwd` && \
		@INSTALL_xfsprogs@
	@DISTCLEANUP_xfsprogs@
	[ "x$*" = "x" ] && touch $@ || true

#
# MC
#
$(DEPDIR)/mc.do_prepare: bootstrap glib2 @DEPENDS_mc@
	@PREPARE_mc@
	touch $@

$(DEPDIR)/mc.do_compile: $(DEPDIR)/mc.do_prepare | $(NCURSES_DEV)
	cd @DIR_mc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-gpm-mouse \
			--with-screen=ncurses \
			--without-x && \
		$(MAKE) all
	touch $@

$(DEPDIR)/mc: \
$(DEPDIR)/%mc: %glib2 $(DEPDIR)/mc.do_compile
	cd @DIR_mc@ && \
		@INSTALL_mc@
#		export top_builddir=`pwd` && \
#		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
	@DISTCLEANUP_mc@
	[ "x$*" = "x" ] && touch $@ || true

#
# SDPARM
#
$(DEPDIR)/sdparm.do_prepare: bootstrap @DEPENDS_sdparm@
	@PREPARE_sdparm@
	touch $@

$(DEPDIR)/sdparm.do_compile: $(DEPDIR)/sdparm.do_prepare
	cd @DIR_sdparm@ && \
		export PATH=$(MAKE_PATH) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/sdparm: \
$(DEPDIR)/%sdparm: $(DEPDIR)/sdparm.do_compile
	cd @DIR_sdparm@ && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sdparm@
	@( cd $(prefix)/$*cdkroot/usr/share/man/man8 && \
		gzip -v9 sdparm.8 )
	@DISTCLEANUP_sdparm@
	[ "x$*" = "x" ] && touch $@ || true

#
# SG3_UTILS
#
$(DEPDIR)/sg3_utils.do_prepare: bootstrap @DEPENDS_sg3_utils@
	@PREPARE_sg3_utils@
	touch $@

$(DEPDIR)/sg3_utils.do_compile: $(DEPDIR)/sg3_utils.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sg3_utils@ && \
		$(MAKE) clean || true && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		automake --add-missing --foreign && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/sg3_utils: \
$(DEPDIR)/%sg3_utils: $(DEPDIR)/sg3_utils.do_compile
	cd @DIR_sg3_utils@ && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sg3_utils@
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/sbin && \
	( cd root/etc && for i in $(SG3_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	$(INSTALL) -m755 root/usr/sbin/sg_down.sh $(prefix)/$*cdkroot/usr/sbin
	@DISTCLEANUP_sg3_utils@
	[ "x$*" = "x" ] && touch $@ || true

#
# IPKG
#
$(DEPDIR)/ipkg.do_prepare: bootstrap @DEPENDS_ipkg@
	@PREPARE_ipkg@
	touch $@

$(DEPDIR)/ipkg.do_compile: $(DEPDIR)/ipkg.do_prepare
	cd @DIR_ipkg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/ipkg: \
$(DEPDIR)/%ipkg: $(DEPDIR)/ipkg.do_compile
	cd @DIR_ipkg@ && \
		@INSTALL_ipkg@
	ln -sf ipkg-cl $(prefix)/$*cdkroot/usr/bin/ipkg && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc && $(INSTALL) -m 644 root/etc/ipkg.conf $(prefix)/$*cdkroot/etc && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/ipkg
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/lib/ipkg
	$(INSTALL) -m 644 root/usr/lib/ipkg/status.initial $(prefix)/$*cdkroot/usr/lib/ipkg/status
	@DISTCLEANUP_ipkg@
	[ "x$*" = "x" ] && touch $@ || true

#
# ZD1211
#
CONFIG_ZD1211B :=
$(DEPDIR)/zd1211.do_prepare: bootstrap @DEPENDS_zd1211@
	@PREPARE_zd1211@
	touch $@

$(DEPDIR)/zd1211.do_compile: $(DEPDIR)/zd1211.do_prepare
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			ZD1211B=$(ZD1211B) \
			CROSS_COMPILE=$(target)- ARCH=sh
	touch $@

$(DEPDIR)/zd1211: \
$(DEPDIR)/%zd1211: $(DEPDIR)/zd1211.do_compile
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			BIN_DEST=$(targetprefix)/bin \
			INSTALL_MOD_PATH=$(targetprefix) \
			install
	$(DEPMOD) -ae -b $(targetprefix) -r $(KERNELVERSION)
	@DISTCLEANUP_zd1211@
	[ "x$*" = "x" ] && touch $@ || true

#
# NANO
#
$(DEPDIR)/nano.do_prepare: bootstrap ncurses ncurses-dev @DEPENDS_nano@
	@PREPARE_nano@
	touch $@

$(DEPDIR)/nano.do_compile: $(DEPDIR)/nano.do_prepare
	cd @DIR_nano@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			--enable-tiny \
			--enable-color && \
		$(MAKE)
	touch $@

$(DEPDIR)/nano: \
$(DEPDIR)/%nano: $(DEPDIR)/nano.do_compile
	cd @DIR_nano@ && \
		@INSTALL_nano@
	@DISTCLEANUP_nano@
	[ "x$*" = "x" ] && touch $@ || true

#
# RSYNC
#
$(DEPDIR)/rsync.do_prepare: bootstrap @DEPENDS_rsync@
	@PREPARE_rsync@
	touch $@

$(DEPDIR)/rsync.do_compile: $(DEPDIR)/rsync.do_prepare
	cd @DIR_rsync@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debug \
			--disable-locale && \
		$(MAKE)
	touch $@

$(DEPDIR)/rsync: \
$(DEPDIR)/%rsync: $(DEPDIR)/rsync.do_compile
	cd @DIR_rsync@ && \
		@INSTALL_rsync@
	@DISTCLEANUP_rsync@
	[ "x$*" = "x" ] && touch $@ || true

#
# RFKILL
#
$(DEPDIR)/rfkill.do_prepare: bootstrap @DEPENDS_rfkill@
	@PREPARE_rfkill@
	touch $@

$(DEPDIR)/rfkill.do_compile: $(DEPDIR)/rfkill.do_prepare
	cd @DIR_rfkill@ && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/rfkill: \
$(DEPDIR)/%rfkill: $(DEPDIR)/rfkill.do_compile
	cd @DIR_rfkill@ && \
		@INSTALL_rfkill@
	@DISTCLEANUP_rfkill@
	[ "x$*" = "x" ] && touch $@ || true

#
# LM_SENSORS
#
$(DEPDIR)/lm_sensors.do_prepare: bootstrap @DEPENDS_lm_sensors@
	@PREPARE_lm_sensors@
	touch $@

$(DEPDIR)/lm_sensors.do_compile: $(DEPDIR)/lm_sensors.do_prepare
	cd @DIR_lm_sensors@ && \
		$(MAKE) $(MAKE_OPTS) MACHINE=sh PREFIX=/usr user
	touch $@

$(DEPDIR)/lm_sensors: \
$(DEPDIR)/%lm_sensors: $(DEPDIR)/lm_sensors.do_compile
	cd @DIR_lm_sensors@ && \
		@INSTALL_lm_sensors@ && \
		rm $(prefix)/$*cdkroot/usr/share/man/man8/sensors-detect.8 && \
	@DISTCLEANUP_lm_sensors@
	[ "x$*" = "x" ] && touch $@ || true

#
# I2C-TOOLS
#
$(DEPDIR)/i2c-tools.do_prepare: bootstrap @DEPENDS_i2c-tools@
	@PREPARE_i2c-tools@
	touch $@

$(DEPDIR)/i2c-tools.do_compile: $(DEPDIR)/i2c-tools.do_prepare
	cd @DIR_i2c-tools@ && \
		$(MAKE) $(MAKE_OPTS) MACHINE=sh PREFIX=/usr user
	touch $@

$(DEPDIR)/i2c-tools: \
$(DEPDIR)/%i2c-tools: $(DEPDIR)/i2c-tools.do_compile
	cd @DIR_i2c-tools@ && \
		@INSTALL_i2c-tools@ && \
		rm $(prefix)/$*cdkroot/usr/share/man/man8/sensors-detect.8 && \
	@DISTCLEANUP_i2c-tools@
	[ "x$*" = "x" ] && touch $@ || true

#
# FUSE
#
$(DEPDIR)/fuse.do_prepare: bootstrap libcurl glib2 @DEPENDS_fuse@
	@PREPARE_fuse@
	touch $@

$(DEPDIR)/fuse.do_compile: $(DEPDIR)/fuse.do_prepare
	cd @DIR_fuse@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--with-kernel=$(buildprefix)/$(KERNEL_DIR) \
			--disable-kernel-module \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/fuse: \
$(DEPDIR)/%fuse: %libcurl %glib2 $(DEPDIR)/fuse.do_compile
	cd @DIR_fuse@ && \
		@INSTALL_fuse@
	-rm $(prefix)/$*cdkroot/etc/udev/rules.d/99-fuse.rules
	-rmdir $(prefix)/$*cdkroot/etc/udev/rules.d
	-rmdir $(prefix)/$*cdkroot/etc/udev
	$(LN_SF) sh4-linux-fusermount $(prefix)/$*cdkroot/usr/bin/fusermount
	$(LN_SF) sh4-linux-ulockmgr_server $(prefix)/$*cdkroot/usr/bin/ulockmgr_server
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in fuse ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	@DISTCLEANUP_fuse@
	[ "x$*" = "x" ] && touch $@ || true

#
# CURLFTPFS
#
$(DEPDIR)/curlftpfs.do_prepare: bootstrap fuse @DEPENDS_curlftpfs@
	@PREPARE_curlftpfs@
	touch $@

$(DEPDIR)/curlftpfs.do_compile: $(DEPDIR)/curlftpfs.do_prepare
	cd @DIR_curlftpfs@ && \
		export ac_cv_func_malloc_0_nonnull=yes && \
		export ac_cv_func_realloc_0_nonnull=yes && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/curlftpfs: \
$(DEPDIR)/%curlftpfs: %fuse $(DEPDIR)/curlftpfs.do_compile
	cd @DIR_curlftpfs@ && \
		@INSTALL_curlftpfs@
	@DISTCLEANUP_curlftpfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# FBSET
#
$(DEPDIR)/fbset.do_prepare: bootstrap @DEPENDS_fbset@
	@PREPARE_fbset@
	touch $@

$(DEPDIR)/fbset.do_compile: $(DEPDIR)/fbset.do_prepare
	cd @DIR_fbset@ && \
		make CC="$(target)-gcc -Wall -O2 -I."
	touch $@

$(DEPDIR)/fbset: \
$(DEPDIR)/%fbset: fbset.do_compile
	cd @DIR_fbset@ && \
		@INSTALL_fbset@
	@DISTCLEANUP_fbset@
	[ "x$*" = "x" ] && touch $@ || true

#
# PNGQUANT
#
$(DEPDIR)/pngquant.do_prepare: bootstrap libz libpng @DEPENDS_pngquant@
	@PREPARE_pngquant@
	touch $@

$(DEPDIR)/pngquant.do_compile: $(DEPDIR)/pngquant.do_prepare
	cd @DIR_pngquant@ && \
		$(target)-gcc -O3 -Wall -I. -funroll-loops -fomit-frame-pointer -o pngquant pngquant.c rwpng.c -lpng -lz -lm
	touch $@

$(DEPDIR)/pngquant: \
$(DEPDIR)/%pngquant: $(DEPDIR)/pngquant.do_compile
	cd @DIR_pngquant@ && \
		@INSTALL_pngquant@
	@DISTCLEANUP_pngquant@
	[ "x$*" = "x" ] && touch $@ || true

#
# MPLAYER
#
$(DEPDIR)/mplayer.do_prepare: bootstrap @DEPENDS_mplayer@
	@PREPARE_mplayer@
	touch $@

$(DEPDIR)/mplayer.do_compile: $(DEPDIR)/mplayer.do_prepare
	cd @DIR_mplayer@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-mencoder && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/mplayer: \
$(DEPDIR)/%mplayer: $(DEPDIR)/mplayer.do_compile
	cd @DIR_mplayer@ && \
		@INSTALL_mplayer@
	@DISTCLEANUP_mplayer@
	[ "x$*" = "x" ] && touch $@ || true

#
# MENCODER
#
#$(DEPDIR)/mencoder.do_prepare: bootstrap @DEPENDS_mencoder@
#	@PREPARE_mencoder@
#	touch $@

$(DEPDIR)/mencoder.do_compile: $(DEPDIR)/mplayer.do_prepare
	cd @DIR_mencoder@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-dvdnav \
			--disable-dvdread \
			--disable-dvdread-internal \
			--disable-libdvdcss-internal \
			--disable-libvorbis \
			--disable-mp3lib \
			--disable-liba52 \
			--disable-mad \
			--disable-vcd \
			--disable-ftp \
			--disable-pvr \
			--disable-tv-v4l2 \
			--disable-tv-v4l1 \
			--disable-tv \
			--disable-network \
			--disable-real \
			--disable-xanim \
			--disable-faad-internal \
			--disable-tremor-internal \
			--disable-pnm \
			--disable-ossaudio \
			--disable-tga \
			--disable-v4l2 \
			--disable-fbdev \
			--disable-dvb \
			--disable-mplayer && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/mencoder: \
$(DEPDIR)/%mencoder: $(DEPDIR)/mencoder.do_compile
	cd @DIR_mencoder@ && \
		@INSTALL_mencoder@
	@DISTCLEANUP_mencoder@
	[ "x$*" = "x" ] && touch $@ || true

#
# UTIL-LINUX
#
if STM24
# for stm24, look in contrib-apps-specs.mk
else !STM24
$(DEPDIR)/util-linux.do_prepare: bootstrap @DEPENDS_util_linux@
	@PREPARE_util_linux@
	cd @DIR_util_linux@ && \
		for p in `grep -v "^#" debian/patches/00list` ; do \
			patch -p1 < debian/patches/$$p.dpatch; \
		done; \
		patch -p1 < $(buildprefix)/Patches/util-linux-stm.diff
	touch $@

$(DEPDIR)/util-linux.do_compile: $(DEPDIR)/util-linux.do_prepare
	cd @DIR_util_linux@ && \
		sed -e 's/\ && .\/conftest//g' < configure > configure.new && \
		chmod +x configure.new && mv configure.new configure && \
		$(BUILDENV) \
		./configure && \
		sed 's/CURSESFLAGS=.*/CURSESFLAGS=-DNCH=1/' make_include > make_include.new && \
		mv make_include make_include.bak && \
		mv make_include.new make_include && \
		$(MAKE) ARCH=sh4 HAVE_SLANG=no HAVE_SHADOW=yes HAVE_PAM=no
	touch $@

$(DEPDIR)/util-linux: \
$(DEPDIR)/%util-linux: util-linux.do_compile
	cd @DIR_util_linux@ && \
		install -d $(targetprefix)/sbin && \
		install -m 755 fdisk/sfdisk $(targetprefix)/sbin/
#		@INSTALL_util_linux@
	@DISTCLEANUP_util_linux@
	[ "x$*" = "x" ] && touch $@ || true
endif !STM24

#
# jfsutils
#
$(DEPDIR)/jfsutils.do_prepare: bootstrap @DEPENDS_jfsutils@
	@PREPARE_jfsutils@
	touch $@

$(DEPDIR)/jfsutils.do_compile: $(DEPDIR)/jfsutils.do_prepare
	cd @DIR_jfsutils@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=gcc \
			--target=$(target) \
			--prefix= && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/jfsutils: \
$(DEPDIR)/%jfsutils: $(DEPDIR)/jfsutils.do_compile
	cd @DIR_jfsutils@ && \
		@INSTALL_jfsutils@
	@DISTCLEANUP_jfsutils@
	[ "x$*" = "x" ] && touch $@ || true

#
# opkg
#
$(DEPDIR)/opkg.do_prepare: bootstrap @DEPENDS_opkg@
	@PREPARE_opkg@
	touch $@

$(DEPDIR)/opkg.do_compile: $(DEPDIR)/opkg.do_prepare
	cd @DIR_opkg@ && \
		$(BUILDENV) \
		autoreconf -v --install; \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--with-opkglibdir=/var && \
		$(MAKE) all
	touch $@

$(DEPDIR)/opkg: \
$(DEPDIR)/%opkg: $(DEPDIR)/opkg.do_compile
	cd @DIR_opkg@ && \
		@INSTALL_opkg@
	@DISTCLEANUP_opkg@
	[ "x$*" = "x" ] && touch $@ || true

#
# sysstat
#
$(DEPDIR)/sysstat: bootstrap @DEPENDS_sysstat@
	@PREPARE_sysstat@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sysstat@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--disable-documentation && \
		$(MAKE) && \
		@INSTALL_sysstat@
	@DISTCLEANUP_sysstat@
	@touch $@

#
# hotplug-e2
#
$(DEPDIR)/hotplug_e2.do_prepare: bootstrap @DEPENDS_hotplug_e2@
	@PREPARE_hotplug_e2@
	git clone git://openpli.git.sourceforge.net/gitroot/openpli/hotplug-e2-helper;
	cd @DIR_hotplug_e2@ && patch -p1 < $(buildprefix)/Patches/hotplug-e2-helper-support_fw_upload.patch
	touch $@

$(DEPDIR)/hotplug_e2.do_compile: $(DEPDIR)/hotplug_e2.do_prepare
	cd @DIR_hotplug_e2@ && \
		./autogen.sh &&\
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/hotplug_e2: \
$(DEPDIR)/%hotplug_e2: $(DEPDIR)/hotplug_e2.do_compile
	cd @DIR_hotplug_e2@ && \
		@INSTALL_hotplug_e2@
	@DISTCLEANUP_hotplug_e2@
	[ "x$*" = "x" ] && touch $@ || true

#
# grab
#

$(DEPDIR)/grab.do_prepare: bootstrap libpng libjpeg @DEPENDS_grab@
	@PREPARE_grab@
	git clone git://git.code.sf.net/p/openpli/aio-grab;
	cd aio-grab &&  patch -p1 < $(buildprefix)/Patches/aio-grab-ADD_ST_SUPPORT.patch \
	&& patch -p1 < $(buildprefix)/Patches/aio-grab-ADD_ST_FRAMESYNC_SUPPORT.patch
	touch $@

$(DEPDIR)/grab.do_compile: grab.do_prepare 
	cd aio-grab && \
		autoreconf --install && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
	touch $@

$(DEPDIR)/grab: \
$(DEPDIR)/%grab: $(DEPDIR)/grab.do_compile
	$(MAKE) -C $(buildprefix)/aio-grab install DESTDIR=$(buildprefix)/../../tufsbox/cdkroot/
	cd aio-grab && \
	@DISTCLEANUP_grab@
	rm -rf aio-grab
	rm .deps/grab*
	[ "x$*" = "x" ] && touch $@ || true

#
# autofs
#
$(DEPDIR)/autofs.do_prepare: bootstrap @DEPENDS_autofs@
	@PREPARE_autofs@
	touch $@

$(DEPDIR)/autofs.do_compile: $(DEPDIR)/autofs.do_prepare
	cd @DIR_autofs@ && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all CC=$(target)-gcc STRIP=$(target)-strip
	touch $@

$(DEPDIR)/autofs: \
$(DEPDIR)/%autofs: $(DEPDIR)/autofs.do_compile
	cd @DIR_autofs@ && \
		@INSTALL_autofs@
	@DISTCLEANUP_autofs@
	[ "x$*" = "x" ] && touch $@ || true

#
# imagemagick
#
$(DEPDIR)/imagemagick.do_prepare: bootstrap @DEPENDS_imagemagick@
	@PREPARE_imagemagick@
	touch $@

$(DEPDIR)/imagemagick.do_compile: $(DEPDIR)/imagemagick.do_prepare
	cd @DIR_imagemagick@ && \
	$(BUILDENV) \
	CFLAGS="-O1" \
	PKG_CONFIG=$(hostprefix)/bin/pkg-config \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--without-dps \
		--without-fpx \
		--without-gslib \
		--without-jbig \
		--without-jp2 \
		--without-lcms \
		--without-tiff \
		--without-xml \
		--without-perl \
		--disable-openmp \
		--disable-opencl \
		--without-zlib \
		--enable-shared \
		--enable-static \
		--without-x && \
	$(MAKE) all
	touch $@

$(DEPDIR)/imagemagick: \
$(DEPDIR)/%imagemagick: $(DEPDIR)/imagemagick.do_compile
	cd @DIR_imagemagick@ && \
		@INSTALL_imagemagick@
	@DISTCLEANUP_imagemagick@
	[ "x$*" = "x" ] && touch $@ || true
