#!/bin/bash

# Wait for Hyprland to be ready
while [ ! -e "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock" ]; do
    sleep 1
done

# Wait for the monitor
sleep 5

# This forces Sunshine to ignore Wayland and use KMS (Kernel) capture,
unset WAYLAND_DISPLAY

export WLR_NO_HARDWARE_CURSORS=1
export WLR_RENDERER_ALLOW_SOFTWARE=1

sunshine > ~/sunshine.log 2>&1
