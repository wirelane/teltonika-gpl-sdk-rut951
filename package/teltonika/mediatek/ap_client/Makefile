#
# hua.shao@mediatek.com
#
# MTK Property Software.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/download.mk

PKG_NAME:=ap_client
PKG_RELEASE:=1

PKG_CONFIG_DEPENDS:=$(foreach c, $(PKG_KCONFIG),$(if $(CONFIG_$c),CONFIG_$(c)))

PKG_SOURCE_DATE:=2023-03-20
PKG_SOURCE_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/ap_client
  SECTION:=MTK Properties
  CATEGORY:=MTK Properties
  TITLE:=STA config daemon
  SUBMENU:=Applications
endef

define Package/ap_client/description
  STA config daemon
endef

TARGET_CFLAGS += \
	$(foreach c, $(PKG_KCONFIG),$(if $(CONFIG_$c),-DCONFIG_$(c)=$(CONFIG_$c)))

CFLAGS="$(TARGET_CFLAGS)"

define Package/ap_client/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ap_client $(1)/sbin
endef


$(eval $(call BuildPackage,ap_client))

