#!/usr/bin/env bash

# THAT'S SCRIPT IN EXPRIMENT STAGE!!

setup_nvim_config() {
    local repo_url="git@github.com:arsyhiy/nvim.git"
    local target="$DEV_ENV/env/.config/nvim"

    if [ ! -d "$target/.git" ]; then
        echo "Cloning nvim config..."
        git clone "$repo_url" "$target"
    else
        echo "Updating nvim config..."
        pushd "$target" >/dev/null
        git pull --ff-only
        popd >/dev/null
    fi
}
