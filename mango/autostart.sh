#!/bin/bash

set +e
 # fix portal
/usr/lib/xdg-desktop-portal-wlr  >/dev/null 2>&1 &
/usr/lib/xdg-desktop-portal >/dev/null 2>&1 &

gsettings set org.gnome.desktop.interface text-scaling-factor 1.1
noctalia >/dev/null 2>&1 &
vicinae server >/dev/null 2>&1 &
