#!/usr/bin/env bash

# a super simple script to install my favorite fonts

curl -o /tmp/jetbrains.zip -L ttps://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip /tmp/jetbrains.zip -d ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/

