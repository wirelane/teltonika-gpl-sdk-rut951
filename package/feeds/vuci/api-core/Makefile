#
# Copyright (C) 2022 Teltonika-Networks
#

include $(TOPDIR)/rules.mk

PKG_NAME:=api-core
PKG_RELEASE:=2
PKG_LICENSE:=Teltonika-nda-source
PKG_BUILD_DEPENDS:=VUCI_MINIFY_LUA:luasrcdiet/host VUCI_COMPILE_LUA:luajit2/host python3/host uhttpd

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/package/lang/python/python3-host.mk
include ../utils.mk

define Package/api-core
  SECTION:=webui
  CATEGORY:=WebUI
  TITLE:= API core
  DEPENDS:=+rpcd +WIFI_SUPPORT:rpcd-mod-iwinfo +rpcd-mod-file +rpcd-mod-rpcsys +uhttpd \
		+luajit2 +libc +libubox-lua +libubus-lua \
		+libuci-lua +luci-lib-jsonc +luci-lib-nixio \
		+luci-lib-ip +rpcd-mod-rrdns +uhttpd-mod-lua \
		+libubus +luasocket +lsqlite3 +rpcd-mod-mnfinfo +luasec +rpcd-mod-uci \
		+rpcd-mod-rc +session +openssl-util +libopenssl +libpcre2 +libtlt-logger
endef

define Package/api-core/config
	source "$(SOURCE)/Config.in"
endef

define Package/api-core/description
	Provides core API functionality
endef

define Package/api-core/conffiles
/etc/config/vuci
endef


VUCI_DIR:="$(CURDIR)/.."
ifeq ($(CONFIG_GPL_INCLUDE_WEB_SOURCES), y)
VUCI_BACKUP_API_DIR:="$(VUCI_DIR)/vuci-app-backup-api"
else
VUCI_BACKUP_API_DIR:="$(VUCI_DIR)/applications/vuci-app-backup/vuci-app-backup-api"
endif


define install_closed_gpl
	$(INSTALL_DIR) $(1)/lua_module
	$(CP) $(PKG_BUILD_DIR)/lua_module/vuci.so $(1)/lua_module

	$(INSTALL_DIR) $(1)/uhttpd_api_subscriber
	$(CP) $(PKG_BUILD_DIR)/uhttpd_api_subscriber/uhttpd_api_subscriber.so $(1)/uhttpd_api_subscriber

	$(CP) -a --no-preserve=ownership $(PKG_BUILD_DIR)/files $(1)/files
endef


define Package/api-core/install
	$(CP) -a --no-preserve=ownership $(PKG_BUILD_DIR)/files/* $(1)
	chmod +x "$(1)/www/cgi-bin/"*
	chmod +x "$(1)/sbin/api"
	chmod +x "$(1)/bin/trigger_vuci_routes_reload"

	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/lua_module/vuci.so $(1)/usr/lib/lua

	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uhttpd_api_subscriber/uhttpd_api_subscriber.so $(1)/usr/lib

	# remove some core api files if none of these features are supported
	$(if $(or $(CONFIG_IO_SUPPORT),\
	     $(CONFIG_GPS_SUPPORT),\
	     $(CONFIG_MOBILE_UTILS_SUPPORT),\
	     $(CONFIG_SERIAL_SUPPORT),\
	     $(CONFIG_SNMP_SUPPORT)),,\
		$(RM) $(1)/usr/lib/lua/vuci/io.lua; \
	)
	$(if $(CONFIG_IO_MODBUS_SUPPORT),,\
		$(RM) $(1)/usr/lib/lua/vuci/modbus_utils.lua; \
	)
endef

$(eval $(call BuildPackage,api-core))
