#!/usr/bin/env bash


# download all requirements
sudo apt-get install ninja-build gettext cmake unzip curl

git clone https://github.com/neovim/neovim

cd neovim

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd .. 
rm -rf neovim
