#!/bin/bash

if ! command -v go &>/dev/null; then
  yay -S --noconfirm --needed 
fi

go install github.com/air-verse/air@latest
