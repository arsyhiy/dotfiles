#!/usr/bin/bash

pipx --version || sudo apt install -y pipx
pipx ensurepath
sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
poetry --version || pipx install poetry # for sudo poetry i get : command not found and 100% trying installing every time.

# zsh and plugins
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sudo apt install snapd
snap install ghostty --classic


# NOTE: check if every thing there bellow is can be installed.

# sway 
sudo apt install waybar swaync pavucontrol pamixer brightnessctl network-manager
sudo apt install brightnessctl
sudo apt install bluez blueman
sudo apt install pipewire pipewire-pulse pamixer pavucontrol
sudo apt install swaylock

sudo apt install sway-notification-center
sudo apt install rofi-bluetooth
sudo apt install pavucontrol
sudo apt install pamixer
