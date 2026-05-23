#!/bin/bash

set +e
/usr/lib/xdg-desktop-portal-wlr  >/dev/null 2>&1 &
awww-daemon >/dev/null 2>&1 &
vibepanel >/dev/null 2>&1 &
vicinae server >/dev/null 2>&1 &
