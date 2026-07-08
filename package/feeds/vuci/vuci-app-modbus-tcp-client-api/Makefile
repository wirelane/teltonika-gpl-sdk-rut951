include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI API Support for Modbus
APP_DEPENDS:=+modbus_client +vuci-app-modbus-global-api +vuci-app-data-sender-api-mod-modbus +vuci-app-data-sender-api-mod-modbus-alarm

define Package/vuci-app-modbus-tcp-client-api/postrm
[ -z "$${IPKG_INSTROOT}" ] || exit 0

for section in $$(uci show modbus_client 2>/dev/null | grep '=tcp_server$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	for dep in $$(uci show modbus_client 2>/dev/null | grep -E "=(request|alarm)_$${section}$$" | cut -d'=' -f1 | cut -d'.' -f2); do
		uci -q delete "modbus_client.$${dep}"
	done
	uci -q delete "modbus_client.$${section}"
done

uci commit modbus_client 2>/dev/null
/etc/init.d/modbus_client reload 2>/dev/null
exit 0
endef

include ../api.mk

# call BuildPackage - OpenWrt buildroot signature
