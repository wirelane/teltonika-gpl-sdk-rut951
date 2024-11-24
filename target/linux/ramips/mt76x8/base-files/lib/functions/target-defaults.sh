#!/bin/sh

. /lib/functions/uci-defaults.sh

ucidef_target_defaults() {
	local model="$1"
	local branch_path="/sys/mnf_info/branch"
	local branch
	[ -f "$branch_path" ] && branch="$(cut -c -2 $branch_path)"

	case "$model" in
	RUT9*)
		# set up MAC addresses
		ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"
		ucidef_set_interface_default_macaddr "wan" "$(macaddr_add "$(mtd_get_mac_binary config 0x0)" 1)"

		# set up io
		[ "${model:7:1}" = "6" ] || ucidef_set_hwinfo ios soft_port_mirror

		# set sd card
		[ "${model:4:1}" = "6" ] && [ "$hw_ver" -gt 4 ] && ucidef_set_hwinfo sd_card soft_port_mirror

		# set up modem
		[ "${model:5:1}" = "1" ] && \
			ucidef_add_static_modem_info "$model" "1-1" "2" "primary"

		[ "${model:5:1}" = "6" ] && \
			ucidef_add_static_modem_info "$model" "1-1.4" "2" "primary" "gps_out"

		# set up eSIM (special device code, before SIM config)
		[ "${model:7:1}" = "1" ] && [ "${model::6}" = "RUT901" ] && ucidef_set_esim
		;;
	DAP14*)
		# set up MAC addresses
		ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"
		;;
	RUT14*)
		# set up MAC addresses
		ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"
		ucidef_set_interface_default_macaddr "wan" "$(macaddr_add "$(mtd_get_mac_binary config 0x0)" 1)"
		;;
	RUT2*)
		# set up MAC addresses
		ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"
		ucidef_set_interface_default_macaddr "wan" "$(macaddr_add "$(mtd_get_mac_binary config 0x0)" 1)"

		# set up modem
		[ "${model:5:1}" != "6" ] && \
			ucidef_add_static_modem_info "$model" "1-1" "1" "primary"

		[ "${model:5:1}" = "6" ] && \
			ucidef_add_static_modem_info "$model" "1-1.2" "2" "primary"

		# set up io
		[ "${model:4:2}" != "06" ] && [ "${model:6:1}" != "1" ] && ucidef_set_hwinfo ios

		# set up eSIM
		[ "${model:6:1}" = "2" ] && [ "${model::6}" = "RUT241" ] && {
			ucidef_set_esim
			ucidef_set_hwinfo dual_sim
		}

		# set up dual_sim
		ucidef_check_dual_sim
		;;
	RUT3*)
		# set up MAC addresses
		[ "${model:4:2}" != "01" ] && \
			ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"
		ucidef_set_interface_default_macaddr "wan" "$(macaddr_add "$(mtd_get_mac_binary config 0x0)" 1)"

		# set up modem
		[ "${model:4:1}" = "6" ] && \
		ucidef_add_static_modem_info "$model" "1-1" "primary"

		# set up io
		[ "${model:7:1}" != "1" ] && ucidef_set_hwinfo ios
		;;
	TRB2*)
		# set up modem
		ucidef_add_static_modem_info "$model" "1-1.4" "primary" "gps_out"
		;;
	TAP1*)
		# set up modem
		ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"
		;;
	OTD1*)
		# set up MAC addresses
		ucidef_set_interface_default_macaddr "lan" "$(mtd_get_mac_binary config 0x0)"

		# set up modem
		ucidef_add_static_modem_info "$model" "1-1" "primary"
		;;
	esac
}
