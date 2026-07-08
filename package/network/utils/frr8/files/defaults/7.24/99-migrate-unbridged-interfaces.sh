#!/bin/sh

. /lib/functions.sh

UCI_CONFIG_DIR="${UCI_CONFIG_DIR:-/etc/config}"
[ -f "$UCI_CONFIG_DIR/ospf" ] || exit 0
[ -f "$UCI_CONFIG_DIR/network" ] || exit 0

member_map=""

collect_device_bridge_members() {
	local section="$1"
	local type name ports member pair found

	config_get type "$section" type
	[ "$type" = "bridge" ] || return

	config_get name "$section" name
	[ -n "$name" ] || return
	config_get ports "$section" ports
	[ -n "$ports" ] || return

	for member in $ports; do
		found=0
		
		for mapped_member in $member_map; do
			[ "${mapped_member%%=*}" = "$member" ] || continue
			found=1
			break
		done

		if [ "$found" -eq 1 ]; then
			continue
		fi
		append member_map "$member=$name"
	done
}

migrate_ospf_interface() {
	local section="$1"
	local ifname token mapped new_ifname pair

	config_get ifname "$section" ifname
	[ -n "$ifname" ] || return

	new_ifname=""

	for token in $ifname; do
		mapped="$token"
		for mapped_member in $member_map; do
			[ "${mapped_member%%=*}" = "$token" ] || continue
			mapped="${mapped_member#*=}"
			break
		done
		list_contains new_ifname "$mapped" && continue
		append new_ifname "$mapped"
	done

	[ "$new_ifname" = "$ifname" ] && return

	uci_set ospf "$section" ifname "$new_ifname"
}

config_load network
config_foreach collect_device_bridge_members device

config_load ospf
config_foreach migrate_ospf_interface ospf_interface

uci_commit ospf

exit 0
