# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2008-2011 OpenWrt.org

include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=ramips
BOARDNAME:=MediaTek Ralink MIPS
SUBTARGETS:=mt76x8 mt7621
FEATURES:=squashfs gpio

KERNEL_PATCHVER:=5.4
KERNEL_TESTING_PATCHVER:=5.4

ifeq ($(SUBTARGET),mt7621)
KERNEL_PATCHVER:=5.10
KERNEL_TESTING_PATCHVER:=5.10
FEATURES += smp
endif

define Target/Description
	Build firmware images for Ralink RT288x/RT3xxx based boards.
endef

include $(INCLUDE_DIR)/target.mk
include $(INCLUDE_DIR)/target-gpl.mk

define GPL/Target/Build
	$(GPL/Target/Build/Default)

	find "$(1)" -maxdepth 1 \
		-type d -iname "patches-*" ! -iname "*$(KERNEL_PATCHVER)" \
		-exec rm -rf {} \;
	find "$(1)" -maxdepth 1 \
		-type d -iname "files-*" ! -iname "*$(KERNEL_PATCHVER)" \
		-exec rm -rf {} \;
endef

DEFAULT_PACKAGES += kmod-leds-gpio tc-tiny

$(eval $(call BuildTarget))
