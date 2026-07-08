include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for Modbus
APP_DEPENDS:=+vuci-app-universal-gateway-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-modbus-tcp-client-ui))$(DUMP))
	APP_TLT_NAME:=Modbus TCP Client
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=modbus_tcp_client
endif

include ../app.mk

define Package/vuci-app-modbus-tcp-client-ui/description
	Modbus TCP client designed for reading/writing data from Modbus servers and storing read data in local database.
endef

# call BuildPackage - OpenWrt buildroot signature
