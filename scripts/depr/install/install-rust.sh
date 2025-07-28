#!/bin/bash

# Install rustup -- Interactive
cd ~/Downloads
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

source ~/.bashrc
