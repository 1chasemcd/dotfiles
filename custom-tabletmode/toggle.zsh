#!/bin/zsh

source ~/.config/custom-tabletmode/status.zsh

if [[ $TABLET_MODE_ON == true ]]
then
	echo "export TABLET_MODE_ON=false" > ~/.config/custom-tabletmode/status.zsh

else
	echo "export TABLET_MODE_ON=true" > ~/.config/custom-tabletmode/status.zsh
fi

setsysmode toggle
