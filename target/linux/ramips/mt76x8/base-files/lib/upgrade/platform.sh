. /lib/upgrade/common.sh

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

platform_check_image() {
	return 0
}

platform_do_upgrade() {
	default_do_upgrade "$1"
}

compatible_to_ec200() {
	{ ! find_hw_mod "2c7c_6005"; } && {
		echo "EC200* modem detected but fw does not support it"
		return 1
	}
	return 0
}

check_hw_mod() {
	local model min_hwver hwmod
	model="$1"
	min_hwver="$2"
	hwmod="$3"

	if [ "${board:3:3}" = "$model" ]; then
		[ "$hwver" -ge "$min_hwver" ] && { ! find_hw_mod "$hwmod"; } && {
			echo "Found new hardware revision this firmware does not support it"
			return 1
		}
	fi
	return 0
}

platform_check_hw_support() {

	local adc_ver board exp hwver

	board="$(cat /sys/mnf_info/name)"
	hwver="$(cat /sys/mnf_info/hwver)"

	exp="^RUT2(60)"
	[[ $board =~ $exp ]] && {
		{ ! prepare_metadata_hw_mods "$1"; } && return 1
		{ ! check_hw_mod "260" 3 "260v3"; } && return 1
		# { ! check_hw_mod "241" 5 "241v5"; } && return 1
	}

	exp="^RUT9(51|56|01|06)"
	[[ ! $board =~ $exp ]] && return 0

	{ ! prepare_metadata_hw_mods "$1"; } && return 1

	[ -d "/sys/bus/usb/devices/1-1.3/1-1.3:1.0/tty/ttyCH343USB0" ]  && \
		{ ! find_hw_mod "CH343"; } && {
			echo "Found new RS232 chip but this fw does not support it"
			return 1
		}

	adc_ver="$(cat /sys/class/hwmon/hwmon0/device/name)"
	[ "$adc_ver" = "tla2021" ] && { ! find_hw_mod "TLA2021"; } && {
		echo "Found new adc chip TLA2021 but this fw does not support it"
		return 1
	}

	eval "$( jsonfilter -q -i "/etc/board.json" \
		-e "vendor=@['modems'][@.builtin=true].vendor" \
		-e "product=@['modems'][@.builtin=true].product" \
		)"

	[ -z "$vendor" ] || [ -z "$product" ] && {
		echo "Unable to determine current modem model"
		# FW should satisfy all contitions
		compatible_to_ec200
		return "$?"
	}

	[ "${vendor}:${product}" != "2c7c:6005" ] && return 0

	compatible_to_ec200

	return "$?"
}
