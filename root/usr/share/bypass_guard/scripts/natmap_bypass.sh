#!/bin/sh
# $1 = Public IP, $2 = Outer Port, $4 = Inner Port, $5 = Protocol, $7 = SID

OUTER_PORT="$2"
INNER_PORT="$4"
PROTOCOL="$5"
SID="$7"

CACHE_DIR="/tmp/natmap_cache"
mkdir -p "$CACHE_DIR"
RULE_FILE="$CACHE_DIR/$SID.tcp_fix_rule"
PORT_FILE="/tmp/natmap_qb_inner_port"
LAST_PORT_FILE="$CACHE_DIR/natmap_last_port"

[ "$(uci -q get advanced.global.enable_natmap)" != "1" ] && exit 0

if [ -z "$OUTER_PORT" ] || [ -z "$INNER_PORT" ]; then
    exit 1
fi

nft add table inet bypass_logic 2>/dev/null
nft "add set inet bypass_logic qb_dynamic_ports { type inet_service; flags timeout; }" 2>/dev/null
nft "add element inet bypass_logic qb_dynamic_ports { $INNER_PORT }" 2>/dev/null

if [ "$PROTOCOL" = "udp" ]; then
    LAST_PORT=$(cat "$LAST_PORT_FILE" 2>/dev/null)
    if [ "$OUTER_PORT" = "$LAST_PORT" ] && [ -f "$RULE_FILE" ]; then
        exit 0
    fi

    echo "$INNER_PORT" > "$PORT_FILE"
    echo "$OUTER_PORT" > "$LAST_PORT_FILE"

    REAL_TARGET_IP=$(uci -q get natmap."$SID".forward_target)
    WAN_IF=$(uci -q get network.wan.device || uci -q get network.wan.ifname)

    if [ -n "$REAL_TARGET_IP" ] && [ -n "$WAN_IF" ]; then
        rm -f "$CACHE_DIR"/*.tcp_fix_rule
        {
            echo "iifname \"$WAN_IF\" udp dport $OUTER_PORT counter dnat ip to $REAL_TARGET_IP:$INNER_PORT"
            echo "iifname \"$WAN_IF\" tcp dport $OUTER_PORT counter dnat ip to $REAL_TARGET_IP:$INNER_PORT"
        } > "$RULE_FILE"
        /etc/init.d/bypass_guard manage_natmap 1
    fi
fi
