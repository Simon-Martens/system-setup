#!/bin/bash

if ! command -v go &>/dev/null; then
  yay -S --noconfirm --needed go 
fi

go install github.com/air-verse/air@latest
