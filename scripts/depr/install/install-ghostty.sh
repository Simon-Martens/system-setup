#!/bin/bash

cd ~
cd source
if [ ! -d "ghostty" ]; then
	git clone git@github.com:ghostty-org/ghostty.git
fi
cd ghostty
git pull

# Install dependencies, change if neccessary
sudo apt install libgtk-4-dev libadwaita-1-dev git blueprint-compiler

# Requires zig (as of now .13)
zig build -Doptimize=ReleaseFast

sudo cp -r zig-out/share /usr/local/
sudo cp -f zig-out/bin/ghostty /usr/local/bin/ 
