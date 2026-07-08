include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support for 2FA

ifneq (,$(filter m,$(CONFIG_PACKAGE_vuci-app-2fa-ui))$(DUMP))
	APP_APP_NAME:=2fa
	APP_TLT_NAME:=2FA
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
endif

include ../app.mk

# call BuildPackage - OpenWrt buildroot signature
