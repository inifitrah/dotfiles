#!/usr/bin/env bash
# bar auto-hide toggle — sh equivalent dari hypr/binds.lua autoHide
# hypr Lua: local autoHide = false + hl.dispatch(bar-auto-hide-set on/off, reserve, dock)
# sh: pakai file cache biar persisten across reboot (sesuai request: pake cache)
# state 0 = off (default), 1 = on
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/noctalia/bar-autohide"
mkdir -p "$(dirname "$STATE")"

# baca state sekarang, default 0 kalau file belum ada / corrupt
cur="0"
if [ -f "$STATE" ]; then
    cur=$(cat "$STATE" 2>/dev/null | tr -d ' \n\r' || echo "0")
    case "$cur" in
        0|1) ;;
        *) cur="0" ;;
    esac
fi

# flip
if [ "$cur" = "1" ]; then
    nxt="0"
    cmd="off"
else
    nxt="1"
    cmd="on"
fi

# tulis state baru (atomik via temp file)
tmp="${STATE}.tmp.$$"
printf "%s\n" "$nxt" > "$tmp"
mv -f "$tmp" "$STATE"

# dispatch — sama persis dengan hypr lua: auto-hide + reserve + dock
# plus bar-layer-set overlay/top sesuai request
# pakai noctalia msg, bukan mmsg (noctalia IPC)
noctalia msg bar-auto-hide-set "$cmd" 2>/dev/null || true
noctalia msg bar-reserve-toggle 2>/dev/null || true
noctalia msg dock-toggle 2>/dev/null || true
if [ "$cmd" = "on" ]; then
    # di hide -> overlay (bar tidak reserve, di atas window tapi auto-hide)
    noctalia msg bar-layer-set overlay 2>/dev/null || true
else
    # tidak di hide -> top (bar reserve, always on top)
    noctalia msg bar-layer-set top 2>/dev/null || true
fi

# optional feedback (komentar kalau tidak mau notify)
# if command -v notify-send >/dev/null 2>&1; then
#     notify-send -u low "bar auto-hide" "$cmd" 2>/dev/null || true
# fi

# debug ke stderr kalau dipanggil manual: ./bar-toggle.sh
echo "[bar-toggle] $cur -> $nxt ($cmd)" >&2
