#!/bin/bash

INSTANCE_NAME="trah-shell"

ags quit -i "$INSTANCE_NAME" &
sleep 0.2
ags run -g 3 &
