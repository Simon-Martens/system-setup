#!/bin/bash


if ! command -v node &>/dev/null; then
	yay -S --needed --noconfirm nodejs npm
fi
