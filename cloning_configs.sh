# cloning_configs.sh: cloning configs for programs from github with executing dependency.sh in them

#!/usr/bin/env bash

echo "FIXME: это прототип так что не расчитывай правильную работоспособность."

set -e

clone_and_install() {
    local repo="$1"
    local target="$2"

    echo "Клонирую $repo ..."
    git clone "$repo" "$target"

    if [[ -f "$target/dependency.sh" ]]; then
        echo "Найден dependency.sh, выполняю..."
        chmod +x "$target/dependency.sh"
        "$target/dependency.sh"
    else
        echo "dependency.sh не найден"
    fi
}

# neovim
clone_and_install \
    "https://github.com/arsyhiy/nvim.git" \
    "$HOME/.config/nvim"

# emacs
clone_and_install \
    "https://github.com/arsyhiy/.emacs.d.git" \
    "$HOME/.emacs.d"

# hypr
clone_and_install \
    "https://github.com/arsyhiy/hypr.git" \
    "$HOME/.config/hypr"

# wofi
clone_and_install \
    "https://github.com/arsyhiy/wofi.git" \
    "$HOME/.config/wofi"

# wlogout
clone_and_install \
    "https://github.com/arsyhiy/wlogout.git" \
    "$HOME/.config/wlogout"

# waybar
clone_and_install \
    "https://github.com/arsyhiy/waybar.git" \
    "$HOME/.config/waybar"

# ghostty
clone_and_install \
    "https://github.com/arsyhiy/ghostty.git" \
    "$HOME/.config/ghostty/"

echo "Готово."
