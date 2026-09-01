#!/usr/bin/env bash
# mango-focus-watcher.sh — background daemon
# Keeps active layout + is_group state cached on disk by subscribing to
# mmsg watch streams, so focus.sh never has to do a request/response
# round-trip on every keypress.
#
# Run this once, persistently, from your Mango autostart (see README below).
set -uo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/mango-focus"
LAYOUT_FILE="$STATE_DIR/layout"
GROUP_FILE="$STATE_DIR/is_group"

mkdir -p "$STATE_DIR"

command -v mmsg >/dev/null 2>&1 || { echo "[mango-focus-watcher] mmsg not found in PATH" >&2; exit 1; }
command -v jq   >/dev/null 2>&1 || { echo "[mango-focus-watcher] jq not found in PATH" >&2; exit 1; }

# atomic write: write to a tmp file then mv, so focus.sh never reads a
# half-written file
atomic_write() {
    local file="$1" content="$2" tmp
    tmp=$(mktemp "${file}.XXXXXX") || return 1
    printf '%s' "$content" > "$tmp" 2>/dev/null || { rm -f "$tmp"; return 1; }
    mv -f "$tmp" "$file" 2>/dev/null
}

extract_layout() {
    local json="$1" layout
    layout=$(printf '%s' "$json" | jq -r '.monitors[]? | select(.active == true) | .tags[]? | select(.is_active == true) | .layout // empty' 2>/dev/null | head -n1)
    if [ -z "$layout" ]; then
        layout=$(printf '%s' "$json" | jq -r '.monitors[0].tags[]? | select(.is_active == true) | .layout // empty' 2>/dev/null | head -n1)
    fi
    [ -z "$layout" ] && layout="unknown"
    printf '%s' "$layout"
}

watch_layout() {
    while true; do
        mmsg watch all-monitors 2>/dev/null | while IFS= read -r line; do
            [ -z "$line" ] && continue
            atomic_write "$LAYOUT_FILE" "$(extract_layout "$line")"
        done
        # mmsg watch died (compositor restarting, socket hiccup, etc) — retry
        sleep 1
    done
}

watch_group() {
    while true; do
        mmsg watch focusing-client 2>/dev/null | while IFS= read -r line; do
            [ -z "$line" ] && continue
            local is_group
            is_group=$(printf '%s' "$line" | jq -r '.is_group // false' 2>/dev/null)
            [ -z "$is_group" ] && is_group="false"
            atomic_write "$GROUP_FILE" "$is_group"
        done
        sleep 1
    done
}

watch_layout &
LAYOUT_PID=$!
watch_group &
GROUP_PID=$!

cleanup() {
    kill "$LAYOUT_PID" "$GROUP_PID" 2>/dev/null
    wait 2>/dev/null
}
trap cleanup EXIT TERM INT

wait
