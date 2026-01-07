#!/bin/sh
# $1 = Public IP, $2 = Outer Port, $4 = Inner Port, $5 = Protocol, $7 = SID

PUBLIC_IP="$1"
OUTER_PORT="$2"
INNER_PORT="$4"
PROTOCOL="$5"
SID="$7"

CACHE_DIR="/tmp/natmap_cache"
mkdir -p "$CACHE_DIR"
RULE_FILE="$CACHE_DIR/$SID.tcp_fix_rule"
OLD_PORT_FILE="$CACHE_DIR/$SID.old_port"
PORT_FILE="/tmp/natmap_qb_outer_port"
UDP_STATE_FILE="/tmp/natmap_qb_udp_state"

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
    echo "${PUBLIC_IP}|${OUTER_PORT}" > "$UDP_STATE_FILE"
    echo "$OUTER_PORT" > "$PORT_FILE"
elif [ "$PROTOCOL" = "tcp" ]; then
    RETRY=60
    VALID_UDP_PORT=""
    while [ "$RETRY" -gt 0 ]; do
        if [ -f "$UDP_STATE_FILE" ]; then
            CONTENT=$(cat "$UDP_STATE_FILE")
            FILE_IP=$(echo "$CONTENT" | cut -d'|' -f1)
            FILE_PORT=$(echo "$CONTENT" | cut -d'|' -f2)
            if [ "$FILE_IP" = "$PUBLIC_IP" ]; then
                VALID_UDP_PORT="$FILE_PORT"
                break
            fi
        fi
        sleep 1
        RETRY=$((RETRY - 1))
    done

    if [ -n "$VALID_UDP_PORT" ]; then
        rm -f "$RULE_FILE"
        if [ "$OUTER_PORT" != "$VALID_UDP_PORT" ]; then
            REAL_TARGET_IP=$(uci -q get natmap."$SID".forward_target)
            if [ -n "$REAL_TARGET_IP" ]; then
                RULE="ip daddr $REAL_TARGET_IP tcp dport $OUTER_PORT counter dnat ip to $REAL_TARGET_IP:$VALID_UDP_PORT"
                nft "add rule inet bypass_logic qb_fix $RULE" 2>/dev/null
                echo "$RULE" > "$RULE_FILE"
            fi
        fi
    else
        logger -t natmap_bypass "Error: TCP alignment timed out after 60s for $SID"
    fi
fi
