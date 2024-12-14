#!/bin/bash -e

# this file is meant to check all needed app in debian based linux distribution

# Function to detect the OS and set the package manager
detect_os_and_set_package_manager() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                PKG_MANAGER="sudo apt-get update && sudo apt-get install -y"
                ;;
            fedora)
                PKG_MANAGER="sudo dnf install -y"
                ;;
            centos|rhel)
                PKG_MANAGER="sudo yum install -y"
                ;;
            arch)
                PKG_MANAGER="sudo pacman -Syu --noconfirm"
                ;;
            *)
                printf "%b\n" '\033[0;31mUnsupported OS: '"$ID"'\033[0m'
                exit 1
                ;;
        esac
    else
        printf "%b\n" '\033[0;31mOS detection failed. Please install curl, tar, and fontconfig manually.\033[0m'
        exit 1
    fi
}

# Function to check and install dependencies
install_dependencies() {
    if ! command -v curl >/dev/null 2>&1; then
        printf "%b\n" '\033[0;33mcurl not found. Installing curl...\033[0m'
        $PKG_MANAGER curl
    fi

    if ! command -v unzip >/dev/null 2>&1; then
        printf "%b\n" '\033[0;33munzip not found. Installing unzip...\033[0m'
        $PKG_MANAGER unzip
    fi

    if ! command -v fc-cache >/dev/null 2>&1; then
        printf "%b\n" '\033[0;33mfontconfig (fc-cache) not found. Installing fontconfig...\033[0m'
        $PKG_MANAGER fontconfig
    fi
}

# Detect OS and set package manager, and then check and install dependencies
detect_os_and_set_package_manager
install_dependencies


sudo python3 --version  || $PKG_MANAGER python3
$PKG_MANAGER python3-venv # as i understand you can't check the version so it will just install 
sudo htop --version || $PKG_MANAGER htop
sudo neofetch --version || $PKG_MANAGER neofetch
sudo firefox --version || $PKG_MANAGER firefox
sudo gcc --version || $PKG_MANAGER build-essential
sudo clang --version || $PKG_MANAGER clang
sudo git --version || $PKG_MANAGER git
sudo nodejs --version || $PKG_MANAGER nodejs
sudo go verison || $PKG_MANAGER golang
sudo curl --version || $PKG_MANAGER curl

# zsh section
sudo zsh --version || $PKG_MANAGER zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# neovim
nvim --version || curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage | \ 
    chmod u+x nvim.appimage |
    #to expose nvim globally:
	sudo mkdir -p /opt/nvim |
	sudo mv nvim.appimage /opt/nvim/nvim |
	echo "end of nvim installation!" # Added echo operator to check if the "or" operator 
					                 # failed to execute provided that nvim has a version

# installing nvim-lspconfig
git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig


# oh my zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


# docker section
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

