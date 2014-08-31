#
# IMPORTANT: it is expected that only one define is set
#

#
# Patches Kernel 24
#

if ENABLE_P0211
PATCH_STR=_0211
endif
if ENABLE_P0215
PATCH_STR=_0215
endif

STM24_DVB_PATCH = linux-sh4-linuxdvb_stm24$(PATCH_STR).patch

COMMONPATCHES_24 = \
		$(STM24_DVB_PATCH) \
		linux-sh4-sound_stm24$(PATCH_STR).patch \
		linux-sh4-time_stm24$(PATCH_STR).patch \
		linux-sh4-init_mm_stm24$(PATCH_STR).patch \
		linux-sh4-copro_stm24$(PATCH_STR).patch \
		linux-sh4-strcpy_stm24$(PATCH_STR).patch \
		linux-sh4-ext23_as_ext4_stm24$(PATCH_STR).patch \
		bpa2_procfs_stm24$(PATCH_STR).patch \
		linux-ftdi_sio.c_stm24$(PATCH_STR).patch \
		linux-sh4-lzma-fix_stm24$(PATCH_STR).patch \
		linux-tune_stm24.patch \
		linux-sh4-mmap_stm24.patch \
		$(if $(P0211),linux-sh4-remove_pcm_reader_stm24.patch)

HL101_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-hl101_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		gpio_p0211.patch


KERNELPATCHES_24 = \
		$(if $(HL101),$(HL101_PATCHES_24))

#
# KERNEL-HEADERS
#
$(DEPDIR)/kernel-headers: linux-kernel.do_prepare
	cd $(KERNEL_DIR) && \
		$(INSTALL) -d $(targetprefix)/usr/include && \
		cp -a include/linux $(targetprefix)/usr/include && \
		cp -a include/asm-sh $(targetprefix)/usr/include/asm && \
		cp -a include/asm-generic $(targetprefix)/usr/include && \
		cp -a include/mtd $(targetprefix)/usr/include
	touch $@

KERNELHEADERS := linux-kernel-headers

if ENABLE_P0211
KERNELHEADERS_VERSION := 2.6.32.46-45
#else
#KERNELHEADERS_VERSION := 2.6.32.10_stm24_0201-42
endif

if ENABLE_P0215
KERNELHEADERS_VERSION := 2.6.32.46-45
endif

KERNELHEADERS_SPEC := stm-target-kernel-headers-kbuild.spec
KERNELHEADERS_SPEC_PATCH :=
KERNELHEADERS_PATCHES :=

KERNELHEADERS_RPM := RPMS/noarch/$(STLINUX)-sh4-$(KERNELHEADERS)-$(KERNELHEADERS_VERSION).noarch.rpm

$(KERNELHEADERS_RPM): \
		$(if $(KERNELHEADERS_SPEC_PATCH),Patches/$(KERNELHEADERS_SPEC_PATCH)) \
		$(if $(KERNELHEADERS_PATCHES),$(KERNELHEADERS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(KERNELHEADERS)-$(KERNELHEADERS_VERSION).src.rpm \
		| linux-kernel.do_prepare
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(KERNELHEADERS_SPEC_PATCH),( cd SPECS && patch -p1 $(KERNELHEADERS_SPEC) < $(buildprefix)/Patches/$(KERNELHEADERS_SPEC_PATCH) ) &&) \
	$(if $(KERNELHEADERS_PATCHES),cp $(KERNELHEADERS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(KERNELHEADERS_SPEC)

$(DEPDIR)/$(KERNELHEADERS): \
$(DEPDIR)/%$(KERNELHEADERS): $(KERNELHEADERS_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# HOST-KERNEL
#
# IMPORTANT: it is expected that only one define is set
MODNAME = $(UFS910)$(UFS912)$(UFS913)$(SPARK)$(SPARK7162)$(UFS922)$(TF7700)$(HL101)$(CLASSIC)$(VIP1_V2)$(VIP2_V1)$(CUBEMOD)$(FORTIS_HDBOX)$(ATEVIO7500)$(OCTAGON1008)$(HS7810A)$(HS7110)$(WHITEBOX)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)

if DEBUG
DEBUG_STR=.debug
else !DEBUG
DEBUG_STR=
endif !DEBUG

HOST_KERNEL := host-kernel

if ENABLE_P0211
HOST_KERNEL_VERSION := 2.6.32.59$(KERNELSTMLABEL)-$(KERNELLABEL)
endif

if ENABLE_P0215
HOST_KERNEL_VERSION = 2.6.32.61$(KERNELSTMLABEL)-$(KERNELLABEL)
endif


HOST_KERNEL_SPEC := stm-$(HOST_KERNEL)-sh4.spec
HOST_KERNEL_SPEC_PATCH :=
HOST_KERNEL_PATCHES := $(KERNELPATCHES_24)
HOST_KERNEL_CONFIG := linux-sh4-$(subst _stm24_,-,$(KERNELVERSION))_$(MODNAME).config$(DEBUG_STR)
HOST_KERNEL_SRC_RPM := $(STLINUX)-$(HOST_KERNEL)-source-sh4-$(HOST_KERNEL_VERSION).src.rpm
HOST_KERNEL_RPM := RPMS/noarch/$(STLINUX)-$(HOST_KERNEL)-source-sh4-$(HOST_KERNEL_VERSION).noarch.rpm

$(HOST_KERNEL_RPM): \
		$(if $(HOST_KERNEL_SPEC_PATCH),Patches/$(HOST_KERNEL_SPEC_PATCH)) \
		$(archivedir)/$(HOST_KERNEL_SRC_RPM)
	rpm $(DRPM) --nosignature --nodeps -Uhv $(lastword $^) && \
	$(if $(HOST_KERNEL_SPEC_PATCH),( cd SPECS; patch -p1 $(HOST_KERNEL_SPEC) < $(buildprefix)/Patches/$(HOST_KERNEL_SPEC_PATCH) ) &&) \
	rpmbuild $(DRPMBUILD) -ba -v --clean --target=sh4-linux SPECS/$(HOST_KERNEL_SPEC)

$(DEPDIR)/linux-kernel.do_prepare: \
		$(if $(HOST_KERNEL_PATCHES),$(HOST_KERNEL_PATCHES:%=Patches/%)) \
		$(HOST_KERNEL_RPM)
	@rpm $(DRPM) -ev $(HOST_KERNEL_SRC_RPM:%.src.rpm=%) || true
	rm -rf $(KERNEL_DIR)
	rm -rf linux{,-sh4}
	rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^)
	$(if $(HOST_KERNEL_PATCHES),cd $(KERNEL_DIR) && cat $(HOST_KERNEL_PATCHES:%=$(buildprefix)/Patches/%) | patch -p1)
	$(INSTALL) -m644 Patches/$(HOST_KERNEL_CONFIG) $(KERNEL_DIR)/.config
	-rm $(KERNEL_DIR)/localversion*
	echo "$(KERNELSTMLABEL)" > $(KERNEL_DIR)/localversion-stm
	if [ `grep -c "CONFIG_BPA2_DIRECTFBOPTIMIZED" $(KERNEL_DIR)/.config` -eq 0 ]; then echo "# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set" >> $(KERNEL_DIR)/.config; fi
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh oldconfig
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/asm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/linux/version.h
	rm $(KERNEL_DIR)/.config
	touch $@

GRAPHICFWDIRECTFB_SED_CONF=-i s"/^CONFIG_BPA2_DIRECTFBOPTIMIZED=y/\# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set/"

NFS_FLASH_SED_CONF=$(foreach param,XCONFIG_NFS_FS XCONFIG_LOCKD XCONFIG_SUNRPC,-e s"/^.*$(param)[= ].*/$(param)=m/")

if ENABLE_XFS
XFS_SED_CONF=$(foreach param,CONFIG_XFS_FS,-e s"/^.*$(param)[= ].*/$(param)=m/")
else
XFS_SED_CONF=-e ""
endif

if ENABLE_NFSSERVER
#NFSSERVER_SED_CONF=$(foreach param,CONFIG_NFSD CONFIG_NFSD_V3 CONFIG_NFSD_TCP,-e s"/^.*$(param)[= ].*/$(param)=y/")
NFSSERVER_SED_CONF=$(foreach param,CONFIG_NFSD,-e s"/^.*$(param)[= ].*/$(param)=y\nCONFIG_NFSD_V3=y\n\# CONFIG_NFSD_V3_ACL is not set\n\# CONFIG_NFSD_V4 is not set\nCONFIG_NFSD_TCP=y/")
else
NFSSERVER_SED_CONF=-e ""
endif

if ENABLE_NTFS
NTFS_SED_CONF=$(foreach param,CONFIG_NTFS_FS,-e s"/^.*$(param)[= ].*/$(param)=m/")
else
NTFS_SED_CONF=-e ""
endif

$(DEPDIR)/linux-kernel.do_compile: \
		bootstrap-cross \
		linux-kernel.do_prepare \
		Patches/$(HOST_KERNEL_CONFIG) \
		| $(HOST_U_BOOT_TOOLS)
	cd $(KERNEL_DIR) && \
		export PATH=$(hostprefix)/bin:$(PATH) && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper && \
		@M4@ $(buildprefix)/Patches/$(HOST_KERNEL_CONFIG) > .config && \
	if [ `grep -c "CONFIG_BPA2_DIRECTFBOPTIMIZED" .config` -eq 0 ]; then echo "# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set" >> .config; fi && \
		sed $(GRAPHICFWDIRECTFB_SED_CONF) .config && \
		sed $(NFS_FLASH_SED_CONF) -i .config && \
		sed $(XFS_SED_CONF) $(NFSSERVER_SED_CONF) $(NTFS_SED_CONF) -i .config && \
		$(MAKE) $(if $(TF7700),TF7700=y) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

$(DEPDIR)/linux-kernel: \
$(DEPDIR)/%linux-kernel: bootstrap $(DEPDIR)/linux-kernel.do_compile
	@$(INSTALL) -d $(prefix)/$*cdkroot/boot && \
	$(INSTALL) -d $(prefix)/$*$(notdir $(bootprefix)) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/arch/sh/boot/uImage $(prefix)/$*$(notdir $(bootprefix))/vmlinux.ub && \
	$(INSTALL) -m644 $(KERNEL_DIR)/vmlinux $(prefix)/$*cdkroot/boot/vmlinux-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/System.map $(prefix)/$*cdkroot/boot/System.map-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/COPYING $(prefix)/$*cdkroot/boot/LICENSE && \
	cp $(KERNEL_DIR)/arch/sh/boot/uImage $(prefix)/$*cdkroot/boot/ && \
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh INSTALL_MOD_PATH=$(prefix)/$*cdkroot modules_install && \
	rm $(prefix)/$*cdkroot/lib/modules/$(KERNELVERSION)/build || true && \
	rm $(prefix)/$*cdkroot/lib/modules/$(KERNELVERSION)/source || true
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/driver: $(driverdir)/Makefile linux-kernel.do_compile
	$(if $(PLAYER191),cp $(driverdir)/stgfb/stmfb/linux/drivers/video/stmfb.h $(targetprefix)/usr/include/linux)
	cp $(driverdir)/player2/linux/include/linux/dvb/stm_ioctls.h $(targetprefix)/usr/include/linux/dvb
	$(MAKE) -C $(driverdir) ARCH=sh \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		$(DRIVER_PLATFORM) \
		CROSS_COMPILE=$(target)-
	$(MAKE) -C $(driverdir) ARCH=sh \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		BIN_DEST=$(targetprefix)/bin \
		INSTALL_MOD_PATH=$(targetprefix) \
		DEPMOD=$(DEPMOD) \
		$(DRIVER_PLATFORM) \
		install
	$(MAKE) -C $(driverdir)/wireless/8812au ARCH=sh \
	 	KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		$(DRIVER_PLATFORM) \
		KVER=$(KERNELVERSION) \
		KSRC=$(buildprefix)/$(KERNEL_DIR) \
		CROSS_COMPILE=$(target)-
	mkdir -p $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/8812au
	$(MAKE) -C $(driverdir)/wireless/8812au ARCH=sh \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		$(DRIVER_PLATFORM) \
		KVER=$(KERNELVERSION) \
		KSRC=$(buildprefix)/$(KERNEL_DIR) \
		CROSS_COMPILE=$(target)- \
		MODDESTDIR=$(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/8812au/ \
		DEPMODDESTDIR=$(targetprefix) \
		install

	$(DEPMOD) -ae -b $(targetprefix) -F $(buildprefix)/$(KERNEL_DIR)/System.map -r $(KERNELVERSION)
	touch $@
	@TUXBOX_YAUD_CUSTOMIZE@

driver-clean:
	rm -f $(DEPDIR)/driver
	$(MAKE) -C $(driverdir) ARCH=sh \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		distclean

#
# Helper
#
linux-kernel.menuconfig linux-kernel.xconfig: \
linux-kernel.%:
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh CROSS_COMPILE=sh4-linux- $*
	@echo
	@echo "You have to edit m a n u a l l y Patches/linux-$(KERNELVERSION).config to make changes permanent !!!"
	@echo ""
	diff $(KERNEL_DIR)/.config.old $(KERNEL_DIR)/.config
	@echo ""
