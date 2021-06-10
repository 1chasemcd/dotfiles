#!/bin/zsh

power_selection=$(echo -e "\n\n\n" | rofi -config ~/.config/rofi/power-menu.rasi -dmenu -p "Power")

if [ "$power_selection" = " Exit" ]; then 
	i3-msg exit
elif [ "$power_selection" = "⏻ Shut Down" ]; then
	sudo poweroff
elif [ "$power_selection" = " Reboot" ]; then
	sudo reboot
fi;
