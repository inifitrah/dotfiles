#!/bin/bash

DISPLAY_NUM=":2"
APP="vinegar"

if ! pgrep -x "xwayland-satellite" >/dev/null; then
    xwayland-satellite "$DISPLAY_NUM" &
    XWAYLAND_PID=$!

    for i in $(seq 1 10); do
        xdpyinfo -display "$DISPLAY_NUM" >/dev/null 2>&1 && break
        sleep 0.5
    done
else
    XWAYLAND_PID=$(pgrep -x "xwayland-satellite")
fi

DISPLAY="$DISPLAY_NUM" "$APP"

kill "$XWAYLAND_PID" 2>/dev/null
