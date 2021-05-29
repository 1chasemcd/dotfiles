#!/bin/zsh

power_selection=$(echo -e " Exit\n⏻ Shut Down\n Reboot" | rofi -dmenu -width 10 -lines 3 -no-show-icons -p "Power")

if [ "$power_selection" = " Exit" ]; then 
	swaymsg exit
elif [ "$power_selection" = "⏻ Shut Down" ]; then
	sudo poweroff
elif [ "$power_selection" = " Reboot" ]; then
	sudo reboot
fi;
