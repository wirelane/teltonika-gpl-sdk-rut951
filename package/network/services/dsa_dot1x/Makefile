#
# Copytight (C) 2024 Teltonika
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dsa-dot1x-server
PKG_RELEASE:=3
PKG_VERSION:=2024-10-25
PKG_LICENSE:=Teltonika-closed

include $(INCLUDE_DIR)/package.mk



define Package/dsa-dot1x-server
	SECTION:=net
	CATEGORY:=Network
	TITLE:=802.1X server
	DEPENDS:=+radius_test +kmod-sched-flower +wpad-openssl +tc-tiny \
		+!(HAS_SINGLE_ETH_PORT||DSA_SUPPORT):kmod-sched-act-vlan \
		+!(HAS_SINGLE_ETH_PORT||DSA_SUPPORT):kmod-dummy +wpad-openssl
endef


ifeq ($(CONFIG_PACKAGE_dsa-dot1x-server),m)
define Package/dsa-dot1x-server/postinst
	#!/bin/sh
	[ -z "$${IPKG_INSTROOT}" ] || exit 0
	config_generate
	exit 0
endef
endif

define Package/dsa-dot1x-server/prerm
	#!/bin/sh
	[ -z "$${IPKG_INSTROOT}" ] || exit 0
	. /lib/functions.sh
	/etc/init.d/hostapd_config stop # this will authorize all ports and clean up tc
	remove_isolation_vlans() {
		config_get isolation "$$1" isolation
		[ "$$isolation" = "1" ] && {
			uci_remove network "$$1"
		}
	}
	config_load network
	config_foreach remove_isolation_vlans "switch_vlan"
	uci commit network
	rm /etc/config/dot1x
endef

define Package/dsa-dot1x-server/description
	802.1X Network Access Control
endef

define Package/dsa-dot1x-server/install
	$(INSTALL_DIR) $(1)/usr/sbin/ $(1)/usr/lib/ $(1)/etc/init.d/ $(1)/lib/config.d/ $(1)/etc/config/
	$(if $(CONFIG_HAS_SINGLE_ETH_PORT),\
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/dot1x_single_port.config $(1)/etc/config/dot1x
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/dot1x_port_blocker $(1)/usr/sbin/dot1x_port_blocker,\
		$(if $(CONFIG_TARGET_ramips_mt76x8),
			$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/config.d/generate-dot1x-server-mt76x8 $(1)/lib/config.d/799-generate-dot1x-server
			$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/dot1x_port_blocker_mt76x8.lua $(1)/usr/sbin/dot1x_port_blocker,\
			$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/config.d/generate-dot1x-server $(1)/lib/config.d/799-generate-dot1x-server
			$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/dot1x_port_blocker $(1)/usr/sbin/dot1x_port_blocker
		)
	)

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/dot1xd.lua $(1)/usr/sbin/dot1xd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/hostapd_config $(1)/etc/init.d/hostapd_config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/eap_init/eap_sender $(1)/usr/sbin/eap_sender
endef

$(eval $(call BuildPackage,dsa-dot1x-server))
