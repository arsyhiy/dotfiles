# Environment
export EDITOR="vim"
export VISUAL="$EDITOR"
export PATH="$HOME/.local/bin:$PATH"
export PAGER="less"
export LESS="-R"

# History
HISTSIZE=10000
SAVEHIST=20000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
plugins=(git zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

# Shell options
setopt AUTO_CD
setopt CORRECT
setopt GLOB_STAR_SHORT

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias df='df -h'
alias du='du -h'
alias free='free -h'

alias n='nvim'


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
