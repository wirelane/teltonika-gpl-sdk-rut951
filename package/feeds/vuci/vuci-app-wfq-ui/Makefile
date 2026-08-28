include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for WFQ

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-wfq-ui))$(DUMP))
	APP_APP_NAME:=qos-wfq
	APP_TLT_NAME:=WFQ
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
endif

include ../app.mk

# call BuildPackage - OpenWrt buildroot signature
