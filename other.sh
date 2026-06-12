#!/usr/bin/env bash

sudo dnf install -y zsh

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# golang
# doesn't download the script ~ runs the script directly
bash <(curl -sL https://git.io/go-installer)

# bash formatter
sudo dnf install -y shfmt

# lazygit 
# acutally very convenient to use 
sudo dnf copr enable dejan/lazygit
sudo dnf install -y lazygit



# ghostty
sudo dnf copr enable scottames/ghostty
sudo dnf install ghostty


# neovim
sudo dnf install -y neovim



# emacs
sudo dnf install -y emacs


# hypr
sudo dnf copr enable lionheartp/Hyprland
sudo dnf install -y hyprland

sudo dnf install -y hyprlock
sudo dnf install -y hypridle
sudo dnf install -y swaync
sudo dnf install -y hyprpaper
sudo dnf install -y hyprland-guiutils

# waybar
sudo dnf install -y waybar

# wlogout
sudo dnf install -y wlogout 


# wofi
sudo dnf install -y wofi 
