include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for DNP3 Serial Outstation
APP_DEPENDS:=+vuci-app-universal-gateway-api +vuci-app-dnp3-api +vuci-app-dnp3-utils-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-dnp3-serial-outstation-ui))$(DUMP))
	APP_TLT_NAME:=DNP3 Serial Outstation
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=dnp3_serial_outstation
	APP_HW_INFO:=rs232/rs485/usb
endif

include ../app.mk

define Package/vuci-app-dnp3-serial-outstation-ui/description
	DNP3 serial outstation application.
	DNP3 outstation is designed for DNP3 clients to read device data over serial connection.
endef

# call BuildPackage - OpenWrt buildroot signature
