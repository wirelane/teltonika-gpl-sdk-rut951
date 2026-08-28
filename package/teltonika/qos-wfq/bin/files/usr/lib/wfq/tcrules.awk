BEGIN {
    FS = ":"
    iface_count = 0
    class_count = 0
}

$1 == "class" {
    class_count++
    class_section[class_count] = $2
    class_priority[class_count] = $3
    class_srchost[class_count] = $4
    class_dsthost[class_count] = $5
    class_proto[class_count] = $6
    class_ports[class_count] = $7
    class_weight[class_count] = $8
}

END {
    if (rate == "") {
        rate = 1000
    }

    if (dir == "up") {
        printf "tc qdisc del dev %s root >&- 2>&-\n", dev
        printf "tc qdisc add dev %s root handle 1: htb default 999\n", dev
        printf "tc class add dev %s parent 1: classid 1:1 htb rate %s ceil %s\n", dev, rate "kbit", rate "kbit"
    } else {
        ifbdev = "ifb" ifbnum 
        printf "ip link add %s type ifb >&- 2>&-\n", ifbdev
        printf "ip link set %s up >&- 2>&-\n", ifbdev

        printf "tc qdisc del dev %s root >&- 2>&-\n", ifbdev
        printf "tc qdisc add dev %s root handle 1: htb default 999\n", ifbdev
        printf "tc class add dev %s parent 1: classid 1:1 htb rate %s ceil %s\n", ifbdev, rate "kbit", rate "kbit"

        printf "tc qdisc del dev %s ingress >&- 2>&-\n", dev
        printf "tc qdisc add dev %s ingress >&- 2>&-\n", dev
        printf "tc filter add dev %s parent ffff: prio 1 u32 match u32 0 0 flowid 1:1 action connmark action mirred egress redirect dev %s\n", dev, ifbdev
        dev = ifbdev
    }

    total_weight = 0
    for (i = 1; i <= class_count; i++) {
        total_weight = total_weight + class_weight[i]
    }
    

    for (i = 1; i <= class_count; i++) {
        classid = 10 + i
        weight = class_weight[i]
        if (weight == "") {
            weight = 1
        }
        coeff = weight/total_weight
        printf "tc class add dev %s parent 1:1 classid 1:%d htb prio %s rate %s ceil %s \n", dev, classid, class_priority[i], (rate + 0) * coeff "kbit", rate "kbit"
    }

    for (i = 1; i <= class_count; i++){
        classid = 10 + i
        printf "tc qdisc add dev %s parent 1:%d handle %d: fq_codel limit 800 quantum 300 noecn \n", dev, classid, classid * 100

    }
    
    for (i = 1; i <= class_count; i++){
        mark_class = i
        classid = 10 + i
        filter_cmd = "tc filter add dev %s parent 1: prio %d handle %s fw flowid 1:%d\n"
        if (dir == "up") {
            filter_1 = sprintf("0x%x0/0xf0", mark_class)
            filter_2 = sprintf("0x0%x/0x0f", mark_class)
        } else {
            filter_1 = sprintf("0x0%x/0x0f", mark_class)
			filter_2 = sprintf("0x%x0/0xf0", mark_class)
        }


        printf filter_cmd, dev, classid * 2, filter_1, classid
        printf filter_cmd, dev, classid * 2 + 1, filter_2, classid
        # Optional hook for adding filters based on class fields:
        # class_srchost[i], class_dsthost[i], class_proto[i], class_ports[i]
    }
}
