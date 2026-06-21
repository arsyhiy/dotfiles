export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# alias
alias n=nvim

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
setopt HIST_IGNORE_DUPS # ignore duplicates for command history
setopt HIST_IGNORE_ALL_DUPS # or delete old duplicates
