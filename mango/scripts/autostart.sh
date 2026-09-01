#!/bin/bash

set +e
gsettings set org.gnome.desktop.interface text-scaling-factor 1.1
noctalia >/dev/null 2>&1 &
vicinae server >/dev/null 2>&1 &
~/.config/mango/scripts/mango-focus-watcher.sh
