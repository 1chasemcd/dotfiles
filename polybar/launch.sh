#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
# I've commented this out cause it's too slow.
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar workspaces &
polybar launcher &
polybar status &

echo "Polybar launched..."
