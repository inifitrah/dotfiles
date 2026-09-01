#!/usr/bin/env bash
# per-layout focus v2 — bind per layout support for mango
# Reads state from mango-focus-watcher.sh's cache when fresh; falls back
# to a direct mmsg get (same as v1) when the cache is missing/stale, so
# this still works standalone even if the watcher isn't running.
#
# usage: focus.sh <direction>
#   direction: K|J|H|L | up|down|left|right | next|prev
#
# called from bind.conf via: spawn,$HOME/.config/mango/scripts/focus.sh K
set -uo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/mango-focus"
LAYOUT_FILE="$STATE_DIR/layout"
GROUP_FILE="$STATE_DIR/is_group"
STALE_SECONDS=5
DEBUG="${MANGO_FOCUS_DEBUG:-0}"

log() { [ "$DEBUG" = "1" ] && echo "[focus.sh] $*" >&2; }

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

is_fresh() {
    local file="$1" mtime now age
    [ -f "$file" ] || return 1
    mtime=$(stat -c %Y "$file" 2>/dev/null) || return 1
    now=$(date +%s)
    age=$((now - mtime))
    [ "$age" -le "$STALE_SECONDS" ]
}

# --- is_group: cache first, direct query as fallback ---
if is_fresh "$GROUP_FILE"; then
    IS_GROUP=$(cat "$GROUP_FILE" 2>/dev/null || echo false)
    log "is_group from cache: $IS_GROUP"
else
    IS_GROUP=$(mmsg get focusing-client 2>/dev/null | jq -r '.is_group // false' 2>/dev/null || echo false)
    log "is_group from live query (cache stale/missing): $IS_GROUP"
fi

if [ "$IS_GROUP" = "true" ]; then
    case "$DIR" in
        up)   mmsg dispatch groupfocus,next 2>/dev/null; exit 0 ;;
        down) mmsg dispatch groupfocus,prev 2>/dev/null; exit 0 ;;
    esac
fi

# --- layout: cache first, direct query as fallback ---
if is_fresh "$LAYOUT_FILE"; then
    LAYOUT=$(cat "$LAYOUT_FILE" 2>/dev/null || echo unknown)
    log "layout from cache: $LAYOUT"
else
    ALL_MONITORS_JSON=$(mmsg get all-monitors 2>/dev/null || echo '{"monitors":[]}')
    LAYOUT=$(printf '%s' "$ALL_MONITORS_JSON" | jq -r '.monitors[]? | select(.active == true) | .tags[]? | select(.is_active == true) | .layout // empty' 2>/dev/null | head -n1)
    if [ -z "$LAYOUT" ] || [ "$LAYOUT" = "null" ]; then
        LAYOUT=$(printf '%s' "$ALL_MONITORS_JSON" | jq -r '.monitors[0].tags[]? | select(.is_active == true) | .layout // empty' 2>/dev/null | head -n1)
    fi
    if [ -z "$LAYOUT" ] || [ "$LAYOUT" = "null" ]; then
        LAYOUT="unknown"
    fi
    log "layout from live query (cache stale/missing): $LAYOUT"
fi

# dispatch per layout
# M/K/VK = monocle/deck -> J/K uses focusstack, others use focusdir
# all other layouts (T/CT/VT/RT/S/VS/G/VG/F/VF/DW/unknown) -> focusdir
case "$LAYOUT" in
    M|K|VK)
        case "$DIR" in
            up)    mmsg dispatch focusstack,next 2>/dev/null ;;
            down)  mmsg dispatch focusstack,prev 2>/dev/null ;;
            left)  mmsg dispatch focusdir,left 2>/dev/null ;;
            right) mmsg dispatch focusdir,right 2>/dev/null ;;
            *)     mmsg dispatch focusdir,"$DIR" 2>/dev/null || true ;;
        esac
        ;;
    *)
        mmsg dispatch focusdir,"$DIR" 2>/dev/null || true
        ;;
esac
