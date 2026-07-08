include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for DNP3 TCP Outstation
APP_DEPENDS:=+vuci-app-dnp3-api +vuci-app-universal-gateway-api +vuci-app-dnp3-utils-api

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-dnp3-tcp-outstation-ui))$(DUMP))
	APP_TLT_NAME:=DNP3 TCP Outstation
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
	APP_APP_NAME:=dnp3_tcp_outstation
endif

include ../app.mk

define Package/vuci-app-dnp3-tcp-outstation-ui/description
	DNP3 TCP outstation application.
	DNP3 outstation is designed for DNP3 clients to read device data.
endef

# call BuildPackage - OpenWrt buildroot signature
