#
# MT7621 Profiles
#

include common-teltonika.mk

KERNEL_LOADADDR := 0x80001000

define Device/teltonika_tap200
	$(Device/DefaultTeltonika)
	SOC := mt7621
	DEVICE_MODEL := TAP200
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.5
	DEVICE_FEATURES := access-point single-port wifi ledman-full small_flash
	DEVICE_DTS := mt7621-teltonika-tap200
	KERNEL := kernel-bin | append-dtb | lzma | uImage lzma
	BLOCKSIZE := 64k
	PAGESIZE := 2048
	FILESYSTEMS := squashfs

	UBOOT_NAME := tlt-mt7621
	# UBOOT_SIZE = "u-boot" + "u-boot-env"
	UBOOT_SIZE := 327680
	CONFIG_SIZE := 65536
	ART_SIZE := 65536
	NO_ART := 0
	IMAGE_SIZE := 15335k
	MASTER_IMAGE_SIZE := 15335k

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

	DEVICE_PACKAGES := kmod-gpio-nxp-74hc164 kmod-mt7621-qtn-rgmii \
			   kmod-mt7615e kmod-mt7615-common kmod-mt7615-firmware kmod-spi-gpio \
			   kmod-mtk-eip93

endef
TARGET_DEVICES += teltonika_tap200

define Device/teltonika_rutm
	$(Device/DefaultTeltonika)
	SOC := mt7621
	DEVICE_MODEL := RUTM
	DEVICE_DTS := $(foreach dts,$(notdir $(wildcard $(PLATFORM_DIR)/dts/mt7621-teltonika-rutm*.dts)),$(patsubst %.dts,%,$(dts)))
	KERNEL = kernel-bin | gzip | fit gzip "$$(KDIR)/{$$(subst $$(space),$$(comma),$$(addprefix image-,$$(addsuffix .dtb,$$(DEVICE_DTS))))}"
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	FILESYSTEMS := squashfs
	KERNEL_IN_UBI := 1
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.4
	DEVICE_FEATURES := usb-port ncm gps serial modbus io wifi dualsim port-mirror ntrip hw-offload tlt-failsafe-boot

	UBOOT_NAME := tlt-mt7621
	UBOOT_SIZE := 524288
	CONFIG_SIZE := 65536
	ART_SIZE := 65536
	NO_ART := 0
	MASTER_IMAGE_SIZE := 147456k

	IMAGE/sysupgrade.bin = append-ubi | append-metadata | finalize-tlt-webui

	IMAGE/master_fw.bin = \
			append-tlt-uboot | pad-to $$$$(UBOOT_SIZE) | \
			append-tlt-config | pad-to $$$$(CONFIG_SIZE) | \
			append-tlt-art | pad-to $$$$(ART_SIZE) | \
			append-ubi | \
			append-version | \
			check-size $$$$(MASTER_IMAGE_SIZE) | \
			finalize-tlt-master-stendui

	DEVICE_PACKAGES := kmod-gpio-nxp-74hc164 kmod-mt7621-qtn-rgmii kmod-mt7615e\
			   kmod-mt7615-common kmod-mt7615-firmware kmod-spi-gpio \
			   kmod-mtk-eip93

	# USB related:
	DEVICE_PACKAGES += kmod-usb-core kmod-usb3 kmod-usb-serial kmod-usb-acm \
			kmod-usb-serial-ch341 kmod-usb-serial-pl2303 kmod-usb-serial-ark3116 \
			kmod-usb-serial-belkin kmod-usb-serial-cp210x kmod-usb-serial-cypress-m8 \
			kmod-usb-serial-ftdi kmod-usb-serial-ch343

	HW_MODS := mod1%W25N02KV
endef
TARGET_DEVICES += teltonika_rutm
