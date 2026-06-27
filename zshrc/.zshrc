export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# alias n=nvim

n() {
    local state_file="$HOME/.local/state/nvim/teleport_last_dir"


    rm -f "$state_file"

    nvim "$@"
    local exit_code=$?


    if [[ -f "$state_file" ]]; then

        cat "$state_file"
        echo ""

        local line dir mode

        IFS= read -r line < "$state_file"


        IFS='|' read -r dir mode <<< "$line"


        if [[ "$mode" == "Q" ]]; then
        else
        fi

        if [[ -d "$dir" ]]; then
        else
        fi

        if [[ "$mode" == "Q" && -d "$dir" ]]; then
            builtin cd -- "$dir"
        else
        fi

        rm -f "$state_file"
    else
    fi


    return $exit_code
}
