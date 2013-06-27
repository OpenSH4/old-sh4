kernelpath=linux-sh4

#Trick ALPHA-Version ;)
$(DEPDIR)/Ducktrick-MultiImage: \
$(DEPDIR)/%Ducktrick-MultiImage:
	rm -rf $(prefix)/Ducktrick-MultiImage || true
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/bin && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/sbin && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/swap && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/boot && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/dev && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/dev.static && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/network && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/hdd && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/hdd/music && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/lib && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/lib/modules && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/ram && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/var && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/var/etc && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/var/boot && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/var/lib-misc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/Ducktrick-MultiImage && \
	touch $(prefix)/Ducktrick-MultiImage/var/etc/.firstboot && \
	mkdir -p $(prefix)/Ducktrick-MultiImage/var/plugins && \
	mkdir -p $(prefix)/Ducktrick-MultiImage/var/tuxbox/config && \
	mkdir -p $(prefix)/Ducktrick-MultiImage/usr/local/share && \
	ln -sf /var/tuxbox/config $(prefix)/Ducktrick-MultiImage/usr/local/share/config && \
	mkdir -p $(prefix)/Ducktrick-MultiImage/var/share/icons && \
	cp -a $(targetprefix)/bin/* $(prefix)/Ducktrick-MultiImage/bin/ && \
	ln -s /bin/showiframe $(prefix)/Ducktrick-MultiImage/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	make $(targetprefix)/var/etc/.version && \
	mv $(targetprefix)/var/etc/.version $(prefix)/Ducktrick-MultiImage/ && \
	ln -sf /.version $(prefix)/Ducktrick-MultiImage/var/etc/.version && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/Ducktrick-MultiImage/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/makedev $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -a $(targetprefix)/dev/* $(prefix)/Ducktrick-MultiImage/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/Ducktrick-MultiImage/etc/ && \
	$(if $(UFS910),cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/Ducktrick-MultiImage/etc/ &&) \
	mkdir -p $(prefix)/Ducktrick-MultiImage/var/run/lirc
	cp -dp $(targetprefix)/etc/localtime $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/Ducktrick-MultiImage/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/Ducktrick-MultiImage/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	mkdir -p $(prefix)/Ducktrick-MultiImage/var/tuxbox/config/tuxtxt/ && \
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/Ducktrick-MultiImage/var/tuxbox/config/tuxtxt/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/reboot $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/Ducktrick-MultiImage/bin/ && \
	echo "576i50" > $(prefix)/Ducktrick-MultiImage/etc/videomode && \
	chmod 755 $(prefix)/Ducktrick-MultiImage/etc/init.d/rcS && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/mountvirtfs $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/mme_check $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/mountall $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/hostname $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/vsftpd $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/bootclean.sh $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/networking $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/getfb.awk $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/Ducktrick-MultiImage/boot/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/Ducktrick-MultiImage/lib/ && \
	rm -f $(prefix)/Ducktrick-MultiImage/lib/*.a && \
	rm -f $(prefix)/Ducktrick-MultiImage/lib/*.o && \
	rm -f $(prefix)/Ducktrick-MultiImage/lib/*.la && \
	find $(prefix)/Ducktrick-MultiImage/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
	[ -e $(kernelprefix)/$(kernelpath)/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/autofs4/autofs4.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/ftdi_sio.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/pl2303.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/usbserial.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/fs/cifs/cifs.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/cifs/cifs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/ntfs/ntfs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true

if STM24
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/Ducktrick-MultiImage/sbin/
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/Ducktrick-MultiImage/lib/modules/

	rm -f $(prefix)/Ducktrick-MultiImage/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/Ducktrick-MultiImage/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/Ducktrick-MultiImage/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/Ducktrick-MultiImage/bin/evremote
	rm -f $(prefix)/Ducktrick-MultiImage/bin/gotosleep
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/

if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/Ducktrick-MultiImage/lib/modules/

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/Ducktrick-MultiImage/lib/modules/ || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/Ducktrick-MultiImage/lib/modules/ || true

	find $(prefix)/Ducktrick-MultiImage/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/Ducktrick-MultiImage/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/Ducktrick-MultiImage/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/Ducktrick-MultiImage/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

	rm -rf $(prefix)/Ducktrick-MultiImage/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/media
	ln -s /hdd $(prefix)/Ducktrick-MultiImage/media/hdd
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/media/dvd

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/mnt
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/mnt/usb
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/mnt/hdd
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/mnt/nfs

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/root

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/proc
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/sys
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/tmp

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/bin
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/lib
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/Ducktrick-MultiImage/usr/bin/

	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/Ducktrick-MultiImage/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/Ducktrick-MultiImage/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/Ducktrick-MultiImage/usr/lib/
#######################################################################################

	( cd $(prefix)/Ducktrick-MultiImage/var/share/icons/ && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/Ducktrick-MultiImage/ && ln -s /usr/local/share/neutrino/icons/logo logos )
	( cd $(prefix)/Ducktrick-MultiImage/lib && ln -s libcrypto.so.0.9.7 libcrypto.so.0.9.8 )
	( cd $(prefix)/Ducktrick-MultiImage/var/tuxbox && ln -s /var/plugins )

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/share
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/Ducktrick-MultiImage/usr/share/zoneinfo/

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/Ducktrick-MultiImage/usr/share/udhcpc/

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/local
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/Ducktrick-MultiImage/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/Ducktrick-MultiImage/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/Ducktrick-MultiImage/usr/local/bin/
	find $(prefix)/Ducktrick-MultiImage/usr/local/bin/ -name  neutrino -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/Ducktrick-MultiImage/usr/local/bin/ -name  pzapit -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/Ducktrick-MultiImage/usr/local/bin/ -name  sectionsdcontrol -exec sh4-linux-strip --strip-unneeded {} \;

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/local/share
	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/Ducktrick-MultiImage/usr/local/share/
#	TODO: Channellist ....
	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/Ducktrick-MultiImage/var/tuxbox/config/
	cp -aR $(targetprefix)/usr/local/share/neutrino $(prefix)/Ducktrick-MultiImage/usr/local/share/
#	TODO: HACK (without *.locale are missing!) --- should be not longer needed since path fix
#	cp -aR $(targetprefix)/$(targetprefix)/usr/local/share/neutrino/* $(prefix)/Ducktrick-MultiImage/usr/local/share/neutrino
#######################################################################################
#	cp -aR $(targetprefix)/usr/local/share/fonts $(prefix)/Ducktrick-MultiImage/usr/local/share/
	mkdir -p $(prefix)/Ducktrick-MultiImage/usr/local/share/fonts
	cp $(buildprefix)/root/usr/share/fonts/tuxtxt.ttf $(prefix)/Ducktrick-MultiImage/usr/local/share/fonts/

# Font libass
	mkdir -p $(prefix)/Ducktrick-MultiImage/usr/share/fonts
	cp $(buildprefix)/root/usr/share/fonts/FreeSans.ttf $(prefix)/Ducktrick-MultiImage/usr/share/fonts/
	cp -aR $(targetprefix)/usr/local/share/fonts/micron.ttf $(prefix)/Ducktrick-MultiImage/usr/local/share/fonts/neutrino.ttf

#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/Ducktrick-MultiImage/etc/imageinfo
	git describe >> $(prefix)/Ducktrick-MultiImage/etc/imageinfo
#######################################################################################

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/lib

	cp -R $(targetprefix)/usr/lib/* $(prefix)/Ducktrick-MultiImage/usr/lib/
	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/Ducktrick-MultiImage/usr/lib/
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/alsa-lib
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/alsaplayer
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/engines
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/gconv
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/libxslt-plugins
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/pkgconfig
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/sigc++-1.2
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/X11
	rm -f $(prefix)/Ducktrick-MultiImage/usr/lib/*.a
	rm -f $(prefix)/Ducktrick-MultiImage/usr/lib/*.o
	rm -f $(prefix)/Ducktrick-MultiImage/usr/lib/*.la

	mkdir -p $(prefix)/Ducktrick-MultiImage/usr/local/share/neutrino/icons/logo
	( cd $(prefix)/Ducktrick-MultiImage/usr/local/share/neutrino && ln -s /usr/local/share/neutrino/httpd httpd-y )
	( cd $(prefix)/Ducktrick-MultiImage/var && ln -s /usr/local/share/neutrino/httpd httpd )
	cp $(appsdir)/neutrino/src/nhttpd/web/{Y_Baselib.js,Y_VLC.js} $(prefix)/Ducktrick-MultiImage/usr/local/share/neutrino/httpd/
	( cd $(prefix)/Ducktrick-MultiImage/usr/local/share/neutrino/httpd && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/Ducktrick-MultiImage/usr/local/share/neutrino/httpd && ln -s /usr/local/share/neutrino/icons/logo logos )

#######################################################################################

	find $(prefix)/Ducktrick-MultiImage/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino #############
#	rm $(prefix)/Ducktrick-MultiImage/bin/mount
	cp -RP $(buildprefix)/own_build/neutrino/* $(prefix)/Ducktrick-MultiImage/

######################################################################################
	rm -f $(prefix)/Ducktrick-MultiImage/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/Ducktrick-MultiImage/sbin/
	cp $(buildprefix)/root/Ducktrick-MultiImage/umountfs $(prefix)/Ducktrick-MultiImage/etc/init.d/
	cp $(buildprefix)/root/Ducktrick-MultiImage/rc $(prefix)/Ducktrick-MultiImage/etc/init.d/
	cp $(buildprefix)/root/Ducktrick-MultiImage/sendsigs $(prefix)/Ducktrick-MultiImage/etc/init.d/
	chmod 755 $(prefix)/Ducktrick-MultiImage/etc/init.d/umountfs
	chmod 755 $(prefix)/Ducktrick-MultiImage/etc/init.d/rc
	chmod 755 $(prefix)/Ducktrick-MultiImage/etc/init.d/sendsigs
	mkdir -p $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/Ducktrick-MultiImage/etc/rc.d
	ln -fs halt $(prefix)/Ducktrick-MultiImage/sbin/reboot
	ln -fs halt $(prefix)/Ducktrick-MultiImage/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc6.d/S90reboot
	cp $(kernelprefix)/$(kernelpath)/arch/sh/boot/uImage $(prefix)/Ducktrick-MultiImage/boot/
	echo "ArgusVIP" > $(prefix)/Ducktrick-MultiImage/etc/hostname
	cp $(buildprefix)/root/Ducktrick-MultiImage/halt_hl101 $(prefix)/Ducktrick-MultiImage/etc/init.d/halt
	chmod 755 $(prefix)/Ducktrick-MultiImage/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom_vip1/aotom_vip1.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -p $(buildprefix)/root/bootscreen/video.elf $(prefix)/Ducktrick-MultiImage/boot/video.elf
	cp -p $(buildprefix)/root/bootscreen/audio.elf $(prefix)/Ducktrick-MultiImage/boot/audio.elf
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/Ducktrick-MultiImage/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/Ducktrick-MultiImage/lib/firmware/
	rm -f $(prefix)/Ducktrick-MultiImage/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	cp -dp $(buildprefix)/root/etc/lircd_alt.conf $(prefix)/Ducktrick-MultiImage/etc/lircd_alt.conf
	cp -dp $(buildprefix)/root/etc/lircd_alt_gruen.conf $(prefix)/Ducktrick-MultiImage/etc/lircd_alt_gruen.conf
	cp -dp $(buildprefix)/root/etc/lircd_neu.conf $(prefix)/Ducktrick-MultiImage/etc/lircd_neu.conf
	cp -dp $(buildprefix)/root/etc/lircd_neu_gruen.conf $(prefix)/Ducktrick-MultiImage/etc/lircd_neu_gruen.conf
	cp -dp $(buildprefix)/root/etc/lircd_opti.conf $(prefix)/Ducktrick-MultiImage/etc/lircd_opti.conf
	cp -dp $(buildprefix)/root/etc/lircd_pingolux.conf $(prefix)/Ducktrick-MultiImage/etc/lircd_pingolux.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/Ducktrick-MultiImage/usr/bin/
	cp -p $(buildprefix)/root/usr/local/bin/dvbtest $(prefix)/Ducktrick-MultiImage/usr/local/bin/
	mkdir -p $(prefix)/Ducktrick-MultiImage/boot/first
	cp -p $(buildprefix)/root/bootscreen/first/* $(prefix)/Ducktrick-MultiImage/boot/first/
	cp -p $(buildprefix)/root/bootscreen/Enigma2.mp4 $(prefix)/Ducktrick-MultiImage/boot/	
	mkdir -p $(prefix)/Ducktrick-MultiImage/var/run/lirc
	mkdir $(prefix)/Ducktrick-MultiImage/var/config
	mkdir $(prefix)/Ducktrick-MultiImage/var/config/system
	mkdir $(prefix)/Ducktrick-MultiImage/var/config/shutdown
	cp -p $(buildprefix)/root/config/shutdown/* $(prefix)/Ducktrick-MultiImage/var/config/shutdown/
	rm -f $(prefix)/Ducktrick-MultiImage/bin/evremote
	rm -f $(prefix)/Ducktrick-MultiImage/bin/vdstandby
	cp -f $(buildprefix)/root/config/shutdown/* $(prefix)/Ducktrick-MultiImage/var/config/shutdown/
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_FB1.xml $(prefix)/Ducktrick-MultiImage/usr/local/share/enigma2/keymap_FB1.xml
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_FB2.xml $(prefix)/Ducktrick-MultiImage/usr/local/share/enigma2/keymap_FB2.xml
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_Opti.xml $(prefix)/Ducktrick-MultiImage/usr/local/share/enigma2/keymap_Opti.xml
	cp -f $(buildprefix)/linux-sh4/drivers/net/wireless/rt2x00/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/net/wireless/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/net/wireless/zd1211rw/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/cachefiles/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/cifs/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/fat/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/fscache/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/isofs/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/ntfs/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/udf/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/usb/serial/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp -R $(buildprefix)/root/Ducktrick-MultiImage/Plugin/* $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/Extensions/
	cp -R $(buildprefix)/root/Ducktrick-MultiImage/Skin/* $(prefix)/Ducktrick-MultiImage/usr/local/share/enigma2/
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/settings $(prefix)/Ducktrick-MultiImage/etc/enigma2/
	cp -R $(buildprefix)/root/Ducktrick-MultiImage/GraphLCD/graphlcd $(prefix)/Ducktrick-MultiImage/usr/local/share/enigma2/
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/Scripte/config/* $(prefix)/Ducktrick-MultiImage/var/config/
	cp -R $(buildprefix)/root/Ducktrick-MultiImage/Scripte/emu $(prefix)/Ducktrick-MultiImage/var/config/
	cp -R $(buildprefix)/root/Ducktrick-MultiImage/Scripte/system $(prefix)/Ducktrick-MultiImage/var/config/
	cp -R $(buildprefix)/root/Ducktrick-MultiImage/Scripte/tools $(prefix)/Ducktrick-MultiImage/var/config/
	cp -f $(prefix)/cdkroot/usr/bin/djmount $(prefix)/Ducktrick-MultiImage/usr/bin/
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/font/* $(prefix)/Ducktrick-MultiImage/usr/share/fonts/
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/converter/*.py $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Components/Converter/
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/switchoff $(prefix)/Ducktrick-MultiImage/etc/init.d/
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/converter/render/*.py $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Components/Renderer/
	mkdir $(prefix)/Ducktrick-MultiImage/var/keys
	mkdir $(prefix)/Ducktrick-MultiImage/var/keys/Benutzerdaten
	mkdir $(prefix)/Ducktrick-MultiImage/var/keys/Benutzerdaten/.emu
	mkdir $(prefix)/Ducktrick-MultiImage/var/keys/Benutzerdaten/.system
	mkdir $(prefix)/Ducktrick-MultiImage/var/keys/Benutzerdaten/.web
	mkdir $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc4.d
	ln -s $(prefix)/Ducktrick-MultiImage/etc/init.d/sendsigs $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc4.d/S20sendsigs
	ln -s $(prefix)/Ducktrick-MultiImage/etc/init.d/umountfs $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc4.d/S40umountfs
	ln -s $(prefix)/Ducktrick-MultiImage/etc/init.d/switchoff $(prefix)/Ducktrick-MultiImage/etc/rc.d/rc4.d/S60switchoff
	touch $@
	rm -rf $(prefix)/Ducktrick-MultiImage || true
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/{bin,boot,dev,dev.static,etc,lib,media,mnt,proc,ram,root,sbin,share,sys,tmp,usr,var} && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/{enigma2,init.d,network,tuxbox} && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/etc/network/{if-down.d,if-post-down.d,if-pre-up.d,if-up.d} && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/lib/modules && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/media/{dvd,hdd,net} && \
	ln -s /media/hdd $(prefix)/Ducktrick-MultiImage/hdd && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/mnt/{hdd,nfs,usb} && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/{bin,lib,local,share,tuxtxt} && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/local/{bin,share} && \
	ln -sf /etc $(prefix)/Ducktrick-MultiImage/usr/local/etc && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/local/share/{enigma2,keymaps} && \
	ln -s /usr/local/share/keymaps $(prefix)/Ducktrick-MultiImage/usr/share/keymaps
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/share/{fonts,zoneinfo,udhcpc} && \
	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/var/{etc,opkg} && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/Ducktrick-MultiImage && \
	touch $(prefix)/Ducktrick-MultiImage/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/Ducktrick-MultiImage/bin/ && \
	ln -sf /bin/showiframe $(prefix)/Ducktrick-MultiImage/usr/bin/showiframe && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/Ducktrick-MultiImage/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/Ducktrick-MultiImage/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/Ducktrick-MultiImage/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/Ducktrick-MultiImage/makedev $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(targetprefix)/boot/uImage $(prefix)/Ducktrick-MultiImage/boot/ && \
	cp $(targetprefix)/boot/audio.elf $(prefix)/Ducktrick-MultiImage/boot/audio.elf && \
	cp -a $(targetprefix)/dev/* $(prefix)/Ducktrick-MultiImage/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp $(buildprefix)/root/etc/inetd.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp $(buildprefix)/root/etc/image-version $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/Ducktrick-MultiImage/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/Ducktrick-MultiImage/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/Ducktrick-MultiImage/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/reboot $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/etc/tuxbox/satellites.xml $(prefix)/Ducktrick-MultiImage/etc/tuxbox/ && \
	cp $(buildprefix)/root/etc/tuxbox/cables.xml $(prefix)/Ducktrick-MultiImage/etc/tuxbox/ && \
	cp $(buildprefix)/root/etc/tuxbox/terrestrial.xml $(prefix)/Ducktrick-MultiImage/etc/tuxbox/ && \
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/Ducktrick-MultiImage/usr/tuxtxt/ && \
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/Ducktrick-MultiImage/usr/share/udhcpc/ && \
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/Ducktrick-MultiImage/usr/share/zoneinfo/ && \
	ln -sf /etc/timezone.xml $(prefix)/Ducktrick-MultiImage/etc/tuxbox/timezone.xml && \
	echo "576i50" > $(prefix)/Ducktrick-MultiImage/etc/videomode && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/rcS_stm23$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS910),_$(UFS910))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(CLASSIC),_$(CLASSIC))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55))$(if $(ADB_BOX),_$(ADB_BOX)) $(prefix)/Ducktrick-MultiImage/etc/init.d/rcS && \
	chmod 755 $(prefix)/Ducktrick-MultiImage/etc/init.d/rcS && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/mountvirtfs $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/mme_check $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/mountall $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/hostname $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/vsftpd $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/sbin/vsftpd $(prefix)/Ducktrick-MultiImage/usr/bin/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/bootclean.sh $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/network $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/Ducktrick-MultiImage/networking $(prefix)/Ducktrick-MultiImage/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/Ducktrick-MultiImage/boot/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/Ducktrick-MultiImage/bin/ && \
	cp $(buildprefix)/root/bin/vdstandby $(prefix)/Ducktrick-MultiImage/bin/ && \
	cp -p $(targetprefix)/usr/bin/killall $(prefix)/Ducktrick-MultiImage/usr/bin/ && \
	cp -p $(targetprefix)/usr/bin/opkg-cl $(prefix)/Ducktrick-MultiImage/usr/bin/opkg && \
	cp -p $(targetprefix)/usr/bin/python $(prefix)/Ducktrick-MultiImage/usr/bin/ && \
	cp -p $(targetprefix)/usr/bin/ffmpeg $(prefix)/Ducktrick-MultiImage/sbin/ && \
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/Ducktrick-MultiImage/usr/sbin/
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/Ducktrick-MultiImage/sbin/

#
# Player
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		sound/kreplay/kreplay.ko \
		sound/kreplay/kreplay-fdma.ko \
		sound/ksound/ktone.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(prefix)/Ducktrick-MultiImage/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/Ducktrick-MultiImage/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/Ducktrick-MultiImage/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";

#
# modules
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
if !ENABLE_VIP2_V1
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/Ducktrick-MultiImage/lib/modules/
endif
endif
endif
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/net/tun.ko ] && cp $(kernelprefix)/linux-sh4/drivers/net/tun.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/Ducktrick-MultiImage/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/sata_switch/sata.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/sata_switch/sata.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko $(prefix)/Ducktrick-MultiImage/lib/modules || true

	find $(prefix)/Ducktrick-MultiImage/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;

#
# lib usr/lib
#
	cp -R $(targetprefix)/lib/* $(prefix)/Ducktrick-MultiImage/lib/
	rm -f $(prefix)/Ducktrick-MultiImage/lib/*.{a,o,la}
	chmod 755 $(prefix)/Ducktrick-MultiImage/lib/*
	find $(prefix)/Ducktrick-MultiImage/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded --remove-section=.comment --remove-section=.note {} \;

	cp -R $(targetprefix)/usr/lib/* $(prefix)/Ducktrick-MultiImage/usr/lib/
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/{engines,enigma2,gconv,ldscripts,libxslt-plugins,pkgconfig,python$(PYTHON_VERSION),sigc++-1.2,X11}
	rm -f $(prefix)/Ducktrick-MultiImage/usr/lib/*.{a,o,la}
	chmod 755 $(prefix)/Ducktrick-MultiImage/usr/lib/*
	find $(prefix)/Ducktrick-MultiImage/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded --remove-section=.comment --remove-section=.note {} \;

#
# fonts
#
	cp $(buildprefix)/root/usr/share/fonts/* $(prefix)/Ducktrick-MultiImage/usr/share/fonts/
	if [ -e $(targetprefix)/usr/share/fonts/tuxtxt.otb ]; then \
		cp $(targetprefix)/usr/share/fonts/tuxtxt.otb $(prefix)/Ducktrick-MultiImage/usr/share/fonts/; \
	fi
	if [ -e $(targetprefix)/usr/local/share/fonts/andale.ttf ]; then \
		cp $(targetprefix)/usr/local/share/fonts/andale.ttf $(prefix)/Ducktrick-MultiImage/usr/share/fonts/; \
	fi
	if [ -e $(targetprefix)/usr/local/share/fonts/DroidSans-Bold.ttf ]; then \
		cp $(targetprefix)/usr/local/share/fonts/DroidSans-Bold.ttf $(prefix)/Ducktrick-MultiImage/usr/share/fonts/; \
	fi
	ln -s /usr/share/fonts $(prefix)/Ducktrick-MultiImage/usr/local/share/fonts

#
# enigma2
#
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		cp -f $(targetprefix)/usr/bin/enigma2 $(prefix)/Ducktrick-MultiImage/usr/local/bin/enigma2; \
	fi

	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		cp -f $(targetprefix)/usr/local/bin/enigma2 $(prefix)/Ducktrick-MultiImage/usr/local/bin/enigma2; \
	fi

	find $(prefix)/Ducktrick-MultiImage/usr/local/bin/ -name  enigma2 -exec sh4-linux-strip --strip-unneeded {} \;

	cp -a $(targetprefix)/usr/local/share/enigma2/* $(prefix)/Ducktrick-MultiImage/usr/local/share/enigma2
	cp $(buildprefix)/root/etc/enigma2/* $(prefix)/Ducktrick-MultiImage/etc/enigma2
	ln -s /usr/local/share/enigma2 $(prefix)/Ducktrick-MultiImage/usr/share/enigma2

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2
	cp -a $(targetprefix)/usr/lib/enigma2/* $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/

	if test -d $(targetprefix)/usr/local/lib/enigma2; then \
		cp -a $(targetprefix)/usr/local/lib/enigma2/* $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2; \
	fi

#
# python2.7
#
	if [ $(PYTHON_VERSION) == 2.7 ]; then \
		$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage/usr/include; \
		$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage$(PYTHON_INCLUDE_DIR); \
		cp $(targetprefix)$(PYTHON_INCLUDE_DIR)/pyconfig.h $(prefix)/Ducktrick-MultiImage$(PYTHON_INCLUDE_DIR); \
	fi

#
# tuxtxt
#
	if [ -e $(targetprefix)/usr/bin/tuxtxt ]; then \
		cp -p $(targetprefix)/usr/bin/tuxtxt $(prefix)/Ducktrick-MultiImage/usr/bin/; \
	fi

#
# fw_printenv / fw_setenv
#
	if [ -e $(targetprefix)/usr/sbin/fw_printenv ]; then \
		cp -dp $(targetprefix)/usr/sbin/fw_* $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
	fi

#
# Delete unnecessary plugins and files
#
	rm -rf $(prefix)/Ducktrick-MultiImage/lib/autofs
	rm -rf $(prefix)/Ducktrick-MultiImage/lib/modules/$(KERNELVERSION)

	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/DemoPlugins
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/SystemPlugins/FrontprocessorUpgrade
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/SystemPlugins/NFIFlash
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/Extensions/FileManager
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/Extensions/TuxboxPlugins
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/Extensions/ModemSettings
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/SystemPlugins/OSD3DSetup
	rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/python/Plugins/SystemPlugins/SoftwareManager

	$(INSTALL_DIR) $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)
	cp -a $(targetprefix)$(PYTHON_DIR)/* $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/Cheetah-2.4.4-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/elementtree-1.2.6_20050316-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/lxml
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/lxml-2.2.8-py$(PYTHON_VERSION).egg-info
	rm -f $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/libxml2mod.so
	rm -f $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/libxsltmod.so
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/OpenSSL/test
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/pyOpenSSL-0.11-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/python_wifi-0.5.0-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/pycrypto-2.5-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/pyusb-1.0.0a2-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/setuptools
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/setuptools-0.6c11-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/zope.interface-4.0.1-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/Twisted-12.1.0-py$(PYTHON_VERSION).egg-info
#	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/site-packages/twisted/{test,conch,mail,manhole,names,news,trial,words,application,enterprise,flow,lore,pair,runner,scripts,tap,topfiles}
#	rm -rf $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/{bsddb,compiler,curses,distutils,lib-old,lib-tk,plat-linux3,test}

#
# Dont remove pyo files, remove pyc instead
#
	find $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/ -name '*.pyc' -exec rm -f {} \;
#	find $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/ -not -name 'mytest.py' -name '*.py' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/ -name '*.a' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/ -name '*.o' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/ -name '*.la' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage/usr/lib/enigma2/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

	find $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/ -name '*.pyc' -exec rm -f {} \;
#	find $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/ -name '*.py' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/ -name '*.a' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/ -name '*.o' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/ -name '*.la' -exec rm -f {} \;
	find $(prefix)/Ducktrick-MultiImage$(PYTHON_DIR)/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

#
# hotplug
#
	if [ -e $(targetprefix)/usr/bin/hotplug_e2_helper ]; then \
		cp -dp $(targetprefix)/usr/bin/hotplug_e2_helper $(prefix)/Ducktrick-MultiImage/sbin/hotplug; \
		cp -dp $(targetprefix)/usr/bin/bdpoll $(prefix)/Ducktrick-MultiImage/sbin/; \
		rm -f $(prefix)/Ducktrick-MultiImage/bin/hotplug; \
	else \
		cp -dp $(targetprefix)/bin/hotplug $(prefix)/Ducktrick-MultiImage/sbin/; \
	fi

#
# WLAN
#
	if [ -e $(targetprefix)/usr/sbin/ifrename ]; then \
		$(target)-strip $(targetprefix)/usr/local/sbin/wpa_cli; \
		$(target)-strip $(targetprefix)/usr/local/sbin/wpa_passphrase; \
		$(target)-strip $(targetprefix)/usr/local/sbin/wpa_supplicant; \
		cp -dp $(targetprefix)/usr/sbin/ifrename $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwconfig $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwevent $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwgetid $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwlist $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwpriv $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwspy $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/local/sbin/wpa_cli $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/local/sbin/wpa_passphrase $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -dp $(targetprefix)/usr/local/sbin/wpa_supplicant $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
	fi

#
# alsa
#
	if [ -e $(targetprefix)/usr/share/alsa ]; then \
		mkdir $(prefix)/Ducktrick-MultiImage/usr/share/alsa/; \
		mkdir $(prefix)/Ducktrick-MultiImage/usr/share/alsa/cards/; \
		mkdir $(prefix)/Ducktrick-MultiImage/usr/share/alsa/pcm/; \
		cp $(targetprefix)/usr/share/alsa/alsa.conf $(prefix)/Ducktrick-MultiImage/usr/share/alsa/alsa.conf; \
		cp $(targetprefix)/usr/share/alsa/cards/aliases.conf $(prefix)/Ducktrick-MultiImage/usr/share/alsa/cards/; \
		cp $(targetprefix)/usr/share/alsa/pcm/default.conf $(prefix)/Ducktrick-MultiImage/usr/share/alsa/pcm/; \
		cp $(targetprefix)/usr/share/alsa/pcm/dmix.conf $(prefix)/Ducktrick-MultiImage/usr/share/alsa/pcm/; \
	fi

#
# AUTOFS
#
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/autofs ]; then \
		cp -f $(targetprefix)/usr/sbin/automount $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
		cp -f $(buildprefix)/root/Ducktrick-MultiImage/auto.hotplug $(prefix)/Ducktrick-MultiImage/etc/; \
		cp -f $(buildprefix)/root/Ducktrick-MultiImage/auto.network $(prefix)/Ducktrick-MultiImage/etc/; \
		cp -f $(buildprefix)/root/Ducktrick-MultiImage/autofs $(prefix)/Ducktrick-MultiImage/etc/init.d/; \
	fi

#
# GSTREAMER
#
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10 ]; then \
		#removed rm \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/libgstfft*; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/*; \
		cp -a $(targetprefix)/usr/bin/gst-* $(prefix)/Ducktrick-MultiImage/usr/bin/; \
		sh4-linux-strip --strip-unneeded $(prefix)/Ducktrick-MultiImage/usr/bin/gst-launch*; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstalsa.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapetag.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapp.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstasf.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstassrender.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioconvert.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioparsers.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioresample.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstautodetect.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstavi.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcdxaparse.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreelements.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreindexers.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin2.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbaudiosink.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbvideosink.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvdsub.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflac.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflv.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstfragmented.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsticydemux.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstid3demux.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstisomp4.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmad.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmatroska.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegaudioparse.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegdemux.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegstream.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstogg.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstplaybin.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtmp.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtp.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtpmanager.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtsp.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubparse.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsttypefindfunctions.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstudp.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstvcdsrc.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstwavparse.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		if [ -e $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpegscale.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstpostproc.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		fi; \
		if [ -e $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/; \
		fi; \
		sh4-linux-strip --strip-unneeded $(prefix)/Ducktrick-MultiImage/usr/lib/gstreamer-0.10/*; \
	fi

#
# DIRECTFB
#
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5 ]; then \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/gfxdrivers/*.{a,o,la}; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/inputdrivers/*; \
		cp -a $(targetprefix)/usr/lib/directfb-1.4-5/inputdrivers/libdirectfb_enigma2remote.so $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/inputdrivers/; \
		cp -a $(targetprefix)/usr/lib/directfb-1.4-5/inputdrivers/libdirectfb_linux_input.so $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/inputdrivers/; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/systems/*.{a,o,la}; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/systems/libdirectfb_dummy.so; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/systems/libdirectfb_fbdev.so; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/wm/*.{a,o,la}; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/interfaces/IDirectFBFont/*.{a,o,la}; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/interfaces/IDirectFBImageProvider/*.{a,o,la}; \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/directfb-1.4-5/interfaces/IDirectFBVideoProvider/*.{a,o,la}; \
	fi
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/icu ]; then \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/icu; \
	fi
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/glib-2.0 ]; then \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/glib-2.0; \
	fi
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/gio ]; then \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/gio; \
	fi
	if [ -d $(prefix)/Ducktrick-MultiImage/usr/lib/enchant ]; then \
		rm -rf $(prefix)/Ducktrick-MultiImage/usr/lib/enchant; \
	fi

#
# GRAPHLCD
#
	if [ -e $(prefix)/Ducktrick-MultiImage/usr/lib/libglcddrivers.so ]; then \
		cp -f $(targetprefix)/etc/graphlcd.conf $(prefix)/Ducktrick-MultiImage/etc/graphlcd.conf; \
	fi

#
# minidlna
#
	if [ -e $(targetprefix)/usr/sbin/minidlna ]; then \
		cp -f $(targetprefix)/usr/sbin/minidlna $(prefix)/Ducktrick-MultiImage/usr/sbin/; \
	fi

#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/Ducktrick-MultiImage: \
$(DEPDIR)/%Ducktrick-MultiImage: Ducktrick-MultiImage_base Ducktrick-MultiImage_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(UFS913)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CLASSIC)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)
	touch $@

#
# FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma2
#
	cp -RP $(buildprefix)/own_build/enigma2/* $(prefix)/Ducktrick-MultiImage/

#
# Ducktrick-MultiImage-clean
#
Ducktrick-MultiImage-clean:
	rm -f $(DEPDIR)/Ducktrick-MultiImage
