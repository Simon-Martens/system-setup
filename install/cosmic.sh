#!/bin/bash

yay -S --needed --noconfirm cosmic gvfs gvfs-smb gvfs-nfs gvfs-dnssd 
sudo systemctl enable cosmic-greeter.service
