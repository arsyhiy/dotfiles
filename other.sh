#!/usr/bin/env bash

# zsh
sudo apt install -y zsh

## ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# for emacs
sudo apt install libtool libtool-bin

# build neovim

# download all requirements
sudo apt-get install ninja-build gettext cmake unzip curl

git clone https://github.com/neovim/neovim

cd neovim

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd .. 
rm -rf neovim

# install ghostty
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

# install fonts 
curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh | bash -s -- JetBrainsMono
