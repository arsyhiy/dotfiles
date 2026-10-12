#!/usr/bin/env bash

set -u

packages=(
    unzip
    curl
    stow
    npm
    emacs
    lazygit
    tmux
)

log_file="packages.log"
> "$log_file"

for pkg in "${packages[@]}"; do
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
        echo "$pkg already installed."
    else
        echo "Installing $pkg..."

        if sudo apt install -y "$pkg"; then
            echo "$pkg installed successfully."
        else
            echo "$pkg failed" | tee -a "$log_file"
        fi
    fi
done

# Install Flatpak if missing
if ! command -v flatpak >/dev/null 2>&1; then
    echo "Flatpak not found. Installing..."

    if ! sudo apt install -y flatpak; then
        echo "flatpak failed" | tee -a "$log_file"
    fi
fi

# Add Flathub
if command -v flatpak >/dev/null 2>&1; then
    if ! flatpak remotes --columns=name 2>/dev/null | grep -qx 'flathub'; then
        echo "Adding Flathub..."
        if ! sudo flatpak remote-add --if-not-exists flathub \
            https://dl.flathub.org/repo/flathub.flatpakrepo; then
            echo "Flathub setup failed" | tee -a "$log_file"
        fi
    fi

    flatpaks=(
        "org.telegram.desktop"
        "com.discordapp.Discord"
        "md.obsidian.Obsidian"
    )

    for app in "${flatpaks[@]}"; do
        if flatpak info --system "$app" >/dev/null 2>&1; then
            echo "$app already installed."
        else
            echo "Installing $app..."
            if ! sudo flatpak install --system -y flathub "$app"; then
                echo "$app failed" | tee -a "$log_file"
            fi
        fi
    done
fi

if [[ -s "$log_file" ]]; then
    echo "Some packages failed. See $log_file"
else
    echo "All packages installed successfully."
fi
