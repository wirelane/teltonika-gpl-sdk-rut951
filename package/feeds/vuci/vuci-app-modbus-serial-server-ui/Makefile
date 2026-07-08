include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for Modbus Serial Server
APP_DEPENDS:=+vuci-app-universal-gateway-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-modbus-serial-server-ui))$(DUMP))
	APP_TLT_NAME:=Modbus Serial Server
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=modbus_serial_server
	APP_HW_INFO:=rs232/rs485/usb
endif

include ../app.mk

define Package/vuci-app-modbus-serial-server-ui/description
	Modbus Serial server designed for Modbus clients to read and write device data.
endef

# call BuildPackage - OpenWrt buildroot signature
