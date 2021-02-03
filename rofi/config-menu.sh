#!/bin/zsh

rofi_options_string="alacritty
vscode
i3
micro
mirage
neofetch
polybar
rofi
xinit
zsh"

config_selection=$(echo -e $rofi_options_string | rofi -dmenu -p "Config")

case $config_selection in
	"alacritty") 
		code ~/.config/alacritty/alacritty.yml
	;;
	"i3") 
		code ~/.config/i3/config
	;;
	"micro") 
		code ~/.config/micro/settings.json
	;;
	"mirage") 
		code ~/.config/mirage/mirage1.conf
	;;
	"neofetch") 
		code ~/.config/neofetch/config.conf
	;;
	"polybar") 
		code ~/.config/polybar/config
	;;
	"rofi") 
		code ~/.config/rofi/config.rasi
	;;
	"vscode") 
		code ~/.config/Code/User/settings.json
	;;
	"xinit") 
		code ~/.config/xinit/xinitrc
	;;
	"zsh") 
		code ~/.config/zsh/zshrc
	;;
esac
