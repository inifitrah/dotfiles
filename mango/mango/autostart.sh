#!/bin/bash

set +e

/usr/lib/xdg-desktop-portal-wlr  >/dev/null 2>&1 &
echo "Xft.dpi: 100" | xrdb -merge
gsettings set org.gnome.desktop.interface text-scaling-factor 1.1
noctalia >/dev/null 2>&1 &
vicinae server >/dev/null 2>&1 &
