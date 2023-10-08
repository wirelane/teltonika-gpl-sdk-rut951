DEVICE_VARS += UBOOT_NAME UBOOT_SIZE
DEVICE_VARS += CONFIG_SIZE
DEVICE_VARS += ART_SIZE NO_ART
DEVICE_VARS += MASTER_IMAGE_SIZE

define Build/append-tlt-uboot
	dd if="$(BIN_DIR)/u-boot_$(UBOOT_NAME)$(word 1,$(1)).bin" >> $@
endef

define Build/append-tlt-config
	dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-config.bin >> $@
endef

define Build/append-tlt-art
	if [ $(NO_ART) == 1 ]; then \
		dd if=/dev/zero bs=$(ART_SIZE) count=1 >> $@; \
	elif [ "$(DEVICE_MODEL)" == "RUT2M" ]; then \
		dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-art-RUT2M.bin >> $@; \
	elif [ "$(DEVICE_MODEL)" == "RUT9M" ]; then \
		dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-art-RUT95M.bin >> $@; \
	elif [ "$(DEVICE_MODEL)" == "RUT361" ]; then \
		dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-art-RUT361.bin >> $@; \
	elif [ "$(DEVICE_MODEL)" == "TAP100" ]; then \
		dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-art-TAP100.bin >> $@; \
	elif [ "$(DEVICE_MODEL)" == "RUTM" ]; then \
		dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-art-RUTM.bin >> $@; \
	elif [ "$(DEVICE_MODEL)" == "TAP200" ]; then \
		dd if=$(TOPDIR)/target/linux/ramips/image/bin/tlt-factory-art-TAP200.bin >> $@; \
	fi
endef