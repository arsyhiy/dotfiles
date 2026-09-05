export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

alias n=nvim

fd() {
    local dir
    dir=$(find ~ -type d | fzf)

    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}

ff(){
    local file
    file=$(find . -type f | fzf)

    if [ -n "$file" ]; then
        nvim "$file" # or make your favorite editor for that
    fi
}

. "$HOME/.local/bin/env"

export PATH="/home/popandopuloarseniy/.local/bin:$PATH"
