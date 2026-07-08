include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI API Support for DNP3 Serial Client
APP_DEPENDS:=+dnp3 +vuci-app-dnp3-api +vuci-app-dnp3-utils-api +vuci-app-data-sender-api-mod-dnp3

define Package/vuci-app-dnp3-serial-client-api/postrm
[ -z "$${IPKG_INSTROOT}" ] || exit 0

for section in $$(uci show dnp3_client 2>/dev/null | grep '=serial_client$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	for dep in $$(uci show dnp3_client 2>/dev/null | grep '=instance$$' | cut -d'=' -f1 | cut -d'.' -f2); do
		if [ "$$(uci -q get "dnp3_client.$${dep}.client_id")" = "$${section}" ]; then
			uci -q delete "dnp3_client.$${dep}"
		fi
	done
	uci -q delete "dnp3_client.$${section}"
done

uci commit dnp3_client 2>/dev/null
/etc/init.d/dnp3_client reload 2>/dev/null
exit 0
endef

include ../api.mk

define Package/vuci-app-dnp3-serial-client-api/description
    DNP3 serial client API.
    DNP3 client is designed for reading data from DNP3 outstations over serial connection and storing in local database.
endef

# call BuildPackage - OpenWrt buildroot signature
