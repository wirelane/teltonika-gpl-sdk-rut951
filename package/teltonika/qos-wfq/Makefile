#
# Copyright (C) 2026 Teltonika-Networks
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/download.mk

PKG_NAME:=qos-wfq
PKG_VERSION:=2026-07-27
PKG_RELEASE:=2
PKG_LICENSE:=Teltonika-closed

PKG_SOURCE_VERSION:=7.24.2
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk

define Package/qos-wfq
  SECTION:=utils
  CATEGORY:=Base system
  DEPENDS:=+tc +kmod-sched-core +kmod-sched-connmark +kmod-ifb +iptables \
	  +iptables-mod-ipopt +iptables-mod-conntrack-extra
  TITLE:=QoS WFQ scheduler
  PKGARCH:=all
  USERID:=wfq:wfq
endef

define Package/qos-wfq/description
 QoS class-based WFQ scheduler implementation
endef

define Package/qos-wfq/conffiles
/etc/config/wfq
endef



define Package/qos-wfq/install
	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/hotplug.d/iface $(1)/etc/init.d $(1)/usr/bin $(1)/usr/lib/wfq $(1)/etc/permtab.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/usr/bin/* $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/init.d/wfq $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/usr/lib/wfq/wfq.sh $(1)/usr/lib/wfq
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/files/usr/lib/wfq/tcrules.awk $(1)/usr/lib/wfq
	$(INSTALL_CONF_USR) $(PKG_BUILD_DIR)/files/etc/config/wfq $(1)/etc/config
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/files/etc/permtab.d/wfq $(1)/etc/permtab.d/wfq
endef

$(eval $(call BuildPackage,qos-wfq))
