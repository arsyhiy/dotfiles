export ZSH=$HOME/.oh-my-zsh

# what theme zsh will use
ZSH_THEME="agnoster"

# adding plugins into zsh
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Remove older duplicates from command history
setopt HIST_IGNORE_DUPS
# Ignore all duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS 

alias n=nvim

# functions for fuzzy finder or fz
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

# >>> go.sh managed block >>>
export GOROOT=/home/popandopuloarseniy/.go
export GOPATH=/home/popandopuloarseniy/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# <<< go.sh managed block <<<
