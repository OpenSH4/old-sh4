#
# auxiliary targets for model-specific builds
#

#
# release_common_utils
#
release_ducktrick_common_utils:
#	remove the slink to busybox
	rm -f $(prefix)/release_ducktrick/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_ducktrick/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_ducktrick/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_ducktrick/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_ducktrick/etc/init.d/
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/umountfs
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/rc
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/sendsigs
	mkdir -p $(prefix)/release_ducktrick/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_ducktrick/etc/rc.d
	ln -fs halt $(prefix)/release_ducktrick/sbin/reboot
	ln -fs halt $(prefix)/release_ducktrick/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_ducktrick/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_ducktrick/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_ducktrick/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_ducktrick/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_ducktrick/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_ducktrick/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_ducktrick/etc/rc.d/rc6.d/S90reboot

#
# release_hl101 Opticum9500 Vip1 Vip1v2 Vip2 
#
release_ducktrick_hl101: release_ducktrick_common_utils
	echo "ArgusVIP" > $(prefix)/release_ducktrick/etc/hostname
	cp $(buildprefix)/root/release/halt_hl101 $(prefix)/release_ducktrick/etc/init.d/halt
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom_vip1/aotom_vip1.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_ducktrick/lib/modules/
	cp -p $(buildprefix)/root/bootscreen/video.elf $(prefix)/release_ducktrick/boot/video.elf
	cp -p $(buildprefix)/root/bootscreen/audio.elf $(prefix)/release_ducktrick/boot/audio.elf
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_ducktrick/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_ducktrick/lib/firmware/
	rm -f $(prefix)/release_ducktrick/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	cp -dp $(buildprefix)/root/etc/lircd_alt.conf $(prefix)/release_ducktrick/etc/lircd_alt.conf
	cp -dp $(buildprefix)/root/etc/lircd_alt_gruen.conf $(prefix)/release_ducktrick/etc/lircd_alt_gruen.conf
	cp -dp $(buildprefix)/root/etc/lircd_neu.conf $(prefix)/release_ducktrick/etc/lircd_neu.conf
	cp -dp $(buildprefix)/root/etc/lircd_neu_gruen.conf $(prefix)/release_ducktrick/etc/lircd_neu_gruen.conf
	cp -dp $(buildprefix)/root/etc/lircd_opti.conf $(prefix)/release_ducktrick/etc/lircd_opti.conf
	cp -dp $(buildprefix)/root/etc/lircd_pingolux.conf $(prefix)/release_ducktrick/etc/lircd_pingolux.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_ducktrick/usr/bin/
	cp -p $(buildprefix)/root/usr/local/bin/dvbtest $(prefix)/release_ducktrick/usr/local/bin/
	mkdir -p $(prefix)/release_ducktrick/boot/first
	cp -p $(buildprefix)/root/bootscreen/first/* $(prefix)/release_ducktrick/boot/first/
	cp -p $(buildprefix)/root/bootscreen/Enigma2.mp4 $(prefix)/release_ducktrick/boot/
	cp -p $(buildprefix)/root/bootscreen/NeutrinoHD.mp4 $(prefix)/release_ducktrick/boot/
	mkdir -p $(prefix)/release_ducktrick/var/run/lirc
	mkdir $(prefix)/release_ducktrick/var/config
	mkdir $(prefix)/release_ducktrick/var/config/system
	mkdir $(prefix)/release_ducktrick/var/config/shutdown
	cp -p $(buildprefix)/root/config/shutdown/* $(prefix)/release_ducktrick/var/config/shutdown/
	rm -f $(prefix)/release_ducktrick/bin/evremote
	rm -f $(prefix)/release_ducktrick/bin/vdstandby
	cp -f $(buildprefix)/root/config/shutdown/* $(prefix)/release_ducktrick/var/config/shutdown/
	mkdir -p $(prefix)/release_ducktrick/var/config/emu
	cp -f $(buildprefix)/root/var/config/emu/SoftCam-Update.sh $(prefix)/release_ducktrick/var/config/emu/SoftCam-Update.sh
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_FB1.xml $(prefix)/release_ducktrick/usr/local/share/enigma2/keymap_FB1.xml
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_FB2.xml $(prefix)/release_ducktrick/usr/local/share/enigma2/keymap_FB2.xml
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_Opti.xml $(prefix)/release_ducktrick/usr/local/share/enigma2/keymap_Opti.xml
	cp -f $(buildprefix)/linux-sh4/drivers/net/wireless/rt2x00/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/net/wireless/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/net/wireless/zd1211rw/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/cachefiles/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/cifs/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/fat/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/fscache/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/isofs/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/ntfs/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/udf/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/usb/serial/*.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/char/lirc/lirc_mceusb2.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/char/lirc/lirc_stm.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/drivers/char/lirc/lirc_ttusbir.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/ext3/ext3.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/jbd/jbd.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_ascii.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_cp1250.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_cp1251.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_cp437.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_cp850.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_cp855.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_cp866.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_iso8859-1.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_iso8859-2.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_iso8859-5.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_koi8-r.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_koi8-ru.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_koi8-u.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/fs/nls/nls_utf8.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/net/mac80211/mac80211.ko $(prefix)/release_ducktrick/lib/modules/
	cp -f $(buildprefix)/linux-sh4/net/wireless/cfg80211.ko $(prefix)/release_ducktrick/lib/modules/
	cp -R $(buildprefix)/root/release/Plugin/* $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/Extensions/
	cp -R $(buildprefix)/root/release/Skin/* $(prefix)/release_ducktrick/usr/local/share/enigma2/
	cp -f $(buildprefix)/root/release/settings $(prefix)/release_ducktrick/etc/enigma2/
	cp -R $(buildprefix)/root/release/GraphLCD/graphlcd $(prefix)/release_ducktrick/usr/local/share/enigma2/
	cp -f $(buildprefix)/root/release/Scripte/config/* $(prefix)/release_ducktrick/var/config/
	cp -R $(buildprefix)/root/release/Scripte/emu $(prefix)/release_ducktrick/var/config/
	cp -R $(buildprefix)/root/release/Scripte/system $(prefix)/release_ducktrick/var/config/
	cp -R $(buildprefix)/root/release/Scripte/tools $(prefix)/release_ducktrick/var/config/
	cp -f $(prefix)/cdkroot/usr/bin/djmount $(prefix)/release_ducktrick/usr/bin/
	cp -f $(buildprefix)/root/release/font/* $(prefix)/release_ducktrick/usr/share/fonts/
	cp -f $(buildprefix)/root/release/converter/*.py $(prefix)/release_ducktrick/usr/lib/enigma2/python/Components/Converter/
	cp -f $(buildprefix)/root/release/switchoff $(prefix)/release_ducktrick/etc/init.d/
	cp -f $(buildprefix)/root/release/converter/render/*.py $(prefix)/release_ducktrick/usr/lib/enigma2/python/Components/Renderer/
	cp -f $(prefix)/cdkroot/usr/bin/grab $(prefix)/release_ducktrick/usr/bin/ && \
	mkdir $(prefix)/release_ducktrick/var/keys
	mkdir $(prefix)/release_ducktrick/var/keys/Benutzerdaten
	mkdir $(prefix)/release_ducktrick/var/keys/Benutzerdaten/.emu
	mkdir $(prefix)/release_ducktrick/var/keys/Benutzerdaten/.system
	mkdir $(prefix)/release_ducktrick/var/keys/Benutzerdaten/.web
	mkdir $(prefix)/release_ducktrick/etc/rc.d/rc4.d
	ln -s $(prefix)/release_ducktrick/etc/init.d/sendsigs $(prefix)/release_ducktrick/etc/rc.d/rc4.d/S20sendsigs
	ln -s $(prefix)/release_ducktrick/etc/init.d/umountfs $(prefix)/release_ducktrick/etc/rc.d/rc4.d/S40umountfs
	ln -s $(prefix)/release_ducktrick/etc/init.d/switchoff $(prefix)/release_ducktrick/etc/rc.d/rc4.d/S60switchoff
	mkdir -p $(prefix)/release_ducktrick/var/plugins
	mkdir -p $(prefix)/release_ducktrick/var/tuxbox/config
	mkdir -p $(prefix)/release_ducktrick/usr/local/share
	ln -sf /var/tuxbox/config $(prefix)/release_ducktrick/usr/local/share/config
	mkdir -p $(prefix)/release_ducktrick/var/share/icons
	cp -a $(targetprefix)/bin/* $(prefix)/release_ducktrick/bin/
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_ducktrick/sbin/
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/release_ducktrick/sbin/
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_ducktrick/sbin/
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_ducktrick/sbin/
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_ducktrick/sbin/
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_ducktrick/sbin/ 
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_ducktrick/sbin/ 
	( cd $(prefix)/release_ducktrick/var/share/icons/ && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/release_ducktrick/ && ln -s /usr/local/share/neutrino/icons/logo logos )
	( cd $(prefix)/release_ducktrick/lib && ln -s libcrypto.so.0.9.7 libcrypto.so.0.9.8 )
	( cd $(prefix)/release_ducktrick/var/tuxbox && ln -s /var/plugins )
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/share
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_ducktrick/usr/share/zoneinfo/
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_ducktrick/usr/share/udhcpc/
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/local
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_ducktrick/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_ducktrick/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_ducktrick/usr/local/bin/
	find $(prefix)/release_ducktrick/usr/local/bin/ -name  neutrino -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_ducktrick/usr/local/bin/ -name  pzapit -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_ducktrick/usr/local/bin/ -name  sectionsdcontrol -exec sh4-linux-strip --strip-unneeded {} \;
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/local/share
	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_ducktrick/usr/local/share/
	cp -f $(buildprefix)/root/release/autoswitch $(prefix)/release_ducktrick/bin/autoswitch
	cp -f $(buildprefix)/root/release/i2cget $(prefix)/release_ducktrick/bin/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/sound/pcm_transcoder/*.ko $(prefix)/release_ducktrick/lib/modules/
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/mountvirtfs
	cp $(targetprefix)/usr/bin/free $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/pgrep $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/pidof $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/pkill $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/pmap $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/pwdx $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/slabtop $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/tload $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/top $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/uptime $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/vmstat $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/w $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/usr/bin/watch $(prefix)/release_ducktrick/usr/bin/
	cp $(targetprefix)/sbin/sysctl $(prefix)/release_ducktrick/sbin/
	cp $(targetprefix)/bin/kill $(prefix)/release_ducktrick/bin/
	cp $(targetprefix)/bin/ps $(prefix)/release_ducktrick/bin/
#	TODO: Channellist ....
	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/release_ducktrick/var/tuxbox/config/
	cp -aR $(targetprefix)/usr/share/tuxbox/neutrino $(prefix)/release_ducktrick/usr/local/share/
	mkdir $(prefix)/release_ducktrick/lib/modules/2.6.32.59_stm24_0211/
	cp -aR $(buildprefix)/root/release/lib/modules/2.6.32.59_stm24_0211/modules.dep $(prefix)/release_ducktrick/lib/modules/2.6.32.59_stm24_0211/
	cp $(prefix)/release_ducktrick/lib/modules/*.ko $(prefix)/release_ducktrick/lib/modules/2.6.32.59_stm24_0211
	rm $(prefix)/release_ducktrick/lib/modules/*.ko
	mkdir $(prefix)/release_ducktrick/usr/share/tuxbox
	cd $(prefix)/release_ducktrick/usr/share/tuxbox && \
	ln -s ../../local/share/neutrino $(prefix)/release_ducktrick/usr/share/tuxbox/ && \
	cd $(buildprefix)

#
# release_base
#
# the following target creates the common file base
release_ducktrick_base:
	rm -rf $(prefix)/release_ducktrick || true
	$(INSTALL_DIR) $(prefix)/release_ducktrick && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/{bin,boot,dev,dev.static,etc,lib,media,mnt,proc,ram,root,sbin,share,sys,tmp,usr,var} && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/etc/{enigma2,init.d,network,tuxbox} && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/etc/network/{if-down.d,if-post-down.d,if-pre-up.d,if-up.d} && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/media/{dvd,hdd,net} && \
	ln -s /media/hdd $(prefix)/release_ducktrick/hdd && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/mnt/{hdd,nfs,usb} && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/{bin,lib,local,share,tuxtxt} && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/local/{bin,share} && \
	ln -sf /etc $(prefix)/release_ducktrick/usr/local/etc && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/local/share/{enigma2,keymaps} && \
	ln -s /usr/local/share/keymaps $(prefix)/release_ducktrick/usr/share/keymaps
	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/share/{fonts,zoneinfo,udhcpc} && \
	$(INSTALL_DIR) $(prefix)/release_ducktrick/var/{etc,opkg} && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_ducktrick && \
	touch $(prefix)/release_ducktrick/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_ducktrick/bin/ && \
	ln -sf /bin/showiframe $(prefix)/release_ducktrick/usr/bin/showiframe && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_ducktrick/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/release_ducktrick/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/release_ducktrick/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/release_ducktrick/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/release_ducktrick/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_ducktrick/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/release_ducktrick/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/release_ducktrick/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/release_ducktrick/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/release_ducktrick/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/release_ducktrick/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/release_ducktrick/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/release_ducktrick/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/release_ducktrick/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_ducktrick/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_ducktrick/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_ducktrick/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release_ducktrick/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/release/makedev $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(targetprefix)/boot/uImage $(prefix)/release_ducktrick/boot/ && \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_ducktrick/boot/audio.elf && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_ducktrick/etc/ && \
	cp $(buildprefix)/root/etc/inetd.conf $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_ducktrick/etc/ && \
	cp $(buildprefix)/root/etc/image-version $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_ducktrick/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_ducktrick/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_ducktrick/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_ducktrick/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/etc/tuxbox/satellites.xml $(prefix)/release_ducktrick/etc/tuxbox/ && \
	cp $(buildprefix)/root/etc/tuxbox/cables.xml $(prefix)/release_ducktrick/etc/tuxbox/ && \
	cp $(buildprefix)/root/etc/tuxbox/terrestrial.xml $(prefix)/release_ducktrick/etc/tuxbox/ && \
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/release_ducktrick/usr/tuxtxt/ && \
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_ducktrick/usr/share/udhcpc/ && \
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_ducktrick/usr/share/zoneinfo/ && \
	ln -sf /etc/timezone.xml $(prefix)/release_ducktrick/etc/tuxbox/timezone.xml && \
	echo "576i50" > $(prefix)/release_ducktrick/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_stm23$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS910),_$(UFS910))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(CLASSIC),_$(CLASSIC))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55))$(if $(ADB_BOX),_$(ADB_BOX)) $(prefix)/release_ducktrick/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/modload $(prefix)/release_ducktrick/etc/init.d/modload
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/rcS && \
	chmod 755 $(prefix)/release_ducktrick/etc/init.d/modload && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_ducktrick/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_ducktrick/usr/bin/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/network $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_ducktrick/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release_ducktrick/boot/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_ducktrick/bin/ && \
	cp $(buildprefix)/root/bin/vdstandby $(prefix)/release_ducktrick/bin/ && \
	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_ducktrick/usr/bin/ && \
	cp -p $(targetprefix)/usr/bin/opkg-cl $(prefix)/release_ducktrick/usr/bin/opkg && \
	cp -p $(targetprefix)/usr/bin/python $(prefix)/release_ducktrick/usr/bin/ && \
	cp -p $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_ducktrick/sbin/ && \
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_ducktrick/usr/sbin/
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release_ducktrick/sbin/

#
# Player
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_ducktrick/lib/modules/
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
			cp player2/linux/drivers/$$mod $(prefix)/release_ducktrick/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_ducktrick/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_ducktrick/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";

#
# modules
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_ducktrick/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_ducktrick/lib/modules/
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/net/tun.ko ] && cp $(kernelprefix)/linux-sh4/drivers/net/tun.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_ducktrick/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko $(prefix)/release_ducktrick/lib/modules || true

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/sata_switch/sata.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/sata_switch/sata.ko $(prefix)/release_ducktrick/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko $(prefix)/release_ducktrick/lib/modules || true

	find $(prefix)/release_ducktrick/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
#
# lib usr/lib
#
	cp -R $(targetprefix)/lib/* $(prefix)/release_ducktrick/lib/
	rm -f $(prefix)/release_ducktrick/lib/*.{a,o,la}
	chmod 755 $(prefix)/release_ducktrick/lib/*
	find $(prefix)/release_ducktrick/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded --remove-section=.comment --remove-section=.note {} \;

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_ducktrick/usr/lib/
	rm -rf $(prefix)/release_ducktrick/usr/lib/{engines,enigma2,gconv,ldscripts,libxslt-plugins,pkgconfig,python$(PYTHON_VERSION),sigc++-1.2,X11}
	rm -f $(prefix)/release_ducktrick/usr/lib/*.{a,o,la}
	chmod 755 $(prefix)/release_ducktrick/usr/lib/*
	find $(prefix)/release_ducktrick/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded --remove-section=.comment --remove-section=.note {} \;

#
# fonts
#
	cp $(buildprefix)/root/usr/share/fonts/* $(prefix)/release_ducktrick/usr/share/fonts/
	if [ -e $(targetprefix)/usr/share/fonts/tuxtxt.otb ]; then \
		cp $(targetprefix)/usr/share/fonts/tuxtxt.otb $(prefix)/release_ducktrick/usr/share/fonts/; \
	fi
	if [ -e $(targetprefix)/usr/local/share/fonts/andale.ttf ]; then \
		cp $(targetprefix)/usr/local/share/fonts/andale.ttf $(prefix)/release_ducktrick/usr/share/fonts/; \
	fi
	if [ -e $(targetprefix)/usr/local/share/fonts/DroidSans-Bold.ttf ]; then \
		cp $(targetprefix)/usr/local/share/fonts/DroidSans-Bold.ttf $(prefix)/release_ducktrick/usr/share/fonts/; \
	fi
	ln -s /usr/share/fonts $(prefix)/release_ducktrick/usr/local/share/fonts

#
# enigma2
#
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		cp -f $(targetprefix)/usr/bin/enigma2 $(prefix)/release_ducktrick/usr/local/bin/enigma2; \
	fi

	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		cp -f $(targetprefix)/usr/local/bin/enigma2 $(prefix)/release_ducktrick/usr/local/bin/enigma2; \
	fi

	find $(prefix)/release_ducktrick/usr/local/bin/ -name  enigma2 -exec sh4-linux-strip --strip-unneeded {} \;

	cp -a $(targetprefix)/usr/local/share/enigma2/* $(prefix)/release_ducktrick/usr/local/share/enigma2
	cp $(buildprefix)/root/etc/enigma2/* $(prefix)/release_ducktrick/etc/enigma2
	ln -s /usr/local/share/enigma2 $(prefix)/release_ducktrick/usr/share/enigma2

	$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/lib/enigma2
	cp -a $(targetprefix)/usr/lib/enigma2/* $(prefix)/release_ducktrick/usr/lib/enigma2/

	if test -d $(targetprefix)/usr/local/lib/enigma2; then \
		cp -a $(targetprefix)/usr/local/lib/enigma2/* $(prefix)/release_ducktrick/usr/lib/enigma2; \
	fi

#
# python2.7
#
	if [ $(PYTHON_VERSION) == 2.7 ]; then \
		$(INSTALL_DIR) $(prefix)/release_ducktrick/usr/include; \
		$(INSTALL_DIR) $(prefix)/release$(PYTHON_INCLUDE_DIR); \
		cp $(targetprefix)$(PYTHON_INCLUDE_DIR)/pyconfig.h $(prefix)/release$(PYTHON_INCLUDE_DIR); \
	fi

#
# tuxtxt
#
	if [ -e $(targetprefix)/usr/bin/tuxtxt ]; then \
		cp -p $(targetprefix)/usr/bin/tuxtxt $(prefix)/release_ducktrick/usr/bin/; \
	fi

#
# fw_printenv / fw_setenv
#
	if [ -e $(targetprefix)/usr/sbin/fw_printenv ]; then \
		cp -dp $(targetprefix)/usr/sbin/fw_* $(prefix)/release_ducktrick/usr/sbin/; \
	fi

#
# Delete unnecessary plugins and files
#
	rm -rf $(prefix)/release_ducktrick/lib/autofs
	rm -rf $(prefix)/release_ducktrick/lib/modules/$(KERNELVERSION)

	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/DemoPlugins
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/SystemPlugins/FrontprocessorUpgrade
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/SystemPlugins/NFIFlash
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/Extensions/FileManager
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/Extensions/TuxboxPlugins
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/Extensions/ModemSettings
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/SystemPlugins/OSD3DSetup
	rm -rf $(prefix)/release_ducktrick/usr/lib/enigma2/python/Plugins/SystemPlugins/SoftwareManager

	$(INSTALL_DIR) $(prefix)/release$(PYTHON_DIR)
	cp -a $(targetprefix)$(PYTHON_DIR)/* $(prefix)/release$(PYTHON_DIR)/
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/Cheetah-2.4.4-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/elementtree-1.2.6_20050316-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/lxml
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/lxml-2.2.8-py$(PYTHON_VERSION).egg-info
	rm -f $(prefix)/release$(PYTHON_DIR)/site-packages/libxml2mod.so
	rm -f $(prefix)/release$(PYTHON_DIR)/site-packages/libxsltmod.so
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/OpenSSL/test
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/pyOpenSSL-0.11-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/python_wifi-0.5.0-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/pycrypto-2.5-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/pyusb-1.0.0a2-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/setuptools
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/setuptools-0.6c11-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/zope.interface-4.0.1-py$(PYTHON_VERSION).egg-info
	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/Twisted-12.1.0-py$(PYTHON_VERSION).egg-info
#	rm -rf $(prefix)/release$(PYTHON_DIR)/site-packages/twisted/{test,conch,mail,manhole,names,news,trial,words,application,enterprise,flow,lore,pair,runner,scripts,tap,topfiles}
#	rm -rf $(prefix)/release$(PYTHON_DIR)/{bsddb,compiler,curses,distutils,lib-old,lib-tk,plat-linux3,test}

#
# Dont remove pyo files, remove pyc instead
#
	find $(prefix)/release_ducktrick/usr/lib/enigma2/ -name '*.pyc' -exec rm -f {} \;
#	find $(prefix)/release_ducktrick/usr/lib/enigma2/ -not -name 'mytest.py' -name '*.py' -exec rm -f {} \;
	find $(prefix)/release_ducktrick/usr/lib/enigma2/ -name '*.a' -exec rm -f {} \;
	find $(prefix)/release_ducktrick/usr/lib/enigma2/ -name '*.o' -exec rm -f {} \;
	find $(prefix)/release_ducktrick/usr/lib/enigma2/ -name '*.la' -exec rm -f {} \;
	find $(prefix)/release_ducktrick/usr/lib/enigma2/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

	find $(prefix)/release$(PYTHON_DIR)/ -name '*.pyc' -exec rm -f {} \;
#	find $(prefix)/release$(PYTHON_DIR)/ -name '*.py' -exec rm -f {} \;
	find $(prefix)/release$(PYTHON_DIR)/ -name '*.a' -exec rm -f {} \;
	find $(prefix)/release$(PYTHON_DIR)/ -name '*.o' -exec rm -f {} \;
	find $(prefix)/release$(PYTHON_DIR)/ -name '*.la' -exec rm -f {} \;
	find $(prefix)/release$(PYTHON_DIR)/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

#
# hotplug
#
	if [ -e $(targetprefix)/usr/bin/hotplug_e2_helper ]; then \
		cp -dp $(targetprefix)/usr/bin/hotplug_e2_helper $(prefix)/release_ducktrick/sbin/hotplug; \
		cp -dp $(targetprefix)/usr/bin/bdpoll $(prefix)/release_ducktrick/sbin/; \
		rm -f $(prefix)/release_ducktrick/bin/hotplug; \
	else \
		cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_ducktrick/sbin/; \
	fi

#
# WLAN
#
	if [ -e $(targetprefix)/usr/sbin/ifrename ]; then \
		$(target)-strip $(targetprefix)/usr/local/sbin/wpa_cli; \
		$(target)-strip $(targetprefix)/usr/local/sbin/wpa_passphrase; \
		$(target)-strip $(targetprefix)/usr/local/sbin/wpa_supplicant; \
		cp -dp $(targetprefix)/usr/sbin/ifrename $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwconfig $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwevent $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwgetid $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwlist $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwpriv $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/sbin/iwspy $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/local/sbin/wpa_cli $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/local/sbin/wpa_passphrase $(prefix)/release_ducktrick/usr/sbin/; \
		cp -dp $(targetprefix)/usr/local/sbin/wpa_supplicant $(prefix)/release_ducktrick/usr/sbin/; \
	fi

#
# alsa
#
	if [ -e $(targetprefix)/usr/share/alsa ]; then \
		mkdir $(prefix)/release_ducktrick/usr/share/alsa/; \
		mkdir $(prefix)/release_ducktrick/usr/share/alsa/cards/; \
		mkdir $(prefix)/release_ducktrick/usr/share/alsa/pcm/; \
		cp $(targetprefix)/usr/share/alsa/alsa.conf $(prefix)/release_ducktrick/usr/share/alsa/alsa.conf; \
		cp $(targetprefix)/usr/share/alsa/cards/aliases.conf $(prefix)/release_ducktrick/usr/share/alsa/cards/; \
		cp $(targetprefix)/usr/share/alsa/pcm/default.conf $(prefix)/release_ducktrick/usr/share/alsa/pcm/; \
		cp $(targetprefix)/usr/share/alsa/pcm/dmix.conf $(prefix)/release_ducktrick/usr/share/alsa/pcm/; \
	fi

#
# AUTOFS
#
	if [ -d $(prefix)/release_ducktrick/usr/lib/autofs ]; then \
		cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_ducktrick/usr/sbin/; \
		cp -f $(buildprefix)/root/release/auto.hotplug $(prefix)/release_ducktrick/etc/; \
		cp -f $(buildprefix)/root/release/auto.network $(prefix)/release_ducktrick/etc/; \
		cp -f $(buildprefix)/root/release/autofs $(prefix)/release_ducktrick/etc/init.d/; \
	fi

#
# GSTREAMER
#
	if [ -d $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10 ]; then \
		#removed rm \
		rm -rf $(prefix)/release_ducktrick/usr/lib/libgstfft*; \
		rm -rf $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/*; \
		cp -a $(targetprefix)/usr/bin/gst-* $(prefix)/release_ducktrick/usr/bin/; \
		sh4-linux-strip --strip-unneeded $(prefix)/release_ducktrick/usr/bin/gst-launch*; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstalsa.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapetag.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapp.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstasf.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstassrender.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioconvert.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioparsers.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioresample.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstautodetect.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstavi.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcdxaparse.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreelements.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreindexers.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin2.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbaudiosink.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbvideosink.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvdsub.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflac.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflv.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstfragmented.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsticydemux.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstid3demux.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstisomp4.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmad.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmatroska.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegaudioparse.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegdemux.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegstream.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstogg.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstplaybin.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtmp.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtp.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtpmanager.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtsp.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubparse.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsttypefindfunctions.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstudp.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstvcdsrc.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstwavparse.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		if [ -e $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpegscale.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstpostproc.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		fi; \
		if [ -e $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/; \
		fi; \
		sh4-linux-strip --strip-unneeded $(prefix)/release_ducktrick/usr/lib/gstreamer-0.10/*; \
	fi

#
# GRAPHLCD
#
	if [ -e $(prefix)/release_ducktrick/usr/lib/libglcddrivers.so ]; then \
		cp -f $(targetprefix)/etc/graphlcd.conf $(prefix)/release_ducktrick/etc/graphlcd.conf; \
	fi

#
# minidlna
#
	if [ -e $(targetprefix)/usr/sbin/minidlna ]; then \
		cp -f $(targetprefix)/usr/sbin/minidlna $(prefix)/release_ducktrick/usr/sbin/; \
	fi

release_ducktrick_install:
	rm -rf $(prefix)/release_ducktrick_install || true
	$(INSTALL_DIR) $(prefix)/release_ducktrick_install && \
	mkdir $(prefix)/release_ducktrick_install/boot 
	cp $(prefix)/release_ducktrick/boot/uImage $(prefix)/release_ducktrick_install/boot/uImage.gz 
	ln -s $(prefix)/release_ducktrick_install/boot/uImage.gz $(prefix)/release_ducktrick_install/boot/uImage 
	cd $(prefix)/release_ducktrick && tar -czvf $(prefix)/release_ducktrick_install/Ducktrick-MultiImage-Release.tar.gz ./ > /dev/null 2>&1 
	echo "" > $(prefix)/release_ducktrick_install/install 
#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/release_ducktrick: \
$(DEPDIR)/%release_ducktrick: release_ducktrick_base release_ducktrick_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(UFS913)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CLASSIC)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX) release_ducktrick_install
	touch $@

#
# FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma2
#
	cp -RP $(buildprefix)/own_build/enigma2/* $(prefix)/release_ducktrick/

#
# release-clean
#
release_ducktrick-clean:
	rm -f $(DEPDIR)/release_ducktrick
