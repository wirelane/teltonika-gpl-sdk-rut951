#!/bin/sh
. /lib/functions.sh
. /lib/functions/network.sh
. /usr/share/libubox/jshn.sh

CMD="$1"
INTERFACES_DATA=""
CLASSES_DATA=""

[ -x /usr/sbin/ip6tables ] && {
	iptables="ip6tables iptables"
} || {
	iptables="iptables"
}

WFQ_STATE_DIR="/var/run/wfq"
MODULES=""

add_module() {
    local module_present
    eval "export module_present=\${wfqmod_$1}"
    [ "$module_present" = 1 ] && return
    append_line MODULES $1
    export wfqmod_$1=1
}

append_line() {
    local varname="$1"
    shift
    local value="$*"

    [ -n "$varname" ] && [ -n "$value" ] || return 0

    append "$varname" "
$value"
}

find_ifname() {
    local ifname
    if network_get_device ifname "$1"; then
        echo "$ifname"
    else
        echo "Device for interface $1 not found." >&2
        exit 1
    fi
}

get_ifbnum() {
	local iface="$1"
	local state_file="$WFQ_STATE_DIR/$iface.ifbdev"

	[ -f "$state_file" ] && {
		cat "$state_file"
		return 0
	}

	local idx=0
	while [ -f "$WFQ_STATE_DIR/ifb$idx.lock" ]; do
		idx=$((idx + 1))
	done

	mkdir -p "$WFQ_STATE_DIR"
	echo "$idx" > "$state_file"
	echo "$iface" > "$WFQ_STATE_DIR/ifb$idx.lock"

	echo "$idx"
}

get_mobile_device() {
	local ifname="$1"
	local device=""

	local out="$(ubus call "network.interface.${ifname}_4" status 2> /dev/null)"

	[ -z "$out" ] && out="$(ubus call "network.interface.${ifname}_6" status 2> /dev/null)"
	[ -z "$out" ] && return 1

	json_load "$out"
	json_get_var device device

	[ -z "$device" ] && return 1

	echo "$device"

	return 0
}

parse_interface() {
    local iface="$1"
    config_get_bool enabled "$1" enabled 1
    [ "$enabled" -eq 1 ] || return 0

    config_get "is_mobile" "$1" "is_mobile" "0"
    device=""
    [ "$is_mobile" = "1" ] && {
        device="$(get_mobile_device "$1")" || return 1
    }
    [ -z "$device" ] && device="$(find_ifname "$1")"
    config_get upload "$iface" upload
    config_get download "$iface" download
    local ifbnum="$(get_ifbnum "$iface")"
    ifb_count=$((ifb_count + 1))
    append_line INTERFACES_DATA "interface:$iface:$device:$upload"
    add_module cls_fw

    [ -n "$download" ] && {
        add_module cls_u32
        add_module em_u32
        add_module act_connmark
        add_module act_mirred
        add_module sch_ingress
        append_line INTERFACES_DATA "interface:$iface:$device:$download:$ifbnum"
    }
}

parse_classes() {
    local section="$1"
    local priority
    local srchost
    local dsthost
    local proto
    local ports
    local weight

    config_get priority "$section" priority "1"
    config_get srchost "$section" srchost
    config_get dsthost "$section" dsthost
    config_get proto "$section" proto
    config_get ports "$section" ports
    config_get weight "$section" weight "1"
    append_line CLASSES_DATA "class:$section:$priority:$srchost:$dsthost:$proto:$ports:$weight"
}

generate_rules() {
    local generator="/usr/lib/wfq/tcrules.awk"
    [ -f "$generator" ] || generator="/usr/local$generator"

    [ -f "$generator" ] || {
        exit 1
    }
    for ifdata in $INTERFACES_DATA; do
        local iface
        local device
        local rate
        local direction="up"
        local ifbnum
        iface=$(echo "$ifdata" | cut -d: -f2)
        device=$(echo "$ifdata" | cut -d: -f3)
        rate=$(echo "$ifdata" | cut -d: -f4)
        ifbnum=$(echo "$ifdata" | cut -d: -f5)
        [ -n "$ifbnum" ] && direction="down"
        append_line tcrules " "
        append_line tcrules "$(printf '%s\n' "$CLASSES_DATA" | awk \
                                        -v dev="$device" \
                                        -v rate="$rate" \
                                        -v dir="$direction" \
                                        -v ifbnum="$ifbnum" \
                                        -f "$generator") "
    done;
}

parse_class_rule() {
    local section="$1"
    local command="$2 -w -t mangle"
    local priority
    local srchost
    local dsthost
    local proto
    local ports
    local dscp
    local weight

    config_get priority "$section" priority
    config_get srchost "$section" srchost
    config_get dsthost "$section" dsthost
    config_get proto "$section" proto "tcp udp"
    config_get ports "$section" ports
    config_get dscp "$section" dscp -1

    for p in $proto; do
        cmd="-A qos_wfq_ct"
        [ -n "$srchost" ] && cmd="$cmd -s $srchost"
        [ -n "$dsthost" ] && cmd="$cmd -d $dsthost"
        if [ "$p" = "tcp" ] || [ "$p" = "udp" ]; then
            cmd="$cmd -m mark --mark 0/0x0f -p $p -m $p"
            [ -n "$ports" ] && cmd="$cmd -m multiport --ports $ports"
        else
            cmd="$cmd -p $p"
        fi 
        if [ "$dscp" -lt 64 ] && [ "$dscp" -ge 0 ]; then
            add_module xt_dscp
            cmd="$cmd -m dscp --dscp $dscp"
        fi
        cmd="$cmd -j MARK --set-mark $c/0xff"
        echo "$command $cmd"
    done
    c=$((c+1))
}

generate_iptables() {
    add_module xt_multiport
    add_module xt_connmark
    for command in $iptables; do
    	echo "$command -w -t mangle -N qos_wfq"
    	echo "$command -w -t mangle -N qos_wfq_ct"
        
        echo "$command -w -t mangle -A qos_wfq -j CONNMARK --restore-mark --mask 0x0f"
        echo "$command -w -t mangle -A qos_wfq -m mark --mark 0/0x0f -j qos_wfq_ct"
        c=1
        config_foreach parse_class_rule class "$command"
        echo "$command -w -t mangle -A qos_wfq_ct -j CONNMARK --save-mark --mask 0xff"

        echo "$command -w -t mangle -A qos_wfq -j CONNMARK --save-mark --mask 0xff"

        for device in $INTERFACES_DATA; do
            [ -n "$(echo "$device" | cut -d: -f5)" ] && continue
            device=$(echo "$device" | cut -d: -f3)
            echo "
$command -w -t mangle -A OUTPUT -o $device -j qos_wfq
$command -w -t mangle -A FORWARD -o $device -j qos_wfq"
        done
    done
}

load_modules() {
    for module in $MODULES; do
        echo "modprobe $module >&- 2>&-"
    done
}

start_wfq() {
    clear_fwrules
    config_load wfq
    ifb_count=0
    config_foreach parse_interface interface
    [ "$(echo "$INTERFACES_DATA" | wc -l)" = '1' ] && return

    config_foreach parse_classes class
    tcrules=""
    generate_rules

    iptrules=""
    append_line iptrules "$(generate_iptables)"

    load_modules
    [ "$(ls -d /proc/sys/net/ipv4/conf/ifb* 2>&- | wc -l)" -ne "$ifb_count" ] && echo "modprobe ifb numifbs=$ifb_count"
    echo "$tcrules"
    echo "$iptrules"
}

clear_fwrules() {
    for command in $iptables; do
        local iprules
        command="$command -w -t mangle"
        iprules="$($command -w -t mangle -S)"
        append_line stopcmd "$(echo "$iprules" | awk -v cmd="$command" -e '/qos_wfq/ && !/-N/ { sub(/-A/,"-D"); print cmd, $0 }')"
        append_line stopcmd "$(echo "$iprules" | awk -v cmd="$command" -e '/qos_wfq/ && /-N/ { sub(/-N/,"-F"); print cmd, $0; }')"
        append_line stopcmd "$(echo "$iprules" | awk -v cmd="$command" -e '/qos_wfq/ && /-N/ { sub(/-N/,"-X"); print cmd, $0; }')"
    done
    echo "$stopcmd"
}

stop_wfq() {
    stopcmd=""
    for iface in $(tc qdisc show | grep -E '(htb|ingress)' | awk '{print $5}'); do
        append_line stopcmd "tc qdisc del dev $iface ingress 2>&- >&-"
        append_line stopcmd "tc qdisc del dev $iface root 2>&- >&-"
    done
    clear_fwrules
}

case "$CMD" in
    start) start_wfq
    ;;
    stop) stop_wfq
    ;;
esac
