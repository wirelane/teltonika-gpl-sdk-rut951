#!/bin/sh
append DRIVERS "mt7628"

check_wifi_device() {
        device_count=$((device_count+1))
}

convert_mac80211_dev_opts() {
	config_get old_type "$1" type
	[ -n "$old_type" ] && [ "$old_type" = "mac80211" ] || return

	uci set wireless."$1".type="ralink"
	uci delete wireless."$1".path

	config_get old_tx_power "$1" txpower
	[ -n "$old_tx_power" ] && {

		tx_power=
		case $old_tx_power in
			[0-6] )
				tx_power=0
				;;
			[7-9] | 1[0-2] )
				tx_power=11
				;;
			13 | 14 )
				tx_power=14 
				;;
			15 | 16 )
				tx_power=16
				;;
			1[7-9] )
				tx_power="$old_tx_power"
				;;
			* )
				tx_power=20
				;;
		esac

		uci set wireless."$1".txpower="$tx_power"
	}

	uci commit wireless
}

detect_mt7628() {
#	detect_ralink_wifi mt7628 mt7628
	ssid=mt7628-`ifconfig eth0 | grep HWaddr | cut -c 51- | sed 's/://g'`
	cd /sys/module/
	[ -d $module ] || return
	
	config_load wireless
	
	config_get type mt7628 type
	[ -z "$type" ] || break

	device_count=0
	config_foreach check_wifi_device wifi-device

	[ "$device_count" -gt 0 ] && {
		config_foreach convert_mac80211_dev_opts wifi-device
		return
	}

	local mac_add="0x2"
	local router_mac=$(/sbin/mnf_info --mac 2>/dev/null)
	router_mac=$(printf "%X" $((0x$router_mac + $mac_add)))
	if [ ${#router_mac} -lt 12 ]; then
		local zero_count=$(printf "%$((12 - ${#router_mac}))s")
		local zero_add=${zero_count// /0}
		router_mac=$zero_add$router_mac
	fi
	local wifi_mac=${router_mac:0:2}
	for i in 2 4 6 8 10; do
		wifi_mac=$wifi_mac:${router_mac:$i:2}
	done

	local default_pass=$(/sbin/mnf_info --wifi_pass 2>/dev/null)
	local wifi_auth_lines=""
	local router_mac_end=""

	if [ -n "$wifi_mac" ]; then
		router_mac_end=$(echo -n ${wifi_mac} | sed 's/\://g' | tail -c 4 | tr '[a-f]' '[A-F]')
		local dual_band_ssid=$(jsonfilter -i /etc/board.json -e '@.hwinfo.dual_band_ssid')
		local model=$(/sbin/mnf_info --name 2>/dev/null)
		if [ "$dual_band_ssid" != "true" ]; then
			ssid="${model:0:6}_${router_mac_end}"
		else
			if [ "$mode_band" = "g" ]; then
				ssid="${model:0:3}_${router_mac_end}_2G"
			elif [ "$mode_band" = "a"  ]; then
				ssid="${model:0:3}_${router_mac_end}_5G"
			fi
		fi
	fi

	IFS='' read -r -d '' wifi_auth_lines <<EOF
	set wireless.default_radio0.encryption=none
EOF

	[ -n "$default_pass" ] && [ ${#default_pass} -ge 8 ] && [ ${#default_pass} -le 64 ] && {
		IFS='' read -r -d '' wifi_auth_lines <<EOF
	set wireless.default_radio0.encryption=sae-mixed
	set wireless.default_radio0.key=${default_pass}
EOF
	}
	
	uci -q batch <<-EOF
		set wireless.radio0=wifi-device
		set wireless.radio0.type=ralink
		set wireless.radio0.hwmode=11g
		set wireless.radio0.channel=auto
		set wireless.radio0.htmode=HT20
		set wireless.radio0.country=US
		
		set wireless.default_radio0=wifi-iface
		set wireless.default_radio0.device=radio0
		set wireless.default_radio0.mode=ap
		set wireless.default_radio0.network=lan
		set wireless.default_radio0.ssid=${ssid}
		set wireless.default_radio0.wifi_id=wifi0
		${wifi_auth_lines}
EOF
	uci -q commit wireless
}
