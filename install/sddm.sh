#!/bin/bash

# SDDM Display Manager / Greeter

yay -S --noconfirm --needed sddm

sudo systemctl enable sddm
