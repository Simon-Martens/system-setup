#!/bin/bash

sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt remove --autoremove firefox -y
sudo snap remove --purge firefox

echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 900
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt update 
sudo apt install firefox fonts-lyx -y
