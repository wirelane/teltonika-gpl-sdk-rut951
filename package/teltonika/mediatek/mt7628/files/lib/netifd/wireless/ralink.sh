#!/bin/sh
. /lib/netifd/netifd-wireless.sh
. /lib/functions.sh

init_wireless_driver "$@"
maclist=""
force_channel=""
T="	"

drv_ralink_init_device_config() {
	config_add_string country region variant log_level short_preamble
	config_add_boolean noscan
	config_add_int channel frag rts txpower beacon_int
}

drv_ralink_init_iface_config() {
	config_add_string 'auth_server:host'
	config_add_string auth_secret
	config_add_int 'auth_port:port'

	config_add_string ifname apname mode wifi_id bssid ssid encryption key key1 key2 key3 key4 wps_pushbutton macfilter led wmm mobility_domain nasid
	config_add_int dtim_period wpa_group_rekey max_inactivity max_listen_interval reassociation_deadline
        config_add_boolean hidden isolate disassoc_low_ack skip_inactivity_poll txburst ieee80211r ft_over_ds
        config_add_array 'maclist:list(macaddr)'

	# HS20
	config_add_boolean interworking internet asra esr uesa
	config_add_int access_network_type venue_group venue_type
	config_add_int ipaddr_type_availability ipaddr6_type_availability
	config_add_string hessid network_auth_type iw_qos_map_set osu_friendly_name osu_server_uri osu_nai osu_service_desc osu_ssid redirect_url
	config_add_array roaming_consortium venue_name venue_url domain_name anqp_3gpp_cell_net nai_realm osu_method_list

	config_add_boolean hs20 disable_dgaf osen
	config_add_int anqp_domain_id
	config_add_int hs20_deauth_req_timeout
	config_add_array hs20_oper_friendly_name
	config_add_array osu_provider
	config_add_array operator_icon
	config_add_array hs20_conn_capab
	config_add_string hs20_operating_class hs20_wan_status hs20_wan_dw_speed hs20_wan_up_speed
}

drv_ralink_cleanup() {
	logger drv_ralink_cleanup
}

append_anqp_3gpp_cell_net() {
	[ -n $1 ] && [ -n "$2" ] && {
		config_get wifi_id $1 wifi_id
		[ "$wifi_id" = "$2" ] && {
			config_get mobile_country_code $1 mobile_country_code "0"
			config_get mobile_network_code $1 mobile_network_code "0"

			append hs_conf "plmn={" "$N"
			append hs_conf "mcc=${mobile_country_code}" "$N$T"
			append hs_conf "mnc=${mobile_network_code}" "$N$T"
			append hs_conf "}" "$N"
		}
	}
}

append_anqp_3gpp_cell_nets() {
	config_load wireless
	wifi_id=$1
	config_foreach append_anqp_3gpp_cell_net anqp_3gpp_cell_net $1
}

append_osu_icon() {
	append hs_conf "icon=$1" "$N"
}

append_osu_method() {
	[ -n "$1" ] && append hs_conf "method=$1" "$N$T" || append hs_conf 'method=n\\a' "$N$T"
}

append_venue() {
	[ -n $1 ] && [ -n "$2" ] && {
		config_get wifi_id $1 wifi_id
		[ "$wifi_id" = "$2" ] && {
			config_get url $1 url 'n\\a'
			config_get v_name $1 name 'n\\a'

			lang=$(echo $v_name | cut -d ":" -f 1)
			desc=$(echo $v_name | cut -d ":" -f 2)

			append hs_conf "venue_name=$lang%{$desc}" "$N"
			append hs_conf "venue_url=${venue_count},${url}" "$N"
			venue_count=$((venue_count + 1))
		}
	}
}

append_venues() {
	config_load wireless
	local venue_count=1
	config_foreach append_venue venue $1
}

append_nai_realm() {
	[ -n $1 ] && [ -n "$2" ] && {
		config_get wifi_id $1 wifi_id
		[ "$wifi_id" = "$2" ] && {
			config_get hostname $1 hostname "null"
			config_get auth_num $1 auth_num "0"
			config_get param $1 param "[0:0]"

			logger -t ralink "Adding nai-realm to $wifi_id"

			auth_val=
			case "$auth_num" in
			13)
				auth_val="eap-tls"
				;;
			18)
				auth_val="eap-sim"
				;;
			21)
				auth_val="eap-ttls"
				;;
			23)
				auth_val="eap-aka"
				;;
			25)
				auth_val="peap"
				;;
			43)
				auth_val="eap-fast"
				;;
			esac

			[ -n $auth_val ] || {
				logger -t ralink "Invalid EAP method"
				return
			}

			append hs_conf "nai_realm_data={" "$N"
			append hs_conf "nai_realm=${hostname}" "$N$T"
			append hs_conf "eap_method=${auth_val}" "$N$T"
			append hs_conf "auth_param=$(echo "$param" | tr -d '[]')" "$N$T"
			append hs_conf "}" "$N"
		}
	}
}

append_nai_realms() {
	config_load wireless
	config_foreach append_nai_realm nai-realm $1
}

append_conn_capab() {
	[ -n $1 ] && [ -n "$2" ] && {
		config_get wifi_id $1 wifi_id
		[ "$wifi_id" = "$2" ] && {
			config_get proto $1 proto 'n\\a'
			config_get port $1 port "0"
			config_get state $1 state "0"

			logger -t ralink "Adding hs20_conn_capab to $wifi_id"

			append hs_conf "proto_port={" "$N"
			append hs_conf "ip_protocol=${proto}" "$N$T"
			append hs_conf "port=${port}" "$N$T"
			append hs_conf "status=${state}" "$N$T"
			append hs_conf "}" "$N"
		}
	}
}

append_conn_capabs() {
	config_load wireless
	config_foreach append_conn_capab hs20_conn_capab $1
}

append_oper_friendly_name() {
	[ -n $1 ] && [ -n "$2" ] && {
		config_get wifi_id $1 wifi_id
		[ "$wifi_id" = "$2" ] && {
			config_get country_code $1 country_code 'n\\a'
			config_get op_name $1 name 'n\\a'

			logger -t ralink "Adding hs20_oper_friendly_name to $wifi_id"
			append hs_conf "op_friendly_name=${country_code},${op_name}" "$N"
		}
	}
}

append_oper_friendly_names() {
	config_load wireless
	config_foreach append_oper_friendly_name hs20_oper_friendly_name $1
}

append_roaming_consortium() {

	if [ -z "$roaming_consortium_conf" ]; then
		roaming_consortium_conf="$1"
	else
		roaming_consortium_conf="$roaming_consortium_conf,$1"
	fi
}

append_domain_name() {
	if [ -z "$domain_name_conf" ]; then
		domain_name_conf="$1"
	else
		domain_name_conf="$domain_name_conf;$1"
	fi
}

ralink_setup_hotspot2(){

	json_get_vars interworking internet asra esr uesa access_network_type
	json_get_vars hessid venue_group venue_type network_auth_type
	json_get_vars roaming_consortium domain_name anqp_3gpp_cell_net nai_realm

	json_get_vars iw_qos_map_set ipaddr_type_availability
	json_get_vars redirect_url ipaddr6_type_availability
	json_get_vars venue_name venue_url

	set_default interworking 0

	if [ "$interworking" = "1" ]; then
		append hs_conf "interworking=1" "$N"
		set_default internet 1

		append hs_conf "internet=$internet" "$N"
		append_venues $wifi_id

		[ -n "$access_network_type" ] && \
			append hs_conf "access_network_type=$access_network_type" "$N"
		[ -n "$hessid" ] && append hs_conf "hessid=$hessid" "$N"
		[ -n "$venue_group" ] && \
			append hs_conf "venue_group=$venue_group" "$N"
		[ -n "$venue_type" ] && append hs_conf "venue_type=$venue_type" "$N"
		[ -n "$network_auth_type" ] && {
			[ "$network_auth_type" = "02" ] && \
				append hs_conf "network_auth_type=$network_auth_type,$redirect_url" "$N" || \
				append hs_conf "network_auth_type=$network_auth_type" "$N"
		}
		[ -n "$ipaddr_type_availability" ] && append hs_conf "ipv4_type=$ipaddr_type_availability" "$N"
		[ -n "$ipaddr6_type_availability" ] && append hs_conf "ipv6_type=$ipaddr6_type_availability" "$N"

		roaming_consortium_conf=
		json_for_each_item append_roaming_consortium roaming_consortium
		[ -n "$roaming_consortium_conf" ] && \
			append hs_conf "roaming_consortium_oi=$roaming_consortium_conf" "$N"

		append_nai_realms $wifi_id

		domain_name_conf=
		json_for_each_item append_domain_name domain_name
		[ -n "$domain_name_conf" ] && \
			append hs_conf "domain_name=$domain_name_conf" "$N"

		append_anqp_3gpp_cell_nets $wifi_id
	fi

	local iface="$1"

	local hs20 disable_dgaf osen anqp_domain_id hs20_deauth_req_timeout \
		osu_server_uri osu_service_desc osu_friendly_name osu_nai osu_ssid \
		hs20_operating_class \
		hs20_wan_status hs20_wan_dw_speed \
		hs20_wan_up_speed osu_method_list hs20_oper_friendly_name
	json_get_vars hs20 disable_dgaf osen anqp_domain_id hs20_deauth_req_timeout \
		osu_server_uri osu_service_desc osu_friendly_name osu_nai osu_ssid \
		hs20_operating_class \
		hs20_wan_status hs20_wan_dw_speed \
		hs20_wan_up_speed osu_method_list hs20_oper_friendly_name

	set_default hs20 0
	set_default disable_dgaf 0
	set_default osen 0
	set_default anqp_domain_id 0
	set_default hs20_deauth_req_timeout 60
	set_default osu_nai 'n\\a'
	set_default osu_friendly_name 'n\\a'
	set_default osu_service_desc 'n\\a'

	[ "$osu_friendly_name" = ":" ] && osu_friendly_name='n\\a'
	[ "$osu_service_desc" = ":" ] && osu_service_desc='n\\a'

	if [ "$hs20" -eq "1" ]; then
		append hs_conf "interface=$iface" "$N"
		append hs_conf "dgaf_disabled=$disable_dgaf" "$N"

		[ -n "$osu_ssid" ] && {
			for idx in `seq 0 $if_idx`; do
				eval the_iface="\${iface_ssid$idx}"
				[ "$the_iface" = "$osu_ssid" ] && {
					eval osu_iface=ra$idx
					break
				}
			done
		}
		[ -n "$osu_iface" ] && append hs_conf "osu_interface=${osu_iface}" "$N"

		[ "$osen" = "1" ] && append hs_conf "legacy_osu=0" "$N" || {
			[ -n "$osu_iface" ] && append hs_conf "legacy_osu=1" "$N" || append hs_conf "legacy_osu=2" "$N"
		}

		append hs_conf "disassociation_timer=$hs20_deauth_req_timeout" "$N"
		[ -n "$hs20_operating_class" ] && append hs_conf "operating_class=$hs20_operating_class" "$N"

		[ -n "$hs20_wan_status" ] && {
			append hs_conf "wan_metrics={" "$N"
			append hs_conf "at_capacity=0" "$N$T"
			append hs_conf "link_status=${hs20_wan_status}" "$N$T"
			append hs_conf "dl_speed=${hs20_wan_dw_speed:-0}" "$N$T"
			append hs_conf "ul_speed=${hs20_wan_up_speed:-0}" "$N$T"
			append hs_conf "dl_load=0" "$N$T"
			append hs_conf "up_load=0" "$N$T"
			append hs_conf "lmd=0" "$N$T"
			append hs_conf "}" "$N"
		}

		append hs_conf "anqp_query=1" "$N"
		append hs_conf "gas_cb_delay=1000" "$N"
		append hs_conf "mmpdu_size=1024" "$N"

		append_conn_capabs $wifi_id
		append_oper_friendly_names $wifi_id

		[ -n "$osu_server_uri" ] && {
			append hs_conf "osu_providers_list={" "$N"
			append hs_conf "osu_server_uri=$osu_server_uri" "$N$T"
			append hs_conf "osu_nai=$osu_nai" "$N$T"
			json_for_each_item append_osu_method osu_method_list

			[ -n "$osu_friendly_name" ] && \
				append hs_conf "osu_friendly_name=$osu_friendly_name" "$N$T"

			append hs_conf "osu_service_desc=$osu_service_desc" "$N$T"
			config_list_foreach "$1" osu_icon append_osu_icon
			append hs_conf "}" "$N"
		}
	fi

}

ralink_setup_ap(){
	local name="$1"
	local eap=0
	local rssi_threshold=-92

	json_select data
	json_get_vars ifname
	json_select ..

	json_select config
	json_get_vars mode ssid encryption key key1 key2 wifi_id \
		key3 key4 wps_pushbutton auth_server auth_port:1812 auth_secret hidden \
		isolate macfilter wmm dtim_period wpa_group_rekey \
		disassoc_low_ack skip_inactivity_poll \
		max_inactivity max_listen_interval txburst \
		ieee80211r ft_over_ds mobility_domain reassociation_deadline
	json_get_values maclist maclist

	ifconfig $ifname up

	set_default wmm 1
	set_default dtim_period 3
	set_default disassoc_low_ack 1
	set_default skip_inactivity_poll 0
	set_default txburst 0
	set_default max_inactivity 0
	set_default mobility_domain "$(echo "$ssid" | md5sum | head -c 4)"
	set_default ft_over_ds 1

	[ -z "$force_channel" ] || iwpriv $ifname set Channel=$force_channel
	[ "$isolate" = 1 ] || isolate=0
	iwpriv $ifname set NoForwarding=$isolate
	iwpriv $ifname set NoForwardingBTNBSSID=$isolate
	iwpriv $ifname set NoForwardingMBCast=$isolate

	[ "$hidden" = 1 ] || hidden=0
	iwpriv $ifname set HideSSID=$hidden

	wsc_methods=0
	wsc_mode=0
	case "$encryption" in
	psk*|mixed*|sae*|wpa*)
		local enc="WPA2PSKWPA3PSK"
		case "$encryption" in
			psk | psk+*) enc=WPAPSK;;
			psk2 | psk2*) enc=WPA2PSK;;
			mixed*) enc=WPAPSKWPA2PSK;;
			wpa | wpa+*) eap=1; enc=WPA;;
			wpa2*) eap=1; enc=WPA2;;
			psk3-mixed | sae-mixed) enc=WPA2PSKWPA3PSK;;
                        psk3 | sae) enc=WPA3PSK;;
		esac
		local crypto="AES"
		case "$encryption" in
			psk3* | sae*) ;;
			*tkip+aes*) crypto=TKIPAES;;
			*tkip*) crypto=TKIP;;
		esac
		[ "$eap" = "1" ] && {
			iwpriv $ifname set RADIUS_Server=$auth_server
			iwpriv $ifname set RADIUS_Port=$auth_port
			iwpriv $ifname set RADIUS_Key=$auth_secret
			iwpriv $ifname set own_ip_addr=$(uci get network.lan.ipaddr)
			iwpriv $ifname set IEEE8021X=0
			iwpriv $ifname set EAPifname=br-lan
			iwpriv $ifname set PreAuthifname=br-lan
		}
		iwpriv $ifname set AuthMode=$enc
		iwpriv $ifname set EncrypType=$crypto
		iwpriv $ifname set IEEE8021X=0
		iwpriv $ifname set "SSID=${ssid}"
		[ "$eap" = "1" ] || iwpriv $ifname set "WPAPSK=${key}"
		iwpriv $ifname set DefaultKeyID=2
		iwpriv $ifname set "SSID=${ssid}"
		if [ "$wps_pushbutton" == "1" ]; then
			wsc_methods=128
			wsc_mode=7
		fi
		;;
	wep*)
		local enc="WEPAUTO"
		iwpriv $ifname set EncrypType=WEP
		iwpriv $ifname set IEEE8021X=0

		case "$encryption" in
                        *open) enc=OPEN;;
                        *shared) enc=SHARED;;
                esac
		for idx in 1 2 3 4; do
			json_get_var keyn key${idx}
			[ -n "$keyn" ] && iwpriv $ifname set "Key${idx}=${keyn}"
		done
		iwpriv $ifname set AuthMode=$enc
		iwpriv $ifname set DefaultKeyID=${key}
		iwpriv $ifname set "SSID=${ssid}"
		;;
	none)
		iwpriv $ifname set "SSID=${ssid}"
		;;
	owe)
		iwpriv $ifname set AuthMode=OWE
		iwpriv $ifname set EncrypType=AES
		iwpriv $ifname set "SSID=${ssid}"
		iwpriv $ifname set IEEE8021X=0
		;;
	esac

	[ "$ieee80211r" -gt "0" ] && {
		iwpriv $ifname set ftenable=1
		iwpriv $ifname set ftotd=${ft_over_ds}
		iwpriv $ifname set ftmdid="${mobility_domain}"
		iwpriv $ifname set RrmEnable=1
		iwpriv $ifname set PMKCachePeriod=720
		iwpriv $ifname set "SSID=${ssid}"
	}

	iwpriv $ifname set WscConfMode=$wsc_mode
	iwpriv $ifname set WscConfStatus=2
	iwpriv $ifname set WscMode=2
	iwpriv $ifname set ACLClearAll=1
	[ -n "$maclist" ] && {
		for m in ${maclist}; do
			logger iwpriv $ifname set ACLAddEntry="$m"
			iwpriv $ifname set ACLAddEntry="$m"
		done
	}
	case "$macfilter" in
	allow)
		iwpriv $ifname set AccessPolicy=1
		;;
	deny)
		iwpriv $ifname set AccessPolicy=2
		;;
	*)
		iwpriv $ifname set AccessPolicy=0
		;;
	esac

	iwpriv $ifname set WmmCapable="${wmm}"
	iwpriv $ifname set DtimPeriod="${dtim_period}"

	[ -n "$wpa_group_rekey" ] && iwpriv $ifname set RekeyInterval="${wpa_group_rekey}" 

	iwpriv $ifname set disassoc_low_ack="${disassoc_low_ack}"
	iwpriv $ifname set skip_inactivity_poll="${skip_inactivity_poll}"
	iwpriv $ifname set TxBurst="${txburst}"

	[ "$max_inactivity" -gt 0 ] && iwpriv $ifname set IdleTimeout="${max_inactivity}"
	[ "$max_listen_interval" -gt 0 ] && iwpriv $ifname set max_listen_interval="${max_listen_interval}"
	iwpriv $ifname set KickStaRssiLow="${rssi_threshold}"

	[ "$eap" = "1" ] && {
		/usr/bin/8021xd -i "$ifname"
		sleep 1
		wireless_add_process "$(cat /var/run/8021xd_${ifname}.pid)" /usr/bin/8021xd
	}

	hs_conf=
	ralink_setup_hotspot2 $ifname
	[ -n "$hs_conf" ] && {
		echo -e "$hs_conf" > /tmp/hs_config_${ifname}.conf

		if [ -z "$hs_main_conf" ]; then
			hs_main_conf="conf_list=/tmp/hs_config_${ifname}.conf"
		else
			hs_main_conf="$hs_main_conf;/tmp/hs_config_${ifname}.conf"
		fi
	}

	json_select ..

	wireless_add_vif "$name" "$ifname"
}

ralink_setup_sta(){
	local name="$1"
	local bcn_active=0
	json_select data
	json_get_vars ifname
	json_select ..
	json_select config
	json_get_vars mode apname ssid bssid encryption key key1 key2 key3 key4 wps_pushbutton led

	linkit_mode="$(uci get wireless.radio0.linkit_mode)"
	[ "${linkit_mode}" = "ap" ] && return
	[ "${linkit_mode}" == "apsta" ] && bcn_active=1

	key=
	case "$encryption" in
		psk*|mixed*|sae*) json_get_vars key;;
		wep) json_get_var key key1;;
	esac
	json_select ..

	/sbin/ap_client "ra0" "$ifname" "${ssid}" "${key}" "${bssid}" "${bcn_active}" "${led}"
	sleep 1
	wireless_add_process "$(cat /tmp/apcli-${ifname}.pid)" /sbin/ap_client

	wireless_add_vif "$name" "$ifname"
}

ralink_count_ap() {
	json_select config

	json_get_vars ifname ieee80211r nasid ssid

	[ -n "$ifname" ] || ifname="ra${if_idx}"

	eval iface_ssid${if_idx}="\${ssid}"

	if_idx=$((if_idx + 1))

	[ "$ieee80211r" -gt "0" ] && {
		append mtkiappd_args "${mtkiappd_args} -wi ${ifname}"
	}

	[ -n "$nasid" ] && {
		append nasid_conf "NasId${if_idx}=${nasid}" "$N"
	}

	json_select ..

	json_add_object data
	json_add_string ifname "$ifname"
	json_close_object
}

ralink_count_sta() {
	json_select config

	json_get_vars ifname

	[ -n "$ifname" ] || ifname="apcli${if_idx_sta}"

	if_idx_sta=$((if_idx_sta + 1))

	json_select ..

	json_add_object data
	json_add_string ifname "$ifname"
	json_close_object
}

list_interfaces() {

	ls -d /sys/class/net/ra* | xargs -n 1 basename
	ls -d /sys/class/net/apcli* | xargs -n 1 basename
}

ralink_ifdown_all() {

	wireless_process_kill_all

	for dev in $(list_interfaces); do
		ifconfig $dev down
	done
}

drv_ralink_setup() {
	local module="mt7628"
	local bcn_active=0
	local if_count=0
	wmode=9
	VHT=0
	VHT_SGI=0
	HT=0
	EXTCHA=0
	if_idx=0
	if_idx_sta=0
	mtkiappd_args=""
	nasid_conf=""
	local ref

	json_select config
	json_get_vars variant region country channel htmode log_level \
		short_preamble noscan:0 rts:2347 frag:2346 txpower beacon_int:100
	json_select ..

	[ -z "$region" ] && region=0

	if [ -z "$txpower" ] || [ "$txpower" -gt "20" ]; then
		txpower=100
	else
		txpower="$(echo $txpower | awk '{ print int(10^($1/10)) }')"
	fi

	[ "$beacon_int" -gt "1024" ] && beacon_int=1024
	[ "$beacon_int" -lt "20" ] && beacon_int=20

	[ "$short_preamble" = 1 ] || short_preamble=0

	case ${htmode:-none} in
	HT20)
		wmode=10
		HT=0
		;;
	HT40)
		wmode=10
		HT=1
		EXTCHA=1
		;;
	VHT20)
		wmode=15
		HT=0
		VHT=0
		VHT_SGI=1
		;;
	VHT40)
		wmode=15
		HT=1
		VHT=0
		VHT_SGI=1
		EXTCHA=1
		;;
	VHT80)
		wmode=15
		HT=1
		VHT=1
		VHT_SGI=1
		EXTCHA=1
		;;
	*)
		case $hwmode in
		a) wmode=2;;
		g) wmode=3;;
		esac
		;;
	esac

	if [ "$auto_channel" -gt 0 ]; then
		force_channel=""
		channel=0
		auto_channel=3
	else
		force_channel=$channel
		auto_channel=0
	fi

	coex=1
	[ "$noscan" -gt 0 ] && coex=0

	for_each_interface "ap" ralink_count_ap
	for_each_interface "sta" ralink_count_sta

	[ "$if_idx" = "0" ] && {
		if_count=$(($if_idx_sta+1))
	} || if_count=$(($if_idx+$if_idx_sta))

	cat > /tmp/${module}.dat<<EOF
#The word of "Default" must not be removed
Default
BssidNum=${if_count}
Beacon=${bcn_active}
HT_BW=${HT:-0}
HT_EXTCHA=${EXTCHA:-0}
CountryRegion=${region}
CountryCode=${country}
WirelessMode=${wmode:-9}
Channel=${channel:-8}
AutoChannelSelect=$auto_channel
Debug=${log_level:-1}
SSID=${ssid:-Teltonika}
HT_BSSCoexistence=$coex
WscConfMethods=680
RTSThreshold=${rts}
FragThreshold=${frag}
TxPower=${txpower}
BeaconPeriod=${beacon_int}
EOF

	[ -n "$nasid_conf" ] && {
		echo ${nasid_conf} >> /tmp/${module}.dat
	}

	cat /etc/wireless/${module}_tpl.dat >> /tmp/${module}.dat

	if [ ! -e "/etc/wireless/${module}/${module}.dat" ]; then
		ln -s /tmp/${module}.dat /etc/wireless/${module}/${module}.dat
	fi

	# in some case we have to reload drivers. (mbssid)
	ref=$(cat /sys/module/$module/refcnt)

	if [ "$ref" -gt "0" ]; then
		ralink_ifdown_all
	fi

	rmmod $module
	insmod $module

	[ -z "$country" ] && country="US"
	iw reg set ${country}

	[ "$if_idx" = "0" ] && {
		ifconfig ra0 up
		[ -d "/sys/class/net/apcli0" ] && ifconfig apcli0 up
		ifconfig ra0 down
	}

	[ -f "/tmp/hs_ap.conf" ] && rm /tmp/hs_ap.conf

	hs_main_conf=
	for_each_interface "ap" ralink_setup_ap
	for_each_interface "sta" ralink_setup_sta

	[ -n "$hs_main_conf" ] && {
		echo -e "$hs_main_conf" > /tmp/hs_ap.conf
		/usr/sbin/hs -f /tmp/hs_ap.conf -m OPMODE_AP -d 0
		sleep 1
		[ -f "/var/run/hotspot.pid" ] && sleep 1
		wireless_add_process "$(cat /var/run/hotspot.pid)" /usr/sbin/hs
	}

	[ -n "$mtkiappd_args" ] && {
		/usr/bin/mtkiappd -e br-lan ${mtkiappd_args}
		sleep 1
		wireless_add_process "$(cut -c 7- /var/run/pid_iapp | tr -d "\n")" /usr/bin/mtkiappd
	}

	wireless_set_up
}

ralink_teardown() {
	json_select data
	json_get_vars ifname
	json_select ..

	ifconfig $ifname down
}

drv_ralink_teardown() {
	wireless_process_kill_all
	for_each_interface "ap sta" ralink_teardown
}

add_driver ralink
