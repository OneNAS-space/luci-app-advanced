#!/bin/sh

STUN_URL="https://raw.githubusercontent.com/muink/rfc5780-stun-server/master/valid_hosts_rfc5780.txt"
STUN_CACHE="/etc/config/stun_servers.txt"
STUN_ETAG="/etc/config/stun_servers.etag"
TABLE="bypass_logic"
SET_NAME="stun_direct"

nft list table inet $TABLE >/dev/null 2>&1 || exit 1

sync_stun() {
    local force="$1"
    local etag_header=""
    [ -f "$STUN_ETAG" ] && etag_header="If-None-Match: \"$(cat $STUN_ETAG)\""

    local tmp_header="/tmp/stun_header.tmp"
    local tmp_body="/tmp/stun_body.tmp"

    curl -sL -D "$tmp_header" --connect-timeout 5 -H "$etag_header" "$STUN_URL" -o "$tmp_body"
    local status=$(grep -m1 "HTTP/" "$tmp_header" | awk '{print $2}')

    if [ "$status" = "200" ] && [ -s "$tmp_body" ]; then
        grep -i "^etag:" "$tmp_header" | awk -F': ' '{print $2}' | tr -d '\r"' > "$STUN_ETAG"
        mv "$tmp_body" "$STUN_CACHE"
        force=1
    fi
    rm -f "$tmp_header" "$tmp_body"

    local current_empty=$(nft list set inet $TABLE $SET_NAME 2>/dev/null | grep -q "element" && echo 0 || echo 1)
    if [ "$force" != "1" ] && [ "$current_empty" = "0" ]; then
        local last_mod=$(stat -c %Y "$STUN_CACHE" 2>/dev/null || echo 0)
        local now=$(date +%s)
        if [ $((now - last_mod)) -lt 7200 ]; then
            exit 0
        fi
    fi

    logger -t bypass_guard "STUN: Starting DNS resolution for IP set..."
    local domains=$(grep -vE '^#|^$' "$STUN_CACHE")
    local nft_cmd="/tmp/stun_nft.tmp"
    echo "flush set inet $TABLE $SET_NAME" > "$nft_cmd"

    for domain in $domains; do
        local clean_domain=$(echo "$domain" | awk -F: '{print $1}')
        [ -z "$clean_domain" ] && continue
        local ips=$(nslookup "$clean_domain" 127.0.0.1 2>/dev/null | grep 'Address' | awk '{print $2}' | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | grep -v '127.0.0.1')
        if [ -n "$ips" ]; then
            for ip in $ips; do
                echo "add element inet $TABLE $SET_NAME { $ip }" >> "$nft_cmd"
            done
        fi
    done
        
    nft -f "$nft_cmd" 2>/dev/null
    rm -f "$nft_cmd"

    local final_count=$(nft list set inet $TABLE $SET_NAME 2>/dev/null | tr ',' '\n' | grep -cE '([0-9]{1,3}\.){3}[0-9]{1,3}')
    touch "$STUN_CACHE"
    logger -t bypass_guard "STUN: IP set updated with $final_count elements."
}

sync_stun "$1"
