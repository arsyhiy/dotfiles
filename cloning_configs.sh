# git clone https://github.com/arsyhiy/nvim.git ~/.config/nvim

# git clone https://github.com/arsyhiy/.emacs.d.git ~/.emacs.d/



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

clone_and_install \
    "https://github.com/arsyhiy/nvim.git" \
    "$HOME/.config/nvim"

clone_and_install \
    "https://github.com/arsyhiy/.emacs.d.git" \
    "$HOME/.emacs.d"

echo "Готово."
