include $(TOPDIR)/rules.mk

PKG_NAME:=frr8-ripd-meta
PKG_VERSION:=2026-01-21
PKG_RELEASE:=1
PKG_LICENSE:=Teltonika-closed

include $(INCLUDE_DIR)/package.mk

define Package/frr8-ripd-meta
	SECTION:=net
	CATEGORY:=Network
	TITLE:=FRR RIPD service meta package
	DEPENDS:=+vuci-app-dynamic-routes-rip-ui
	ifneq (,$(filter m,$(CONFIG_PACKAGE_frr8-ripd-meta))$(DUMP))
		PKG_TLT_NAME:=RIP daemon
		PKG_ROUTER:=$(TLT_PLATFORM_NAME)
		PKG_APP_NAME:=frr8-ripd
	endif
endef

define Package/frr8-ripd-meta/description
	The Routing Information Protocol (RIP) is one of the
	oldest distance-vector routing protocols which employ
	the hop count as a routing metric.
endef



define Package/frr8-ripd-meta/install
	$(INSTALL_DIR) $(1)/usr/share/vuci/menu.d/
	$(LN) /usr/local/usr/share/vuci/menu.d/routes_rip.json $(1)/usr/share/vuci/menu.d/routes_rip_link.json
endef

$(eval $(call BuildPackage,frr8-ripd-meta))
