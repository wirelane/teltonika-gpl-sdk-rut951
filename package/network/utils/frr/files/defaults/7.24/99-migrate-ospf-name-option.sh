#!/bin/sh

. /lib/functions.sh

UCI_CONFIG_DIR=${UCI_CONFIG_DIR:-/etc/config}
[ -f "$UCI_CONFIG_DIR/ospf" ] || exit 0

add_name_option() {
	local section="$1"
	local name

	config_get name "$section" "name"
	[ -n "$name" ] && return

	uci_set "ospf" "$section" "name" "$section"
}

config_load ospf
for s in ospf_interface ospf_neighbor ospf_area ospf_network; do
	config_foreach add_name_option "$s"
done
uci_commit "ospf"
exit 0

