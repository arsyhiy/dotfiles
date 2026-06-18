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

# docker
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

sudo dnf install docker-compose-switch
sudo usermod -aG docker $USER


# npm
npm install -g vscode-langservers-extracted
