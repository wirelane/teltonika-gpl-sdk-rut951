include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for DNP3 Serial Client
APP_DEPENDS:=+dnp3 +vuci-app-dnp3-api +vuci-app-universal-gateway-api +vuci-app-dnp3-utils-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-dnp3-serial-client-ui))$(DUMP))
  APP_TLT_NAME:=DNP3 Serial Client
  APP_ROUTER:=$(TLT_PLATFORM_NAME)
  APP_APP_NAME:=dnp3_serial_client
  APP_HW_INFO:=rs232/rs485/usb
endif

include ../app.mk

define Package/vuci-app-dnp3-serial-client-ui/description
	DNP3 serial client application.
	DNP3 client is designed for reading data from DNP3 outstations over serial connection and storing in local database.
endef

# call BuildPackage - OpenWrt buildroot signature
