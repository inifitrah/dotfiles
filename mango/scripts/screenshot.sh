#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Pictures/Screenshots"
filepath="$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"

clip() { wl-copy < "$1"; }

case "${1:-fullscreen}" in
  region)
    g=$(slurp -d); [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath" && clip "$filepath" ;;
  window)
    g=$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')
    [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath" && clip "$filepath" ;;
  freeze)
    p=$(mktemp -u).fifo; mkfifo "$p"
    wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
    read -r < "$p"; grim "$filepath" && clip "$filepath"
    kill "$wp" 2>/dev/null; rm -f "$p" ;;
  freeze-region)
    p=$(mktemp -u).fifo; mkfifo "$p"
    wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
    read -r < "$p"; g=$(slurp -d)
    if [ -z "$g" ]; then kill "$wp" 2>/dev/null; rm -f "$p"; exit 1; fi
    grim -g "$g" "$filepath" && clip "$filepath"
    kill "$wp" 2>/dev/null; rm -f "$p" ;;
  annotate)
    grim "$filepath" && clip "$filepath"
    satty --filename "$filepath" --output-filename "$filepath" --actions-on-enter save-to-file --early-exit ;;
  clipboard)
    f=$(mktemp -t screenshot-XXXXXX.png)
    grim "$f" && wl-copy < "$f"
    rm -f "$f" ;;
  *) grim "$filepath" && clip "$filepath" ;;
esac
