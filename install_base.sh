#!/bin/bash

#  базовый файл для всего в первую очередь для самого необходимиого


# черновыя версия.

#	sudo pacman -Q git || sudo pacman -S --noconfirm git # and if it was installed like a directory?
git --version || sudo apt install git --yes
sudo apt install fonts-jetbrains-mono --yes

# python
# because of python is all ready installed i will not trying to do it but will notes that fact
sudo apt install pipx --yes
pipx ensurepath
sudo pipx ensurepath --global # optional to allow pipx actions with --global argument


# c/c++
sudo apt install build-essential --yes
sudo apt install cmake --yes
sudo apt install bear

# golang
sudo go || bash <(curl -sL https://git.io/go-installer)

#apps
sudo apt install tmux --yes
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# necessery зависемости
sudo apt install nodejs npm --yes


# utils
sudo apt install unzip --yes
sudo apt install curl --yes
sudo apt install htop --yes
sudo apt install ripgrep --yes
sudo apt install fzf --yes
sudo apt install ripgrep --yes
sudo apt install lazygit --yes


flatpak install flathub md.obsidian.Obsidian
flatpak install flathub org.telegram.desktop
flatpak install flathub com.discordapp.Discord



# neovim
sudo apt instal neovim --yes
git clone https://github.com/arsyhiy/nvim.git ~/.config/nvim # it will not cloning if if directory already there. so it will cost not much.



# setup git config 
git config --global user.name "arsyhiy"
git config --global user.email arsyhiy32@gmail.com

sudo apt install openssh-server --yes



sudo apt install zsh --yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
