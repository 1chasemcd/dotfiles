#!/bin/zsh

rofi_options_string="kitty
vscode
i3
micro
mirage
neofetch
polybar
rofi
zsh
picom
config-menu"

config_selection=$(echo -e $rofi_options_string | rofi -dmenu -width 25 -no-show-icons -p "Config")

case $config_selection in
	"kitty") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/kitty/kitty.conf"
	;;
	"i3") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/i3/config"
	;;
	"micro") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/micro/settings.json"
	;;
	"mirage") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/mirage/mirage.conf"
	;;
	"neofetch") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/neofetch/config.conf"
	;;
	"polybar")
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/polybar/config"
	;;
	"rofi") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/rofi/config.rasi"
	;;
	"vscode") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/Code\ -\ OSS/User/settings.json"
	;;
	"zsh") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/zsh/zshrc"
	;;
	"picom") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/picom/picom.conf"
	;;
	"config-menu") 
		kitty zsh -c "cat ~/.config/wpg/sequences ; micro ~/.config/rofi/config-menu.sh"
	;;
esac
