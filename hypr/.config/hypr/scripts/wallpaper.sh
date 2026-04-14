#!/bin/bash

# Kill any existing instances to prevent conflicts
killall swww-daemon

# Start the daemon in the background
swww-daemon &

# Wait for the daemon to fully initialize (CRITICAL STEP)
sleep 1

# Set the wallpaper   thy just move from swww awww .... so this might need updating i m wiating for it to break 
swww img /home/abde/.config/backgrounds/shaded.png
