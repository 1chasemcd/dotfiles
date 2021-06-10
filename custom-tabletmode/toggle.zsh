#!/bin/zsh

source ~/.config/custom-tabletmode/status.zsh

if [[ $TABLET_MODE_ON == true ]]
then
	echo "export TABLET_MODE_ON=false" > ~/.config/custom-tabletmode/status.zsh
	xinput enable "AT Translated Set 2 keyboard"
	xinput enable "SYNA32B3:01 06CB:CE7D Touchpad"

else
	echo "export TABLET_MODE_ON=true" > ~/.config/custom-tabletmode/status.zsh
	xinput disable "AT Translated Set 2 keyboard"
	xinput disable "SYNA32B3:01 06CB:CE7D Touchpad"
fi
