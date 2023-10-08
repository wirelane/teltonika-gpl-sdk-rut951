include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/download.mk

PKG_SOURCE_VERSION:=1.0

PKG_NAME:=mt7628-agent

include $(INCLUDE_DIR)/package.mk

define Package/mt7628-agent
  SECTION:=base
  CATEGORY:=Network
  TITLE:=mt7628 netlink agent
  DEPENDS:=+libnl-tiny +libubus +libubox +liblog
endef


define Package/mt7628-agent/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mt7628-agent $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/mt7628-agent.init $(1)/etc/init.d/mt7628-agent
endef

$(eval $(call BuildPackage,mt7628-agent))
