include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for DNP3 TCP Client
APP_DEPENDS:=+vuci-app-universal-gateway-api +vuci-app-dnp3-api +vuci-app-dnp3-utils-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-dnp3-tcp-client-ui))$(DUMP))
	APP_TLT_NAME:=DNP3 TCP Client
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=dnp3_tcp_client
endif

include ../app.mk

define Package/vuci-app-dnp3-tcp-client-ui/description
	DNP3 TCP client application.
	DNP3 client is designed for reading data from DNP3 outstations and storing in local database.
endef

# call BuildPackage - OpenWrt buildroot signature
