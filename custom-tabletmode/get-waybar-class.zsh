sleep 0.1

source ~/.config/custom-tabletmode/status.zsh

if [[ $TABLET_MODE_ON = true ]]; then
	echo "text
tooltip
active"
else
	echo "text
tooltip
inactive"
fi
