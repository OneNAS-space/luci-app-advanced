#!/bin/sh
# $2 = Outer Port from natmap

enabled=$(uci -q get advanced.global.enable_natmap)
if [ "$enabled" != "1" ]; then
    exit 0
fi

if [ -n "$2" ]; then
    nft add table inet bypass_logic 2>/dev/null
    nft "add set inet bypass_logic qb_dynamic_ports { type inet_service; flags timeout; }" 2>/dev/null
    nft flush set inet bypass_logic qb_dynamic_ports
    nft "add element inet bypass_logic qb_dynamic_ports { $2 timeout 24h }"
    echo "$2" > /tmp/natmap_qb_outer_port
    logger -t natmap_bypass "Updated QB Outer Port: $2"
fi
