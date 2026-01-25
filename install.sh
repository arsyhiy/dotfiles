#!/bin/bash
# NOTE: довести до нормального состояния только в когда доведем весь репозиторий до ума

# this script is for installing all packages

# all packages with the same name as you use
packages=(
    cmake
    nodejs 
    npm
    tmux
    emacs
    htop
    ripgrep
    fzf
    lazygit
    bear
    unzip
    curl
    pipx
#    poetry
)

# all packages with not the same name as you use
# NOTE: дать нормальное название
declare -A exceptions=(
    ["ssh"]="openssh-server"
    ["nvim"]="neovim"
    ["gcc"]="build-essential"
)



# maybe it will better to keep it somewherelse no in dotfiles repo
log_file="packages.log"
> "$log_file"

for pkg in "${packages[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "$pkg уже установлен."
    else
        echo "Устанавливаем $pkg..."
        if sudo apt install -y "$pkg"; then
            echo "$pkg установлен успешно."
        else
            echo "$pkg не удалось установить, записываем в лог."
            echo "$pkg" >> "$log_file"
        fi
    fi
done

for bin in "${!exceptions[@]}"; do
    pkg="${exceptions[$bin]}"

    if command -v "$bin" >/dev/null 2>&1; then
        echo "$bin already present"
    else
        echo "Installing $pkg (for $bin)..."
        if sudo apt install -y "$pkg"; then
            echo "$pkg installed"
        else
            echo "$pkg failed"
            echo "$pkg" >> "$log_file"
        fi
    fi
done

# Flatpak приложения (не через массив)
flatpaks=(
    "org.telegram.desktop"
    "com.discordapp.Discord"
    "md.obsidian.Obsidian"
    "org.torproject.torbrowser-launcher"
)

for app in "${flatpaks[@]}"; do
    if flatpak list | grep -q "$app"; then
        echo "$app уже установлен."
    else
        echo "Устанавливаем $app..."
        flatpak install -y flathub "$app"
    fi
done

if [ -s "$log_file" ]; then
    echo "Не удалось установить следующие пакеты. Проверьте $log_file"
fi



#flathub
