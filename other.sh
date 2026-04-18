#!/usr/bin/bash



sudo apt install -y zsh
# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# golang
# doesn't download the script ~ runs the script directly
bash <(curl -sL https://git.io/go-installer)

# bash formatter
sudo apt install shfmt
