export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

alias n=nvim

. "$HOME/.local/bin/env"

export PATH="/home/popandopuloarseniy/.local/bin:$PATH"
