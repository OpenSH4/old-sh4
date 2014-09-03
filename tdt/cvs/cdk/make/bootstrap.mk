##############################   BOOTSTRAP-HOST    #############################
#
# HOST-RPMCONFIG
#
HOST_RPMCONFIG = host-rpmconfig
HOST_RPMCONFIG_VERSION = 2.4-31
HOST_RPMCONFIG_SPEC = stm-$(HOST_RPMCONFIG).spec
HOST_RPMCONFIG_SPEC_PATCH = $(HOST_RPMCONFIG_SPEC).$(HOST_RPMCONFIG_VERSION).diff
HOST_RPMCONFIG_PATCHES = stm-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION)-ignore-skip-cvs-errors.patch \
			 stm-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION)-autoreconf-add-libtool-macros.patch

HOST_RPMCONFIG_RPM = RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm

$(HOST_RPMCONFIG_RPM): \
		$(if $(HOST_RPMCONFIG_SPEC_PATCH),Patches/$(HOST_RPMCONFIG_SPEC_PATCH)) \
		$(if $(HOST_RPMCONFIG_PATCHES),$(HOST_RPMCONFIG_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_RPMCONFIG_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_RPMCONFIG_SPEC) < $(buildprefix)/Patches/$(HOST_RPMCONFIG_SPEC_PATCH) ) &&) \
	$(if $(HOST_RPMCONFIG_PATCHES),cp $(HOST_RPMCONFIG_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_RPMCONFIG_SPEC)

$(DEPDIR)/$(HOST_RPMCONFIG): $(HOST_RPMCONFIG_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv --badreloc --relocate $(STM_RELOCATE)=$(prefix) $< && \
	touch $@

#
# HOST-LIBTOOL
#
HOST_LIBTOOL = host-libtool
HOST_LIBTOOL_VERSION = 2.2.8-4
HOST_LIBTOOL_SPEC = stm-$(HOST_LIBTOOL).spec
HOST_LIBTOOL_SPEC_PATCH =
HOST_LIBTOOL_PATCHES =

HOST_LIBTOOL_RPM = RPMS/sh4/$(STLINUX)-$(HOST_LIBTOOL)-$(HOST_LIBTOOL_VERSION).sh4.rpm

$(HOST_LIBTOOL_RPM): \
		$(if $(HOST_LIBTOOL_SPEC_PATCH),Patches/$(HOST_LIBTOOL_SPEC_PATCH)) \
		$(if $(HOST_LIBTOOL_PATCHES),$(HOST_LIBTOOL_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_LIBTOOL)-$(HOST_LIBTOOL_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_LIBTOOL_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_LIBTOOL_SPEC) < $(buildprefix)/Patches/$(HOST_LIBTOOL_SPEC_PATCH) ) &&) \
	$(if $(HOST_LIBTOOL_PATCHES),cp $(HOST_LIBTOOL_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_LIBTOOL_SPEC)

$(DEPDIR)/$(HOST_LIBTOOL): $(HOST_LIBTOOL_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST-BASE-PASSWD
#
HOST_BASE_PASSWD = host-base-passwd
HOST_BASE_PASSWD_VERSION = 3.5.9-7
HOST_BASE_PASSWD_SPEC = stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH =
HOST_BASE_PASSWD_PATCHES =

HOST_BASE_PASSWD_RPM = RPMS/sh4/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).sh4.rpm

$(HOST_BASE_PASSWD_RPM): \
		$(if $(HOST_BASE_PASSWD_SPEC_PATCH),Patches/$(HOST_BASE_PASSWD_SPEC_PATCH)) \
		$(if $(HOST_BASE_PASSWD_PATCHES),$(HOST_BASE_PASSWD_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_BASE_PASSWD_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_BASE_PASSWD_SPEC) < $(buildprefix)/Patches/$(HOST_BASE_PASSWD_SPEC_PATCH) ) &&) \
	$(if $(HOST_BASE_PASSWD_PATCHES),cp $(HOST_BASE_PASSWD_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_BASE_PASSWD_SPEC)

$(DEPDIR)/$(HOST_BASE_PASSWD): $(HOST_BASE_PASSWD_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST-DISTRIBUTIONUTILS
#
HOST_DISTRIBUTIONUTILS = host-distributionutils
HOST_DISTRIBUTIONUTILS_VERSION = 2.8.4-6
HOST_DISTRIBUTIONUTILS_SPEC = stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH =
HOST_DISTRIBUTIONUTILS_PATCHES =

HOST_DISTRIBUTIONUTILS_RPM = RPMS/$(host_arch)/$(STLINUX)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).$(host_arch).rpm

$(HOST_DISTRIBUTIONUTILS_RPM): \
		$(if $(HOST_DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(HOST_DISTRIBUTIONUTILS_PATCHES),$(HOST_DISTRIBUTIONUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STM_SRC)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_DISTRIBUTIONUTILS_SPEC) < $(buildprefix)/Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(HOST_DISTRIBUTIONUTILS_PATCHES),cp $(HOST_DISTRIBUTIONUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_DISTRIBUTIONUTILS_SPEC)

$(DEPDIR)/$(HOST_DISTRIBUTIONUTILS): $(HOST_DISTRIBUTIONUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST-LDD
#
HOST_LDD = host-ldd
HOST_LDD_VERSION = 1.0-6
HOST_LDD_SPEC = stm-$(HOST_LDD).spec
HOST_LDD_SPEC_PATCH =
HOST_LDD_PATCHES =

HOST_LDD_RPM = RPMS/sh4/$(STLINUX)-$(HOST_LDD)-$(HOST_LDD_VERSION).sh4.rpm

$(HOST_LDD_RPM): \
		$(if $(HOST_LDD_SPEC_PATCH),Patches/$(HOST_LDD_SPEC_PATCH)) \
		$(if $(HOST_LDD_PATCHES),$(HOST_LDD_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STM_SRC)-$(HOST_LDD)-$(HOST_LDD_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_LDD_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_LDD_SPEC) < $(buildprefix)/Patches/$(HOST_LDD_SPEC_PATCH) ) &&) \
	$(if $(HOST_LDD_PATCHES),cp $(HOST_LDD_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_LDD_SPEC)

$(DEPDIR)/$(HOST_LDD): $(HOST_LDD_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST AUTOTOOLS
#
HOST_AUTOTOOLS = host-autotools
HOST_AUTOTOOLS_VERSION = dev-20091012-3
HOST_AUTOTOOLS_SPEC = stm-$(HOST_AUTOTOOLS)-dev.spec
HOST_AUTOTOOLS_SPEC_PATCH =
HOST_AUTOTOOLS_PATCHES =

HOST_AUTOTOOLS_RPM = RPMS/sh4/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).sh4.rpm

$(HOST_AUTOTOOLS_RPM): \
		$(if $(HOST_AUTOTOOLS_SPEC_PATCH),Patches/$(HOST_AUTOTOOLS_SPEC_PATCH)) \
		$(if $(HOST_AUTOTOOLS_PATCHES),$(HOST_AUTOTOOLS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_AUTOTOOLS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_AUTOTOOLS_SPEC) < $(buildprefix)/Patches/$(HOST_AUTOTOOLS_SPEC_PATCH) ) &&) \
	$(if $(HOST_AUTOTOOLS_PATCHES),cp $(HOST_AUTOTOOLS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOTOOLS_SPEC)

$(DEPDIR)/$(HOST_AUTOTOOLS): $(HOST_AUTOTOOLS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST AUTOMAKE
#
HOST_AUTOMAKE = host-automake
HOST_AUTOMAKE_VERSION = 1.11.1-3
HOST_AUTOMAKE_SPEC = stm-$(HOST_AUTOMAKE).spec
HOST_AUTOMAKE_SPEC_PATCH =
HOST_AUTOMAKE_PATCHES =

HOST_AUTOMAKE_RPM = RPMS/sh4/$(STLINUX)-$(HOST_AUTOMAKE)-$(HOST_AUTOMAKE_VERSION).sh4.rpm

$(HOST_AUTOMAKE_RPM): \
		$(if $(HOST_AUTOMAKE_SPEC_PATCH),Patches/$(HOST_AUTOMAKE_SPEC_PATCH)) \
		$(if $(HOST_AUTOMAKE_PATCHES),$(HOST_AUTOMAKE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_AUTOMAKE)-$(HOST_AUTOMAKE_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_AUTOMAKE_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_AUTOMAKE_SPEC) < $(buildprefix)/Patches/$(HOST_AUTOMAKE_SPEC_PATCH) ) &&) \
	$(if $(HOST_AUTOMAKE_PATCHES),cp $(HOST_AUTOMAKE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOMAKE_SPEC)

$(DEPDIR)/$(HOST_AUTOMAKE): $(HOST_AUTOMAKE_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST AUTOCONF
#
HOST_AUTOCONF = host-autoconf
HOST_AUTOCONF_VERSION = 2.64-6
HOST_AUTOCONF_SPEC = stm-$(HOST_AUTOCONF).spec
if NEWOS
HOST_AUTOCONF_SPEC_PATCH = stm-$(HOST_AUTOCONF).$(HOST_AUTOCONF_VERSION).spec-newos.diff
HOST_AUTOCONF_PATCHES = stm-$(HOST_AUTOCONF).$(HOST_AUTOCONF_VERSION)-newos.diff
else
HOST_AUTOCONF_SPEC_PATCH = stm-$(HOST_AUTOCONF).$(HOST_AUTOCONF_VERSION).spec.diff
HOST_AUTOCONF_PATCHES = stm-$(HOST_AUTOCONF).$(HOST_AUTOCONF_VERSION).diff
endif

HOST_AUTOCONF_RPM = RPMS/sh4/$(STLINUX)-$(HOST_AUTOCONF)-$(HOST_AUTOCONF_VERSION).sh4.rpm

$(HOST_AUTOCONF_RPM): \
		$(if $(HOST_AUTOCONF_SPEC_PATCH),Patches/$(HOST_AUTOCONF_SPEC_PATCH)) \
		$(if $(HOST_AUTOCONF_PATCHES),$(HOST_AUTOCONF_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_AUTOCONF)-$(HOST_AUTOCONF_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_AUTOCONF_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_AUTOCONF_SPEC) < $(buildprefix)/Patches/$(HOST_AUTOCONF_SPEC_PATCH) ) &&) \
	$(if $(HOST_AUTOCONF_PATCHES),cp $(HOST_AUTOCONF_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOCONF_SPEC)

$(DEPDIR)/$(HOST_AUTOCONF): $(HOST_AUTOCONF_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST MODULE INIT TOOLS
#
HOST_MODINIT = host-module-init-tools
HOST_MODINIT_VERSION = 3.16-3
HOST_MODINIT_SPEC = stm-$(HOST_MODINIT).spec
HOST_MODINIT_SPEC_PATCH = $(HOST_MODINIT_SPEC).$(HOST_MODINIT_VERSION).diff
HOST_MODINIT_PATCHES = stm-$(HOST_MODINIT).$(HOST_MODINIT_VERSION)-no-man.diff

HOST_MODINIT_RPM = RPMS/sh4/$(STLINUX)-$(HOST_MODINIT)-$(HOST_MODINIT_VERSION).sh4.rpm

$(HOST_MODINIT_RPM): \
		$(if $(HOST_MODINIT_SPEC_PATCH),Patches/$(HOST_MODINIT_SPEC_PATCH)) \
		$(if $(HOST_MODINIT_PATCHES),$(HOST_MODINIT_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_MODINIT)-$(HOST_MODINIT_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_MODINIT_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_MODINIT_SPEC) < $(buildprefix)/Patches/$(HOST_MODINIT_SPEC_PATCH) ) &&) \
	$(if $(HOST_MODINIT_PATCHES),cp $(HOST_MODINIT_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_MODINIT_SPEC)

$(DEPDIR)/$(HOST_MODINIT): $(HOST_MODINIT_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST PKGCONFIG
#
HOST_PKGCONFIG = host-pkg-config
HOST_PKGCONFIG_VERSION = 0.23-3
HOST_PKGCONFIG_SPEC = stm-$(HOST_PKGCONFIG).spec
HOST_PKGCONFIG_SPEC_PATCH =
HOST_PKGCONFIG_PATCHES =

HOST_PKGCONFIG_RPM = RPMS/sh4/$(STLINUX)-$(HOST_PKGCONFIG)-$(HOST_PKGCONFIG_VERSION).sh4.rpm

$(HOST_PKGCONFIG_RPM): \
		$(if $(HOST_PKGCONFIG_SPEC_PATCH),Patches/$(HOST_PKGCONFIG_SPEC_PATCH)) \
		$(if $(HOST_PKGCONFIG_PATCHES),$(HOST_PKGCONFIG_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_PKGCONFIG)-$(HOST_PKGCONFIG_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_PKGCONFIG_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_PKGCONFIG_SPEC) < $(buildprefix)/Patches/$(HOST_PKGCONFIG_SPEC_PATCH) ) &&) \
	$(if $(HOST_PKGCONFIG_PATCHES),cp $(HOST_PKGCONFIG_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_PKGCONFIG_SPEC)

$(DEPDIR)/$(HOST_PKGCONFIG): $(HOST_PKGCONFIG_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST-MTD-UTILS
#
HOST_MTD_UTILS = host-mtd-utils
HOST_MTD_UTILS_VERSION = 1.0.1-8
HOST_MTD_UTILS_SPEC = stm-$(HOST_MTD_UTILS).spec
HOST_MTD_UTILS_SPEC_PATCH =
HOST_MTD_UTILS_PATCHES =

HOST_MTD_UTILS_RPM = RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm

$(HOST_MTD_UTILS_RPM): \
		$(if $(HOST_MTD_UTILS_SPEC_PATCH),Patches/$(HOST_MTD_UTILS_SPEC_PATCH)) \
		$(if $(HOST_MTD_UTILS_PATCHES),$(HOST_MTD_UTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/stlinux23-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_MTD_UTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_MTD_UTILS_SPEC) < $(buildprefix)/Patches/$(HOST_MTD_UTILS_SPEC_PATCH) ) &&) \
	$(if $(HOST_MTD_UTILS_PATCHES),cp $(HOST_MTD_UTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_MTD_UTILS_SPEC)

$(DEPDIR)/$(HOST_MTD_UTILS): $(HOST_MTD_UTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST FLEX
#
HOST_FLEX = host-flex
HOST_FLEX_VERSION = 2.5.35-2
HOST_FLEX_SPEC = stm-$(HOST_FLEX).spec
HOST_FLEX_SPEC_PATCH =
HOST_FLEX_PATCHES =

HOST_FLEX_RPM = RPMS/sh4/$(STLINUX)-$(HOST_FLEX)-$(HOST_FLEX_VERSION).sh4.rpm

$(HOST_FLEX_RPM): \
		$(if $(HOST_FLEX_SPEC_PATCH),Patches/$(HOST_FLEX_SPEC_PATCH)) \
		$(if $(HOST_FLEX_PATCHES),$(HOST_FLEX_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_FLEX)-$(HOST_FLEX_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_FLEX_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_FLEX_SPEC) < $(buildprefix)/Patches/$(HOST_FLEX_SPEC_PATCH) ) &&) \
	$(if $(HOST_FLEX_PATCHES),cp $(HOST_FLEX_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_FLEX_SPEC)

$(DEPDIR)/$(HOST_FLEX): $(HOST_FLEX_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST LIBFFI
#
HOST_LIBFFI = host-libffi-dev
HOST_LIBFFI_VERSION = 3.0.10-2
HOST_LIBFFI_SPEC = stm-$(HOST_LIBFFI).spec
HOST_LIBFFI_SPEC_PATCH = #$(HOST_LIBFFI_SPEC).$(HOST_LIBFFI_VERSION).diff
HOST_LIBFFI_PATCHES =

HOST_LIBFFI_RPM = RPMS/sh4/$(STLINUX)-$(HOST_LIBFFI)-$(HOST_LIBFFI_VERSION).sh4.rpm

$(HOST_LIBFFI_RPM): \
		$(if $(HOST_LIBFFI_SPEC_PATCH),Patches/$(HOST_LIBFFI_SPEC_PATCH)) \
		$(if $(HOST_LIBFFI_PATCHES),$(HOST_LIBFFI_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_LIBFFI)-$(HOST_LIBFFI_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_LIBFFI_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_LIBFFI_SPEC) < $(buildprefix)/Patches/$(HOST_LIBFFI_SPEC_PATCH) ) &&) \
	$(if $(HOST_LIBFFI_PATCHES),cp $(HOST_LIBFFI_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_LIBFFI_SPEC)

$(DEPDIR)/$(HOST_LIBFFI): $(HOST_LIBFFI_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST GLIB2
#
HOST_GLIB2 = host-glib2
HOST_GLIB2_VERSION = 2.32.1-26
HOST_GLIB2_SPEC = stm-$(HOST_GLIB2).spec
HOST_GLIB2_SPEC_PATCH = $(HOST_GLIB2_SPEC).$(HOST_GLIB2_VERSION).diff
HOST_GLIB2_PATCHES =

HOST_GLIB2_RPM = RPMS/sh4/$(STLINUX)-$(HOST_GLIB2)-$(HOST_GLIB2_VERSION).sh4.rpm

$(HOST_GLIB2_RPM): \
		$(if $(HOST_GLIB2_SPEC_PATCH),Patches/$(HOST_GLIB2_SPEC_PATCH)) \
		$(if $(HOST_GLIB2_PATCHES),$(HOST_GLIB2_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(HOST_GLIB2)-$(HOST_GLIB2_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_GLIB2_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_GLIB2_SPEC) < $(buildprefix)/Patches/$(HOST_GLIB2_SPEC_PATCH) ) &&) \
	$(if $(HOST_GLIB2_PATCHES),cp $(HOST_GLIB2_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_GLIB2_SPEC)

$(DEPDIR)/$(HOST_GLIB2): $(HOST_LIBFFI) $(HOST_GLIB2_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

##############################   BOOTSTRAP-CROSS   #############################
#
# CROSS_DISTRIBUTIONUTILS
#
CROSS_DISTRIBUTIONUTILS = cross-sh4-distributionutils
CROSS_DISTRIBUTIONUTILS_VERSION = 1.14-6
CROSS_DISTRIBUTIONUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH =
CROSS_DISTRIBUTIONUTILS_PATCHES =

CROSS_DISTRIBUTIONUTILS_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).$(host_arch).rpm

$(CROSS_DISTRIBUTIONUTILS_RPM): \
		$(if $(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(CROSS_DISTRIBUTIONUTILS_PATCHES),$(CROSS_DISTRIBUTIONUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS))-$(CROSS_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_DISTRIBUTIONUTILS_SPEC) < $(buildprefix)/Patches/$(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(CROSS_DISTRIBUTIONUTILS_PATCHES),cp $(CROSS_DISTRIBUTIONUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_DISTRIBUTIONUTILS_SPEC)

$(DEPDIR)/$(CROSS_DISTRIBUTIONUTILS): $(CROSS_DISTRIBUTIONUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# CROSS BINUTILS
#
CROSS_BINUTILS = cross-sh4-binutils
CROSS_BINUTILS_DEV = cross-sh4-binutils-dev
CROSS_BINUTILS_VERSION =  2.22-64
CROSS_BINUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec
if NEWOS
CROSS_BINUTILS_SPEC_PATCH = $(CROSS_BINUTILS_SPEC).$(CROSS_BINUTILS_VERSION)-newos.diff
CROSS_BINUTILS_PATCHES = stm-cross-binutils.$(CROSS_BINUTILS_VERSION)-newos.diff
else
CROSS_BINUTILS_SPEC_PATCH = $(CROSS_BINUTILS_SPEC).$(CROSS_BINUTILS_VERSION).diff
CROSS_BINUTILS_PATCHES =
endif

CROSS_BINUTILS_RPM = RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm
CROSS_BINUTILS_DEV_RPM = RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS_DEV)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm

$(CROSS_BINUTILS_RPM) $(CROSS_BINUTILS_DEV_RPM) : \
		$(if $(CROSS_BINUTILS_SPEC_PATCH),Patches/$(CROSS_BINUTILS_SPEC_PATCH)) \
		$(if $(CROSS_BINUTILS_PATCHES),$(CROSS_BINUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_BINUTILS))-$(CROSS_BINUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_BINUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_BINUTILS_SPEC) < $(buildprefix)/Patches/$(CROSS_BINUTILS_SPEC_PATCH) ) &&) \
	$(if $(CROSS_BINUTILS_PATCHES),cp $(CROSS_BINUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_BINUTILS_SPEC)

$(DEPDIR)/$(CROSS_BINUTILS): $(CROSS_BINUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

$(DEPDIR)/$(CROSS_BINUTILS_DEV): $(CROSS_BINUTILS_DEV_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps --noscripts -Uhv $< && \
	touch $@

#
# CROSS GMP
#
CROSS_GMP = cross-sh4-gmp
CROSS_GMP_VERSION = 5.1.0-11
CROSS_GMP_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_GMP)).spec
CROSS_GMP_SPEC_PATCH =
CROSS_GMP_PATCHES =

CROSS_GMP_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GMP)-$(CROSS_GMP_VERSION).$(host_arch).rpm

$(CROSS_GMP_RPM): \
		$(if $(CROSS_GMP_SPEC_PATCH),Patches/$(CROSS_GMP_SPEC_PATCH)) \
		$(if $(CROSS_GMP_PATCHES),$(CROSS_GMP_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_GMP))-$(CROSS_GMP_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_GMP_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_GMP_SPEC) < $(buildprefix)/Patches/$(CROSS_GMP_SPEC_PATCH) ) &&) \
	$(if $(CROSS_GMP_PATCHES),cp $(CROSS_GMP_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_GMP_SPEC)

$(DEPDIR)/$(CROSS_GMP): $(CROSS_GMP_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@

#
# CROSS MPFR
#
CROSS_MPFR = cross-sh4-mpfr
CROSS_MPFR_VERSION = 3.1.1-11
CROSS_MPFR_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_MPFR)).spec
CROSS_MPFR_SPEC_PATCH =
CROSS_MPFR_PATCHES =

CROSS_MPFR_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_MPFR)-$(CROSS_MPFR_VERSION).$(host_arch).rpm

$(CROSS_MPFR_RPM): \
		$(if $(CROSS_MPFR_SPEC_PATCH),Patches/$(CROSS_MPFR_SPEC_PATCH)) \
		$(if $(CROSS_MPFR_PATCHES),$(CROSS_MPFR_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_MPFR))-$(CROSS_MPFR_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_MPFR_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_MPFR_SPEC) < $(buildprefix)/Patches/$(CROSS_MPFR_SPEC_PATCH) ) &&) \
	$(if $(CROSS_MPFR_PATCHES),cp $(CROSS_MPFR_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_MPFR_SPEC)

$(DEPDIR)/$(CROSS_MPFR): $(CROSS_MPFR_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@

#
# CROSS MPC
#
CROSS_MPC = cross-sh4-mpc
CROSS_MPC_VERSION = 1.0.1-5
CROSS_MPC_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_MPC)).spec
CROSS_MPC_SPEC_PATCH =
CROSS_MPC_PATCHES =

CROSS_MPC_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_MPC)-$(CROSS_MPC_VERSION).$(host_arch).rpm

$(CROSS_MPC_RPM): \
		$(if $(CROSS_MPC_SPEC_PATCH),Patches/$(CROSS_MPC_SPEC_PATCH)) \
		$(if $(CROSS_MPC_PATCHES),$(CROSS_MPC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_MPC))-$(CROSS_MPC_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_MPC_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_MPC_SPEC) < $(buildprefix)/Patches/$(CROSS_MPC_SPEC_PATCH) ) &&) \
	$(if $(CROSS_MPC_PATCHES),cp $(CROSS_MPC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_MPC_SPEC)

$(DEPDIR)/$(CROSS_MPC): $(CROSS_MPC_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@

#
# CROSS GCC
#
CROSS_GCC = cross-sh4-gcc
CROSS_CPP = cross-sh4-cpp
CROSS_G++ = cross-sh4-g++
CROSS_PROTOIZE = cross-sh4-protoize
CROSS_LIBGCC = cross-sh4-libgcc
if GCC47
CROSS_GCC_VERSION = 4.7.2-114
else
if GCC48
CROSS_GCC_VERSION = 4.8.2-131
else
CROSS_GCC_VERSION = 4.6.3-111
endif
endif
CROSS_GCC_RAWVERSION = $(firstword $(subst -, ,$(CROSS_GCC_VERSION)))
CROSS_GCC_SPEC = stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec
if NEWOS
CROSS_GCC_SPEC_PATCH = $(CROSS_GCC_SPEC).$(CROSS_GCC_VERSION)-newos.diff
CROSS_GCC_P = stm-cross-gcc.$(CROSS_GCC_VERSION)-newos.diff
else
CROSS_GCC_SPEC_PATCH = $(CROSS_GCC_SPEC).$(CROSS_GCC_VERSION).diff
CROSS_GCC_P = stm-cross-gcc.$(CROSS_GCC_VERSION).diff
endif

if GCC48
CROSS_GCC_PATCHES = $(CROSS_GCC_P)
else
CROSS_GCC_PATCHES =
endif

CROSS_GCC_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GCC)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_CPP_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_CPP)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_G++_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_PROTOIZE_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_PROTOIZE)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_LIBGCC_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).$(host_arch).rpm

$(CROSS_GCC_RPM) $(CROSS_CPP_RPM) $(CROSS_G++_RPM) $(CROSS_PROTOIZE_RPM) $(CROSS_LIBGCC_RPM): \
		$(if $(CROSS_GCC_SPEC_PATCH),Patches/$(CROSS_GCC_SPEC_PATCH)) \
		$(if $(CROSS_GCC_PATCHES),$(CROSS_GCC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_GCC))-$(CROSS_GCC_VERSION).src.rpm \
		| $(archivedir)/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm \
		$(archivedir)/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm \
		$(if $(KERNELHEADERS),$(KERNELHEADERS)) \
		kernel-headers
	rpm $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(STM_RELOCATE)/devkit/sh4/target=$(targetprefix) $(word 1,$|) && \
	rpm $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(STM_RELOCATE)/devkit/sh4/target=$(targetprefix) $(word 2,$|)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_GCC_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_GCC_SPEC) < $(buildprefix)/Patches/$(CROSS_GCC_SPEC_PATCH) ) &&) \
	$(if $(CROSS_GCC_PATCHES),cp $(CROSS_GCC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_GCC_SPEC)
	rpm $(DRPM) --nodeps -ev $(STLINUX)-sh4-$(GLIBC_DEV) && \
	rpm $(DRPM) --nodeps -ev $(STLINUX)-sh4-$(GLIBC)

$(DEPDIR)/$(CROSS_GCC): $(CROSS_GCC_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

$(DEPDIR)/$(CROSS_CPP): $(CROSS_CPP_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

$(DEPDIR)/$(CROSS_G++): $(CROSS_G++_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

$(DEPDIR)/$(CROSS_LIBGCC): \
$(DEPDIR)/%$(CROSS_LIBGCC): $(CROSS_LIBGCC_RPM) | $(DEPDIR)/%$(GLIBC)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb  $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@

$(DEPDIR)/$(CROSS_PROTOIZE): $(CROSS_PROTOIZE_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

##############################                     #############################
#
# HOST-FILESYSTEM
#
host-filesystem:
	$(INSTALL) -d $(prefix)
	$(INSTALL) -d $(configprefix)
	$(INSTALL) -d $(devkitprefix)
	$(INSTALL) -d $(hostprefix)
	$(INSTALL) -d $(hostprefix)/{bin,doc,etc,include,info,lib,man,share,var}
	ln -sf $(hostprefix)/lib $(hostprefix)/lib64
	$(INSTALL) -d $(hostprefix)/man/man{1,2,3,4,5,6,7,8,9}
	touch .deps/$@

#
# CROSS_FILESYSTEM
#
cross-sh4-filesystem:
	$(INSTALL) -d $(targetprefix)
	$(INSTALL) -d $(crossprefix)
	$(INSTALL) -d $(crossprefix)/{bin,doc,etc,include,lib,man,sh4-linux,share,var}
	ln -s /$(crossprefix)/lib $(crossprefix)/lib64
	$(INSTALL) -d $(crossprefix)/man/man{1,2,3,4,5,6,7,8,9}
	$(INSTALL) -d $(crossprefix)/sh4-linux/{bin,include,lib}
	touch .deps/$@

#
# BOOTSTRAP-HOST
#
$(DEPDIR)/bootstrap-host: | \
	host-filesystem \
	cross-sh4-filesystem \
	$(CCACHE) \
	libtool \
	host-rpmconfig \
	host-base-passwd \
	host-distributionutils \
	host-autoconf \
	host-autotools \
	host-automake \
	pkg_config \
	host-mtd-utils \
	host-module-init-tools
	touch $@

#
# BOOTSTRAP-CROSS
#
$(DEPDIR)/bootstrap-cross: | \
	bootstrap-host \
	cross-sh4-distributionutils \
	cross-sh4-binutils \
	cross-sh4-binutils-dev \
	cross-sh4-gmp \
	cross-sh4-mpfr \
	cross-sh4-mpc \
	cross-sh4-cpp \
	cross-sh4-gcc \
	cross-sh4-g++ \
	cross-sh4-libgcc
	touch $@

$(DEPDIR)/setup-cross-doc: \
	cross-binutils-doc \
	cross-sh4-cpp-doc \
	cross-sh4-gcc-doc \
	cross-sh4-g++-doc

$(DEPDIR)/setup-cross-optional: \
	cross-sh4-protoize

#
# LIBTOOL
#
$(DEPDIR)/libtool.do_prepare: @DEPENDS_libtool@
	@PREPARE_libtool@
	touch $@

$(DEPDIR)/libtool.do_compile: $(DEPDIR)/libtool.do_prepare
	cd @DIR_libtool@ && \
	./configure \
		lt_cv_sys_lib_search_path_spec="$(targetprefix)/usr/lib" \
		lt_cv_sys_lib_dlsearch_path_spec="$(targetprefix)/usr/lib" \
		lt_cv_sys_dlsearch_path="$(targetprefix)/usr/lib" \
		--prefix=$(hostprefix) && \
	$(MAKE)
	touch $@

$(DEPDIR)/libtool: $(DEPDIR)/libtool.do_compile
	cd @DIR_libtool@ && \
	@INSTALL_libtool@
	@DISTCLEANUP_libtool@
	touch $@

#
# pkg_config
#
$(DEPDIR)/pkg_config.do_prepare: @DEPENDS_pkg_config@
	@PREPARE_pkg_config@
	touch $@

$(DEPDIR)/pkg_config.do_compile: $(DEPDIR)/pkg_config.do_prepare
	cd @DIR_pkg_config@ && \
	./configure \
		--prefix=$(hostprefix) \
		--with-pc_path=$(PKG_CONFIG_PATH) && \
	$(MAKE)
	touch $@

$(DEPDIR)/pkg_config: $(DEPDIR)/pkg_config.do_compile
	cd @DIR_pkg_config@ && \
	@INSTALL_pkg_config@
		ln -sf $(hostprefix)/bin/pkg-config $(crossprefix)/bin/$(target)-pkg-config
	@DISTCLEANUP_pkg_config@
	touch $@

