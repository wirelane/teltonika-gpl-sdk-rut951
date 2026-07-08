include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for Modbus TCP Server
APP_DEPENDS:=+vuci-app-universal-gateway-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-modbus-tcp-server-ui))$(DUMP))
	APP_TLT_NAME:=Modbus TCP Server
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=modbus_tcp_server
endif

include ../app.mk

define Package/vuci-app-modbus-tcp-server-ui/description
	Modbus TCP server designed for Modbus clients to read and write device data.
endef

# call BuildPackage - OpenWrt buildroot signature
