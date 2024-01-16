# All rights reserved.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/download.mk

PKG_NAME:=mt7628

PKG_SOURCE_VERSION:=1.3.1

PKG_VERSION=4.1.1.0-DPA-20190925-$(PKG_SOURCE_VERSION)
PKG_RELEASE=1

include $(INCLUDE_DIR)/package.mk

PKG_CONFIG_DEPENDS:=\
	CONFIG_MT7628_SECURITY_IMPROVEMENT_SUPPORT=y \
	CONFIG_MT7628_OWE_SUPPORT=y \
	CONFIG_MT7628_AP_SUPPORT=m \
	CONFIG_SUPPORT_OPENWRT=y \
	CONFIG_RALINK_MT7628=y \
	CONFIG_MT7628_NEW_RATE_ADAPT_SUPPORT=y \
	CONFIG_MT7628_UAPSD=y \
	CONFIG_MT7628_MAC=y \
	CONFIG_MT7628_WSC_INCLUDED=y \
	CONFIG_MT7628_WSC_V2_SUPPORT=y \
	CONFIG_MT7628_DOT11W_PMF_SUPPORT=y \
	CONFIG_MT7628_DOT11R_FT_SUPPORT=y \
	CONFIG_MT7628_MBSS_SUPPORT=y \
	CONFIG_MT7628_DOT11K_RRM_SUPPORT=y \
	CONFIG_MT7628_ROAMING_ENHANCE_SUPPORT=y \
	CONFIG_MT7628_WPA3_SUPPORT=y \
	CONFIG_MT7628_APCLI_SUPPORT=y \
	CONFIG_APSTA_MIXED_SUPPORT=y

ifeq ($(TLT_PLATFORM_TAP100),)
	PKG_CONFIG_DEPENDS+=\
		CONFIG_MT7628_MAC_REPEATER_SUPPORT=y \
		CONFIG_MT7628_MAP_SUPPORT=y \
		CONFIG_MT7628_PASSPOINT_R2=y
endif

ifeq ($(BUILD_VARIANT),netlink_module)
	PKG_CONFIG_DEPENDS+=\
		CONFIG_MT7628_NETLINK_MODULE=y
endif

define KernelPackage/mt7628
  CATEGORY:=Kernel modules
  TITLE:=MTK MT7628 wifi AP driver
  FILES:=$(PKG_BUILD_DIR)/build/mt7628.ko
  DEPENDS:=@TARGET_ramips_mt76x8 +kmod-cfg80211_54 +8021xd +mtkiappd +ap_client +MT7628_HOTSPOT20:mt_hotspot +kmod-nfnetlink
  ifeq ($(BUILD_VARIANT),netlink_module)
	DEPENDS+=kmod-mt7628-netlink
  endif
  SUBMENU:=Wireless Drivers
  AUTOLOAD:=$(call AutoLoad,98,mt7628)
endef

define KernelPackage/mt7628-netlink
  CATEGORY:=Kernel modules
  TITLE:=MTK MT7628 wifi AP driver netlink API
  FILES:=$(PKG_BUILD_DIR)/build/mt7628-netlink.ko
  DEPENDS:=@TARGET_ramips_mt76x8
  SUBMENU:=Wireless Drivers
  AUTOLOAD:=$(call AutoLoad,97,mt7628-netlink)
  VARIANT:=netlink_module
endef

define AddDepends/mt7628
  DEPENDS+=@TARGET_ramips_mt76x8 $(1)
endef



define KernelPackage/mt7628/install
	$(INSTALL_DIR) $(1)/lib/wifi/
	$(INSTALL_DATA) ./files/mt7628.sh $(1)/lib/wifi/
	$(INSTALL_DIR) $(1)/etc/wireless/mt7628/
	$(INSTALL_BIN) ./files/mt7628_tpl.dat $(1)/etc/wireless/
	$(INSTALL_DIR) $(1)/lib/netifd/wireless/
	$(INSTALL_BIN) ./files/lib/netifd/wireless/ralink.sh $(1)/lib/netifd/wireless/
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/mt7628.defaults $(1)/etc/uci-defaults/90_mt7628
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/hostapd $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/wpa_supplicant $(1)/usr/sbin/
	if [ "$(CONFIG_INTERNAL_PA_INTERNAL_LNA)" = "y" ]; then \
		$(INSTALL_BIN) ./files/mt7628.eeprom.ipa.ilna.bin $(1)/etc/wireless/mt7628/mt7628.eeprom.bin; \
	elif [ "$(CONFIG_INTERNAL_PA_EXTERNAL_LNA)" = "y" ]; then \
		$(INSTALL_BIN) ./files/mt7628.eeprom.ipa.elna.bin $(1)/etc/wireless/mt7628/mt7628.eeprom.bin; \
	elif [ "$(CONFIG_EXTERNAL_PA_EXTERNAL_LNA)" = "y" ]; then \
		$(INSTALL_BIN) ./files/mt7628.eeprom.epa.elna.bin $(1)/etc/wireless/mt7628/mt7628.eeprom.bin; \
	else \
		$(INSTALL_BIN) ./files/mt7628.eeprom.ipa.elna.bin $(1)/etc/wireless/mt7628/mt7628.eeprom.bin; \
	fi
endef

$(eval $(call KernelPackage,mt7628))
$(eval $(call KernelPackage,mt7628-netlink))
