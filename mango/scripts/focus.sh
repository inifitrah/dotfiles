#!/usr/bin/env bash
# per-layout focus — bind per layout support for mango
# default: focusdir (up/down/left/right)
# monocle/deck (M/K/VK): J/K -> focusstack (prev/next), lainnya tetap focusdir
# scroller (S/VS) dll: tetap focusdir (bisa di-extend kalau mau scroller_stack dll)
#
# usage: focus.sh <direction>
#   direction: K|J|H|L | up|down|left|right | next|prev
#   K/up/next    -> focusdir up    atau focusstack next (monocle)
#   J/down/prev  -> focusdir down  atau focusstack prev (monocle)
#   H/left       -> focusdir left
#   L/right      -> focusdir right
#
# dipanggil dari bind.conf via: spawn,$HOME/.config/mango/scripts/focus.sh K
set -euo pipefail

# normalisasi argumen ke up/down/left/right
normalize_dir() {
    case "${1:-}" in
        K|k|up|Up|UP|next|Next) echo "up" ;;
        J|j|down|Down|DOWN|prev|Prev) echo "down" ;;
        H|h|left|Left) echo "left" ;;
        L|l|right|Right) echo "right" ;;
        *) echo "$1" ;;
    esac
}

DIR_RAW="${1:-}"
if [ -z "$DIR_RAW" ]; then
    echo "[focus.sh] usage: $0 <K|J|H|L|up|down|left|right>" >&2
    exit 1
fi

DIR=$(normalize_dir "$DIR_RAW")

# ambil layout langsung dari get all-monitors (tanpa 2× IPC)
# data watch/get all-monitors sudah punya monitors[].tags[].layout + active flag,
# jadi cukup 1 call: aktif monitor → aktif tag → layout
ALL_MONITORS_JSON=$(mmsg get all-monitors 2>/dev/null || echo '{"monitors":[]}')
if [ -z "$ALL_MONITORS_JSON" ]; then
    echo "[focus.sh] gagal baca all-monitors, fallback ke focusdir $DIR" >&2
    mmsg dispatch focusdir,"$DIR" 2>/dev/null || true
    exit 0
fi

LAYOUT=$(echo "$ALL_MONITORS_JSON" | jq -r '.monitors[] | select(.active == true) | .tags[] | select(.is_active == true) | .layout // empty' 2>/dev/null | head -n1)
# fallback: kalau tidak ketemu via active flag, ambil first monitor first active tag
if [ -z "$LAYOUT" ] || [ "$LAYOUT" = "null" ]; then
    LAYOUT=$(echo "$ALL_MONITORS_JSON" | jq -r '.monitors[0].tags[] | select(.is_active == true) | .layout // empty' 2>/dev/null | head -n1)
fi
if [ -z "$LAYOUT" ] || [ "$LAYOUT" = "null" ]; then
    LAYOUT="unknown"
fi

# debug log (lihat via journalctl atau jalankan manual)
# echo "[focus.sh] mon=$ACTIVEMON layout=$LAYOUT dir=$DIR (raw=$DIR_RAW)" >&2

# dispatch per layout
# Layout symbols:
#   T,CT,VT,RT = tile variants
#   S,VS       = scroller
#   G,VG,F,VF  = grid/fair
#   M,K,VK     = monocle/deck
#   DW         = dwindle
case "$LAYOUT" in
    M|K|VK)
        # deck/monocle: J/K (up/down) pakai focusstack, sisanya focusdir
        case "$DIR" in
            up)   mmsg dispatch focusstack,next 2>/dev/null ;;
            down) mmsg dispatch focusstack,prev 2>/dev/null ;;
            left) mmsg dispatch focusdir,left 2>/dev/null ;;
            right) mmsg dispatch focusdir,right 2>/dev/null ;;
            *)    mmsg dispatch focusdir,"$DIR" 2>/dev/null || true ;;
        esac
        ;;
    S|VS)
        # scroller — default focusdir, tapi bisa diganti ke scroller_stack kalau mau:
        #   mmsg dispatch scroller_stack,up/down dll
        # untuk sekarang samakan dengan default biar konsisten dengan hypr smart_nav kamu
        mmsg dispatch focusdir,"$DIR" 2>/dev/null || true
        ;;
    DW|T|CT|VT|RT|G|VG|F|VF|*)
        # default: tiled, grid, dwindle, dan unknown — selalu focusdir
        mmsg dispatch focusdir,"$DIR" 2>/dev/null || true
        ;;
esac
