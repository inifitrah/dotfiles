#!/bin/bash

# Function to relaunch ags
relaunch_ags() {
  echo "Relaunching ags..."
  if pidof ags >/dev/null; then
    pkill ags
    sleep 0.5
    ags quit 
  fi
  sleep 0.5
  ags run -g 3 &
}

# Handle termination signals (CTRL+C atau kill)
cleanup() {
  echo "Stopping script and killing ags..."
  ags quit
  pkill ags
  exit 0
} 

trap cleanup SIGINT SIGTERM

# Export function
export -f relaunch_ags

# Monitor directory using entr
find /$HOME/.dotfiles/ags/.config/ags -type f | entr -r bash -c "relaunch_ags"
