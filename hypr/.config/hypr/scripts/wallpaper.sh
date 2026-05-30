#!/bin/bash

# Kill any existing instances to prevent conflicts
killall awww-daemon

# Start the daemon in the background
awww-daemon &

# Wait for the daemon to fully initialize (CRITICAL STEP)
sleep 1

# Set the wallpaper   thy just move from swww awww .... so this might need updating i m wiating for it to break 
awww img /home/abde/.config/backgrounds/shaded.png
