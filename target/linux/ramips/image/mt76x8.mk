#
# MT76x8 Profiles
#

include common-teltonika.mk

KERNEL_LOADADDR := 0x80000000

define Device/tlt-mt7628-common
	SOC := mt7628an

	DEVICE_FEATURES := small_flash sw-offload
	MTDPARTS :=
	BLOCKSIZE := 64k
	KERNEL := kernel-bin | append-dtb | lzma | uImage lzma
	KERNEL_INITRAMFS := kernel-bin | append-dtb | lzma | uImage lzma
	DEVICE_DTS = $$(SOC)_$(1)

	UBOOT_SIZE := 131072
	CONFIG_SIZE := 65536
	ART_SIZE := 196608
	NO_ART := 0
	IMAGE_SIZE := 15424k
	MASTER_IMAGE_SIZE := 16384k

	IMAGE/sysupgrade.bin = \
			append-kernel | pad-to $$$$(BLOCKSIZE) | \
			append-rootfs | pad-rootfs | append-metadata | \
			check-size $$$$(IMAGE_SIZE) | finalize-tlt-webui

	IMAGE/master_fw.bin = \
			append-tlt-uboot | pad-to $$$$(UBOOT_SIZE) | \
			append-tlt-config | pad-to $$$$(CONFIG_SIZE) | \
			append-tlt-art | pad-to $$$$(ART_SIZE) | \
			append-kernel | pad-to $$$$(BLOCKSIZE) | \
			append-rootfs | pad-rootfs | \
			append-version | \
			check-size $$$$(MASTER_IMAGE_SIZE) | \
			finalize-tlt-master-stendui
endef

define Device/teltonika_trb2m
	$(Device/tlt-mt7628-common)
	IMAGE/master_fw.bin = \
		append-tlt-uboot | pad-to $$$$(UBOOT_SIZE) | \
		append-tlt-config | pad-to $$$$(CONFIG_SIZE) | \
		append-kernel | pad-to $$$$(BLOCKSIZE) | \
		append-rootfs | pad-rootfs | \
		append-version | \
		check-size $$$$(MASTER_IMAGE_SIZE) | \
		finalize-tlt-master-stendui
	DEVICE_MODEL := TRB2M
	DEVICE_FEATURES += gateway pppmobile gps serial serial-reset-quirk modbus io single-port dualsim bacnet ntrip
	UBOOT_NAME := tlt-trb2m
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.5
	# Default common packages for TRB2M series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Essential must-have:
	DEVICE_PACKAGES := kmod-spi-gpio

	# USB related:
	DEVICE_PACKAGES += kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport \
			   kmod-usb-serial-pl2303 kmod-cypress-serial
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
endef
TARGET_DEVICES += teltonika_trb2m

define Device/teltonika_tap100
	$(Device/tlt-mt7628-common)
	DEVICE_MODEL := TAP100
	DEVICE_FEATURES := vendor_wifi access-point single-port wifi
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.4
	UBOOT_NAME := tlt-tap100
	# Default common packages for TAP100 series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	# Wireless related:
	DEVICE_PACKAGES += kmod-mt7628-netlink kmod-mt7628 mt7628-agent
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
endef
TARGET_DEVICES += teltonika_tap100

define Device/teltonika_otd140
	$(Device/tlt-mt7628-common)
	IMAGE/master_fw.bin = \
		append-tlt-uboot | pad-to $$$$(UBOOT_SIZE) | \
		append-tlt-config | pad-to $$$$(CONFIG_SIZE) | \
		append-kernel | pad-to $$$$(BLOCKSIZE) | \
		append-rootfs | pad-rootfs | \
		check-size $$$$(MASTER_IMAGE_SIZE) | \
		finalize-tlt-master-stendui
	DEVICE_MODEL := OTD140
	DEVICE_FEATURES += ncm rndis poe mobile dualsim
	UBOOT_NAME := tlt-otd140
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.4.4
	# Default common packages for OTD140 series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# USB related:
	DEVICE_PACKAGES += kmod-usb2 kmod-usb-ohci kmod-i2c-mt7628
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
endef
TARGET_DEVICES += teltonika_otd140

define Device/teltonika_rut2m
	$(Device/tlt-mt7628-common)
	DEVICE_MODEL := RUT2M
	DEVICE_FEATURES += io wifi rndis vendor_wifi
	UBOOT_NAME := tlt-rut2m
	# Default common packages for RUT241, RUT200 series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# USB related:
	DEVICE_PACKAGES += kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport

	# Wireless related:
	DEVICE_PACKAGES += kmod-mt7628-netlink kmod-mt7628 mt7628-agent
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
endef
TARGET_DEVICES += teltonika_rut2m

define Device/teltonika_rut301
	$(Device/tlt-mt7628-common)
	IMAGE/master_fw.bin = \
		append-tlt-uboot | pad-to $$$$(UBOOT_SIZE) | \
		append-tlt-config | pad-to $$$$(CONFIG_SIZE) | \
		append-kernel | pad-to $$$$(BLOCKSIZE) | \
		append-rootfs | pad-rootfs | \
		append-version | \
		check-size $$$$(MASTER_IMAGE_SIZE) | \
		finalize-tlt-master-stendui
	DEVICE_MODEL := RUT301
	DEVICE_FEATURES += usb-port serial io port-mirror basic-router
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.4.1
	UBOOT_NAME := tlt-rut301
	# Default common packages for RUT301
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# USB related:
	DEVICE_PACKAGES += kmod-usb2 kmod-usb-ohci
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
endef
TARGET_DEVICES += teltonika_rut301

define Device/teltonika_rut361
	$(Device/tlt-mt7628-common)
	DEVICE_MODEL := RUT361
	DEVICE_FEATURES += io wifi rndis vendor_wifi
	UBOOT_NAME := tlt-rut361
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.4.1
	# Default common packages for RUT361
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# USB related:
	DEVICE_PACKAGES += kmod-usb2 kmod-usb-ohci

	# Wireless related:
	DEVICE_PACKAGES += kmod-mt7628-netlink kmod-mt7628 mt7628-agent
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
endef
TARGET_DEVICES += teltonika_rut361

define Device/teltonika_rut9m
	$(Device/tlt-mt7628-common)
	DEVICE_MODEL := RUT9M
	DEVICE_FEATURES += gps usb-port serial modbus io wifi dualsim rndis ncm bacnet ntrip vendor_wifi
	UBOOT_NAME := tlt-rut9m
	# Default common packages for RUT9M series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Essential must-have:
	DEVICE_PACKAGES := kmod-spi-gpio kmod-gpio-nxp-74hc164 kmod-i2c-mt7628 \
			   kmod-hwmon-mcp3021 kmod-hwmon-tla2021 kmod-cypress-serial

	# USB related:
	DEVICE_PACKAGES += kmod-usb2

	# Wireless related:
	DEVICE_PACKAGES += kmod-mt7628-netlink kmod-mt7628 mt7628-agent
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	HW_MODS := mod1%2c7c_6005
endef
TARGET_DEVICES += teltonika_rut9m
