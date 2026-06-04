#!/usr/bin/bash

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
