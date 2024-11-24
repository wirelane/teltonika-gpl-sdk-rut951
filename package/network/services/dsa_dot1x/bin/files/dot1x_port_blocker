#!/bin/sh

. /lib/functions.sh

status_dir="/tmp/port_security/port_state"

check_valid_port() {
	local port="$1"
	[ -z "$port" ] && return 1
	ip link show dev "$port" > /dev/null 
}

assign_vlan() {
	local port="$1"
	check_valid_port "$port" || {
		echo "usage: assign_vlan [port] [vid]" >&2
		return
	}
	local target_vid="$2"
	local vlan_found=false
	uci_vlan_reassign() {
		local vlan="$1"
		uci del_list "network.$vlan.ports=$port"
		uci del_list "network.$vlan.ports=$port:u"
		[ -z "$target_vid" ] && return
		local vid
		config_get vid "$vlan" "vlan"
		[ "$target_vid" = "$vid" ] && {
			vlan_found=true
			uci add_list "network.$vlan.ports=$port:u"
		}
	}
	config_load network
	config_foreach uci_vlan_reassign bridge-vlan

	uci commit network

	# reloading network takes too long. We're only changing the vid so ip bridge will do.
	bridge vlan del dev "$port" vid 1-4094 
	[ -z "$target_vid" ] && return
	! $vlan_found && {
		echo "WARN: vlan $target_vid does not exist! removed port from all vlans" >&2
		return
	}
	bridge vlan add dev "$port" vid "$target_vid" pvid egress untagged
	uci commit network
}

get_port_state() {
	local device="$1"
	check_valid_port "$device" || {
		echo "usage: get_port_state [port]" >&2
		return
	}
	[ -f "$status_dir/$device" ] && printf 'UN'
	echo 'AUTHORIZED'
}

toggle_controlled_port() {
	device="$1"
	lock=$2
	check_valid_port "$device" || {
		echo "usage: toggle_controlled_port [port] [true/false]" >&2
		return
	}
	[ -d "$status_dir" ] || mkdir -p "$status_dir"

	if $lock ; then 
		[ -f "$status_dir/$device" ] && {
			echo "port $device is already locked"
			return
		}
		touch "$status_dir/$device"
		echo "locking port $device for 802.1x server"
		[ -f "/sys/class/net/$device/dsa_port/isolation" ] && echo 1 > "/sys/class/net/$device/dsa_port/isolation"
		tc qdisc  add dev "$device" clsact 2> /dev/null
		tc filter add dev "$device" egress prio 2 handle 2 matchall action drop
		tc filter add dev "$device" egress prio 1 handle 1 protocol 0x888e matchall action pass
		tc filter add dev "$device" ingress prio 3 handle 3 matchall action drop
		tc filter add dev "$device" ingress prio 2 handle 2 protocol 0x888e matchall action pass
		tc filter add dev "$device" ingress prio 1 handle 1 protocol 802.1Q flower vlan_ethtype 0x888e action pass
	else
		[ -f "$status_dir/$device" ] || {
			echo "port is already unlocked"
			return
		}
		rm "$status_dir/$device"
		echo "unlocking port $device for 802.1x server"
		[ -f "/sys/class/net/$device/dsa_port/isolation" ] && echo 0 > "/sys/class/net/$device/dsa_port/isolation"
		tc filter del dev "$device" egress prio 1 handle 1 matchall 
		tc filter del dev "$device" egress prio 2 handle 2 matchall
		tc filter del dev "$device" ingress prio 1 handle 1 matchall 
		tc filter del dev "$device" ingress prio 2 handle 2 matchall
		tc filter del dev "$device" ingress prio 3 handle 3 matchall
		tc qdisc  del dev "$device" clsact 2> /dev/null
	fi
}

HELP="Usage:
	toggle_controlled_port [port] [state]    set port to the 802.1x authorized state
	get_port_state [port]                    set port to the 802.1x authorized state
	assign_vlan [port] [vlan]                move port to vlan
	teardown_port [port]                     equivalent of toggle_controlled_port [port] false
	"

case "$1" in
	assign_vlan)
		assign_vlan "$2" "$3"
		;;
	toggle_controlled_port)
		toggle_controlled_port "$2" $3
		;;
	get_port_state)
		get_port_state "$2"
		;;
	teardown_port)
		toggle_controlled_port "$2" false
		;;
	sync)
		exit 0
		;;
	*)
		echo "$HELP"
		;;
esac
