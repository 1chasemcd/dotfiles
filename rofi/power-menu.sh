#!/bin/zsh

power_selection=$(echo -e "Exit\nShut Down\nReboot" | rofi -dmenu -p "Power")

if [ "$power_selection" = "Exit" ]; then 
	killall -q polybar
	i3-msg exit
elif [ "$power_selection" = "Shut Down" ]; then
	sudo poweroff
elif [ "$power_selection" = "Reboot" ]; then
	sudo reboot
fi;
