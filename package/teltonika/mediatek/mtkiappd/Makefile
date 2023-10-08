#
# hua.shao@mediatek.com
#
# MTK Property Software.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/download.mk

PKG_NAME:=mtkiappd
PKG_RELEASE:=1
PKG_VERSION:=1.0.0

PKG_SOURCE_DATE:=2023-07-19
PKG_SOURCE_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/mtkiappd
	SECTION:=MTK Properties
	CATEGORY:=MTK Properties
	TITLE:=mtkiappd Daemon
	DEPENDS:=+libstdcpp +libpthread
	SUBMENU:=Applications
endef

define Package/mtkiappd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mtkiappd $(1)/usr/bin/mtkiappd
endef


$(eval $(call BuildPackage,mtkiappd))
