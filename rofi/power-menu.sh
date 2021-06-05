#!/bin/zsh

power_selection=$(echo -e " Exit\n⏻ Shut Down\n Reboot" | rofi -width 15 -lines 3  -dmenu -p "Power")

if [ "$power_selection" = " Exit" ]; then 
	swaymsg exit
elif [ "$power_selection" = "⏻ Shut Down" ]; then
	sudo poweroff
elif [ "$power_selection" = " Reboot" ]; then
	sudo reboot
fi;
