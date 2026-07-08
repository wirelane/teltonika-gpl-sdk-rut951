include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for SSO

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-sso-ui))$(DUMP))
	APP_APP_NAME:=sso
	APP_TLT_NAME:=SSO
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
endif

include ../app.mk

# call BuildPackage - OpenWrt buildroot signature
