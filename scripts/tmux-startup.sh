#!/bin/bash
# Headless bash startup script to attach to a default home directory session

function tat {
	if [ $(pwd) == "$HOME" ]; then
		name="home"
	else
		name=$(basename `pwd` | sed -e 's/\.//g')
	fi

  if tmux ls 2>&1 | grep "$name"; then
    tmux attach -t "$name"
  elif [ -f .envrc ]; then
    direnv exec / tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

cd ~
tat
