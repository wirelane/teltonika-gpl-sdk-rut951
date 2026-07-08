include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for Modbus
APP_DEPENDS:=+vuci-app-universal-gateway-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-modbus-serial-client-ui))$(DUMP))
	APP_TLT_NAME:=Modbus Serial Client
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=modbus_serial_client
	APP_HW_INFO:=rs232/rs485/usb
endif

include ../app.mk

define Package/vuci-app-modbus-serial-client-ui/description
	Modbus Serial client designed for reading/writing data from Modbus servers and storing read data in local database.
endef

# call BuildPackage - OpenWrt buildroot signature
