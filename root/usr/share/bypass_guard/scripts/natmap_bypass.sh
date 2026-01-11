#!/bin/sh
# $1 = Public IP, $2 = Outer Port, $4 = Inner Port, $5 = Protocol, $7 = SID

OUTER_PORT="$2"
INNER_PORT="$4"
PROTOCOL="$5"
SID="$7"

CACHE_DIR="/tmp/natmap_cache"
mkdir -p "$CACHE_DIR"
RULE_FILE="$CACHE_DIR/$SID.tcp_fix_rule"
OLD_PORT_FILE="$CACHE_DIR/$SID.old_port"
PORT_FILE="/tmp/natmap_qb_outer_port"

[ "$(uci -q get advanced.global.enable_natmap)" != "1" ] && exit 0

if [ -z "$OUTER_PORT" ] || [ -z "$INNER_PORT" ]; then
    exit 1
fi

nft add table inet bypass_logic 2>/dev/null
nft "add set inet bypass_logic qb_dynamic_ports { type inet_service; flags timeout; }" 2>/dev/null

if [ -f "$OLD_PORT_FILE" ]; then
    OLD_PORT=$(cat "$OLD_PORT_FILE")
    if [ -n "$OLD_PORT" ] && [ "$OLD_PORT" != "$OUTER_PORT" ]; then
        nft delete element inet bypass_logic qb_dynamic_ports { "$OLD_PORT" } 2>/dev/null
    fi
fi
echo "$OUTER_PORT" > "$OLD_PORT_FILE"

nft "add element inet bypass_logic qb_dynamic_ports { $INNER_PORT }" 2>/dev/null
nft "add element inet bypass_logic qb_dynamic_ports { $OUTER_PORT }" 2>/dev/null

if [ "$PROTOCOL" = "udp" ]; then
    echo "$OUTER_PORT" > "$PORT_FILE"
    REAL_TARGET_IP=$(uci -q get natmap."$SID".forward_target)
    if [ -n "$REAL_TARGET_IP" ]; then
        {
            echo "ip daddr $REAL_TARGET_IP udp dport $OUTER_PORT counter dnat ip to $REAL_TARGET_IP:$INNER_PORT"
            echo "ip daddr $REAL_TARGET_IP tcp dport $OUTER_PORT counter dnat ip to $REAL_TARGET_IP:$INNER_PORT"
        } > "$RULE_FILE"
        /etc/init.d/bypass_guard manage_natmap 1
    fi
fi
