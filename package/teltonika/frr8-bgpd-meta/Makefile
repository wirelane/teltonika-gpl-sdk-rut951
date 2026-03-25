include $(TOPDIR)/rules.mk

PKG_NAME:=frr8-bgpd-meta
PKG_VERSION:=2026-01-21
PKG_RELEASE:=1
PKG_LICENSE:=Teltonika-closed

include $(INCLUDE_DIR)/package.mk

define Package/frr8-bgpd-meta
	SECTION:=net
	CATEGORY:=Network
	TITLE:=FRR bgpd service meta package
	DEPENDS:=+vuci-app-dynamic-routes-bgp-ui
	ifneq (,$(filter m,$(CONFIG_PACKAGE_frr8-bgpd-meta))$(DUMP))
		PKG_TLT_NAME:=BGP daemon
		PKG_ROUTER:=$(TLT_PLATFORM_NAME)
		PKG_APP_NAME:=frr8-bgpd
	endif
endef

define Package/frr8-bgpd-meta/description
	Border Gateway Protocol (BGP) is a standardized exterior
	gateway protocol designed to exchange routing and reachability
	information among autonomous systems (AS) on the Internet.
endef



define Package/frr8-bgpd-meta/install
	$(INSTALL_DIR) $(1)/usr/share/vuci/menu.d/
	$(LN) /usr/local/usr/share/vuci/menu.d/routes_bgp.json $(1)/usr/share/vuci/menu.d/routes_bgp_link.json
endef

$(eval $(call BuildPackage,frr8-bgpd-meta))
