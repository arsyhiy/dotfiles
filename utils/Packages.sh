# this file is meant to check all needed app in debian based linux distribution


# Function to check and install dependencies
install_dependencies() {
    if ! command -v curl >/dev/null 2>&1; then
        printf "%b\n" '\033[0;33mcurl not found. Installing curl...\033[0m'
        sudo apt install curl
    fi

    if ! command -v unzip >/dev/null 2>&1; then
        printf "%b\n" '\033[0;33munzip not found. Installing unzip...\033[0m'
        sudo apt install unzip
    fi

    if ! command -v fc-cache >/dev/null 2>&1; then
        printf "%b\n" '\033[0;33mfontconfig (fc-cache) not found. Installing fontconfig...\033[0m'
        sudo apt install  fontconfig
    fi
}


# Detect OS and set package manager, and then check and install dependencies
detect_os_and_set_package_manager
install_dependencies

# languages and utiliy to code 
sudo python3 --version  || sudo apt install python3
 sudo apt install python3-venv # as i understand you can't check the version so it will just install 
sudo gcc --version || sudo apt install build-essential
sudo clang --version || sudo apt install clang
sudo nodejs --version || sudo apt install nodejs
sudo go verison || sudo apt install golang

# apps
sudo firefox --version || sudo apt install firefox

# utiliy
sudo curl --version || sudo apt install curl
sudo git --version || sudo apt install git
sudo neofetch --version || sudo apt install neofetch
sudo htop --version || sudo apt install htop

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


# zsh and plugins
sudo zsh --version || sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions



# docker section
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# tmux 
tmux --version || sudo apt install tmux # actually  it doesn't view version of tmux 
