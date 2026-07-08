include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI API Support for Modbus Serial Server
APP_DEPENDS:=+modbus_server

define Package/vuci-app-modbus-serial-server-api/postrm
[ -z "$${IPKG_INSTROOT}" ] || exit 0

for section in $$(uci show modbus_server 2>/dev/null | grep '=rtu_device$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	for tag in $$(uci show modbus_server 2>/dev/null | grep '=tag$$' | cut -d'=' -f1 | cut -d'.' -f2); do
		if [ "$$(uci -q get modbus_server.$${tag}.modbus_dev_config)" = "$${section}" ]; then
			uci -q delete "modbus_server.$${tag}"
		fi
	done
	uci -q delete "modbus_server.$${section}"
done

uci commit modbus_server 2>/dev/null
/etc/init.d/modbus_server reload 2>/dev/null
exit 0
endef

include ../api.mk

# call BuildPackage - OpenWrt buildroot signature
