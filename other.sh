#!/usr/bin/bash

sudo apt install -y zsh

# golang
# doesn't download the script ~ runs the script directly
bash <(curl -sL https://git.io/go-installer)

# bash formatter
sudo apt install shfmt
