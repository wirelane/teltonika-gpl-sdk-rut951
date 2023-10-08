#
# Copyright (C) 2010 OpenWrt.org
#

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

platform_check_image() {
	return 0
}

platform_do_upgrade() {
	default_do_upgrade "$1"
}

check_mods() {
	local mod_ec200_set=0
	local metadata="/tmp/sysupgrade.meta"

	[ -e "$metadata" ] || ( fwtool -q -i "$metadata" $1 ) && {
		json_load_file "$metadata"

		if ( json_select hw_mods 1> /dev/null ); then

			json_select hw_mods
			json_get_values hw_mods

			echo "Mods found: $hw_mods"

			for mod in $hw_mods; do
				case "$mod" in
					"2c7c_6005")
						mod_ec200_set=1
					;;
				esac
			done
		fi

		if [ "$mod_ec200_set" == 0 ]; then
			echo "EC200* modem detected but fw does not support it"
			return 1
		fi

		return 0
	}

	return 1
}

platform_check_hw_support() {
	local board="$(mnf_info -n | cut -c 1-6)"

	[[ ! "$board" =~ "RUT9(51|56|01|06)" ]] && return 0

	json_init
	json_load_file /etc/board.json
	json_get_keys modems modems
	json_select modems

	local vendor product

	for modem in $modems; do
		json_select "$modem"
		json_get_var builtin builtin

		[ "$builtin" != "1" ] && {
			continue
		}

		json_get_vars vendor product
		break
	done

	[ -z "$vendor" ] || [ -z "$product" ] && {
		echo "Unable to determine current modem model"
		# FW should satisfy all contitions
		check_mods
		return "$?"
	}

	[ "${vendor}:${product}" != "2c7c:6005" ] && return 0

	check_mods
	return "$?"
}
