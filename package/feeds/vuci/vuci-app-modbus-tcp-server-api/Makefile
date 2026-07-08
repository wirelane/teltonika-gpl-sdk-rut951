include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI API Support for Modbus TCP Server
APP_DEPENDS:=+modbus_server

define Package/vuci-app-modbus-tcp-server-api/postrm
[ -z "$${IPKG_INSTROOT}" ] || exit 0

for section in $$(uci show modbus_server 2>/dev/null | grep '=modbus$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	uci -q delete "modbus_server.$${section}"
done

for section in $$(uci show modbus_server 2>/dev/null | grep '=tag$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	if [ "$$(uci -q get modbus_server.$${section}.modbus_dev_config)" = "modbus" ]; then
		uci -q delete "modbus_server.$${section}"
	fi
done

uci commit modbus_server 2>/dev/null
/etc/init.d/modbus_server reload 2>/dev/null
exit 0
endef

include ../api.mk

# call BuildPackage - OpenWrt buildroot signature
