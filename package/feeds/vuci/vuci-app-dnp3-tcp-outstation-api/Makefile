include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI API Support for DNP3 TCP Outstation
APP_DEPENDS:=+dnp3 +vuci-app-data-sender-api-mod-dnp3

define Package/vuci-app-dnp3-tcp-outstation-api/postrm
[ -z "$${IPKG_INSTROOT}" ] || exit 0

for section in $$(uci show dnp3_outstation 2>/dev/null | grep '=tag$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	if [ "$$(uci -q get dnp3_outstation.$${section}.outstation_dev_id)" = "dnp3_outstation" ]; then
		uci -q delete "dnp3_outstation.$${section}"
	fi
done

for section in $$(uci show dnp3_outstation 2>/dev/null | grep '=dnp3_outstation$$' | cut -d'=' -f1 | cut -d'.' -f2); do
	uci -q delete "dnp3_outstation.$${section}"
done

uci commit dnp3_outstation 2>/dev/null
/etc/init.d/dnp3_outstation reload 2>/dev/null
exit 0
endef

include ../api.mk

define Package/vuci-app-dnp3-tcp-outstation-api/description
    DNP3 TCP outstation API.
    DNP3 outstation is designed for DNP3 clients to read device data.
endef

# call BuildPackage - OpenWrt buildroot signature
