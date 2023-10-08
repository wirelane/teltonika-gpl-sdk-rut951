#
# hua.shao@mediatek.com
#
# MTK Property Software.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/download.mk

PKG_NAME:=mt_hotspot
PKG_RELEASE:=1
PKG_VERSION:=1.0.0

PKG_SOURCE_DATE:=2023-07-19
PKG_SOURCE_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk

define Package/mt_hotspot
	SECTION:=MTK Properties
	CATEGORY:=MTK Properties
	TITLE:=mt_hotspot
	SUBMENU:=Applications
	DEPENDS:=+libstdcpp +libpthread
endef

define Package/mt_hotspot/description
	Mediatek Hotspot 2.0 Daemon
endef

define Package/mt_hotspot/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/hs $(1)/usr/sbin/hs
endef


$(eval $(call BuildPackage,mt_hotspot))
