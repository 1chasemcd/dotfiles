#!/bin/zsh

rofi_options_string="alacritty
vscode
sway
micro
mirage
neofetch
waybar
rofi
zsh
config-menu"

config_selection=$(echo -e $rofi_options_string | rofi -dmenu -width 25 -no-show-icons -p "Config")

case $config_selection in
	"alacritty") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/alacritty/alacritty.yml"
	;;
	"sway") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/sway/config"
	;;
	"micro") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/micro/settings.json"
	;;
	"mirage") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/mirage/mirage1.conf"
	;;
	"neofetch") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/neofetch/config.conf"
	;;
	"waybar")
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/waybar/config" &
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/waybar/style.css"
	;;
	"rofi") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/rofi/config.rasi"
	;;
	"vscode") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/Code\ -\ OSS/User/settings.json"
	;;
	"zsh") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.zshrc"
	;;
	"config-menu") 
		alacritty -e zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/rofi/config-menu.sh"
	;;
esac
