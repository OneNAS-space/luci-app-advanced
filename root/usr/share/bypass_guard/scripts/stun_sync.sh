#!/bin/sh

STUN_URL="https://raw.githubusercontent.com/muink/rfc5780-stun-server/master/valid_hosts_rfc5780_tcp.txt"
STUN_CACHE="/etc/config/stun_servers.txt"
STUN_ETAG="/etc/config/stun_servers.etag"
TABLE="bypass_logic"
SET_NAME="stun_direct"

# 检查环境：如果基础 table 不存在则退出
nft list table inet $TABLE >/dev/null 2>&1 || exit 1

sync_stun() {
    local force="$1"
    local etag_header=""
    [ -f "$STUN_ETAG" ] && etag_header="If-None-Match: \"$(cat $STUN_ETAG)\""

    local tmp_header="/tmp/stun_header.tmp"
    local tmp_body="/tmp/stun_body.tmp"

    # 执行条件下载
    curl -sL -D "$tmp_header" --connect-timeout 5 -H "$etag_header" "$STUN_URL" -o "$tmp_body"
    local status=$(grep -m1 "HTTP/" "$tmp_header" | awk '{print $2}')

    if [ "$status" = "200" ] && [ -s "$tmp_body" ]; then
        grep -i "^etag:" "$tmp_header" | awk -F': ' '{print $2}' | tr -d '\r"' > "$STUN_ETAG"
        mv "$tmp_body" "$STUN_CACHE"
        force=1
    fi
    rm -f "$tmp_header" "$tmp_body"

    # 只有在强制更新或集合为空时才解析
    local count=$(nft list set inet $TABLE $SET_NAME 2>/dev/null | grep -c "element")
    if [ -s "$STUN_CACHE" ] && { [ "$force" = "1" ] || [ "$count" -lt 10 ]; }; then
        logger -t bypass_guard "STUN: Updating IP set from cache..."
        local nft_cmd="/tmp/stun_nft.tmp"
        echo "flush set inet $TABLE $SET_NAME" > "$nft_cmd"

        grep -vE '^#|^$' "$STUN_CACHE" | while read -r domain; do
            local clean_domain=$(echo "$domain" | awk '{print $1}')
            [ -z "$clean_domain" ] && continue
            
            # 使用更稳健的解析方式：尝试本地后尝试阿里 DNS
            local ips=$(nslookup "$clean_domain" 127.0.0.1 2>/dev/null | grep 'Address' | awk '{print $2}' | grep -E '^[0-9.]+$' | grep -v '127.0.0.1')
            [ -z "$ips" ] && ips=$(nslookup "$clean_domain" 223.5.5.5 2>/dev/null | grep 'Address' | awk '{print $2}' | grep -E '^[0-9.]+$')

            for ip in $ips; do
                echo "add element inet $TABLE $SET_NAME { $ip }" >> "$nft_cmd"
            done
        done
        
        # 原子化注入，防止多次调用 nft 产生开销
        nft -f "$nft_cmd" 2>/dev/null
        rm -f "$nft_cmd"
        
        logger -t bypass_guard "STUN: IP set updated."
    fi
}

sync_stun "$1"
