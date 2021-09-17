#!/bin/zsh

move_to_trash() {
	local trash_dir
	trash_dir="${HOME}/.trash"

	if [ ! -d "${trash_dir}" ]; then
    	mkdir "${trash_dir}"
	fi

	for i in "$@";
	do
		if [ "$i" ]
		mv "$i" "$trash_dir/$i" && echo "'$i' moved to trash"
	done
}

alias rm="move_to_trash"
