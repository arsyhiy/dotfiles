#!/bin/bash

NERDFONTSINSTALLER(){
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
            sudo apt install fontconfig
        fi
    }

    # Detect OS and set package manager, and then check and install dependencies
    detect_os_and_set_package_manager
    install_dependencies

    # Create directory for fonts
    mkdir -p "$HOME/.local/share/fonts"

    # Create tmp directory if it doesn't exist
    mkdir -p "$HOME/tmp"

    # List of available fonts using release page names
    fonts=(
    "0xProto"
    "3270"
    "Agave"
    "AnonymousPro"
    "Arimo"
    "AurulentSansMono"
    "BigBlueTerminal"
    "BitstreamVeraSansMono"
    "CascadiaCode"
    "CascadiaMono"
    "CodeNewRoman"
    "ComicShannsMono"
    "CommitMono"
    "Cousine"
    "D2Coding"
    "DaddyTimeMono"
    "DejaVuSansMono"
    "DroidSansMono"
    "FantasqueSansMono"
    "FiraCode"
    "FiraMono"
    "GeistMono"
    "Go-Mono"
    "Gohu"
    "Hack"
    "Hasklig"
    "Hermit"
    "iA-Writer"
    "IBMPlexMono"
    "Inconsolata"
    "InconsolataGo"
    "InconsolataLGC"
    "IntelOneMono"
    "Iosevka"
    "IosevkaTerm"
    "IosevkaTermSlab"
    "JetBrainsMono"
    "Lekton"
    "LiberationMono"
    "Lilex"
    "MartianMono"
    "Meslo"
    "Monaspace"
    "Monofur"
    "Monoid"
    "Mononoki"
    "MPlus"
    "NerdFontsSymbolsOnly"
    "Noto"
    "OpenDyslexic"
    "Overpass"
    "ProFont"
    "ProggyClean"
    "Recursive"
    "RobotoMono"
    "ShareTechMono"
    "SourceCodePro"
    "SpaceMono"
    "Terminus"
    "Tinos"
    "Ubuntu"
    "UbuntuMono"
    "UbuntuSans"
    "VictorMono"
    "ZedMono"
    )

    # Display menu of available fonts in multiple columns based on terminal width
    print_fonts_in_columns() {
        cols=$(tput cols)
        items_per_col=20
        total_fonts=${#fonts[@]}
        columns=$((total_fonts / items_per_col))
        if ((total_fonts % items_per_col != 0)); then
            columns=$((columns + 1))
        fi

        for ((i=0; i<items_per_col; i++)); do
            for ((j=0; j<columns; j++)); do
                idx=$((i + j * items_per_col))
                if ((idx < total_fonts)); then
                    printf "%-30s" "$((idx + 1)). ${fonts[idx]}"
                fi
            done
            echo
        done
    }

    # Display the font list
    printf "%b\n" '\033[0;32mSelect fonts to install (separate with spaces, or enter "all" to install all fonts):\033[0m'
    printf "%b\n" "---------------------------------------------"
    print_fonts_in_columns
    printf "%b\n" "---------------------------------------------"

    # Prompt user to select fonts and validate input
    while true; do
        printf "%b\n" '\033[0;36mEnter the numbers of the fonts to install (e.g., "1 2 3") or type "all" to install all fonts: \033[0m'
        read -r font_selection

        # Check if user selected "all"
        if [ "$font_selection" == "all" ]; then
            selected_fonts=("${fonts[@]}")  # Set all fonts
            break
        elif [ -n "$font_selection" ]; then
            selected_fonts=()
            for selection in $font_selection; do
                font_index=$((selection - 1))  # Adjust for zero-based indexing
                if ((font_index >= 0 && font_index < total_fonts)); then
                    selected_fonts+=("${fonts[font_index]}")
                else
                    printf "%b\n" '\033[0;31mInvalid selection: '"$selection"'\033[0m'
                    continue 2
                fi
            done
            break  # Exit loop if input is valid
        else
            printf "%b\n" '\033[0;31mPlease select at least one font.\033[0m'
        fi
    done

    # Download and install selected fonts
    for font in "${selected_fonts[@]}"; do
        printf "%b\n" '\033[0;34mDownloading and installing '"$font"'\033[0m'
        font_name=$(printf "%b\n" "$font" | awk '{print $1}')
        curl -sSLo "$HOME/tmp/$font_name.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
        unzip -o "$HOME/tmp/$font_name.zip" -d "$HOME/.local/share/fonts"
        rm "$HOME/tmp/$font_name.zip"
    done

    # Update font cache
    fc-cache -vf
    
}

ZSHINSTALL(){
    sudo zsh --version || sudo apt install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

PACKAGES(){
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
}

COPYMOVE(){
    printf "\n"
    printf "=======================================================================\n"
    printf "moving neovim.\n"
    printf "=======================================================================\n"
    cp -rv nvim/init.lua ~/.config/nvim/
    cp -rv nvim/lua ~/.config/nvim

    printf "=======================================================================\n"
    printf "moving .tmux.conf .zshrc\n"
    printf "=======================================================================\n"
    cp -rv .tmux.conf ~/
    cp -rv .zshrc ~/


}

packages(){
    while true; do
        printf "install necessary packages? (e.g yes or no ):"
        read -r choice

        if [ "$choice" == "yes" ]; then
            PACKAGES
            break
        elif [ "$choice" == "no" ]; then


            printf "installing packages is canceled\n"
            break
        else
            printf "type yes or no\n"
        fi


    done
}

fonts(){
    while true; do 
        printf "install Fonts ? (e.g yes or no ):"
        read -r choice

            if [ "$choice" == "yes" ]; then
                NERDFONTSINSTALLER
            break
        elif [ "$choice" == "no" ]; then
            printf "installing fonts is canceled\n"
            break
        else
            printf "type yes or no\n"
        fi

    done
}

copymove(){
        while true; do 
            printf "move all necessary files? (e.g yes or no ):"
            read -r choice

                if [ "$choice" == "yes" ]; then
                    COPYMOVE
                break
            elif [ "$choice" == "no" ]; then
                printf "installing fonts is canceled\n"
                break
            else
                printf "type yes or no\n"
            fi

        done
}

zsh(){
    while true; do 
        printf "would you like to install zsh? (e.g yes or no ):"
        read -r choice

        if [ "$choice" == "yes" ]; then
            ZSHINSTALL
            break
        elif [ "$choice" == "no" ]; then
            printf "installing zsh is canceled\n"
            break
        else
            printf "type yes or no\n"
        fi

    done

}


clear
cat <<'.'
 ______   _______  _______  _______  ___   ___      _______  _______ 
|      | |       ||       ||       ||   | |   |    |       ||       |
|  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|
| | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ 
| |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |
|       ||       |  |   |  |   |    |   | |       ||   |___  _____| |
|______| |_______|  |___|  |___|    |___| |_______||_______||_______|
.
printf "                                                      made by arsyhiy\n"
printf "\n"
printf "=======================================================================\n"






# driver 
driver (){
    while true;do 
        printf "would you like to do all scrpits? (e.g yes or no):"
        read -r choice

        if [ "$choice" == "yes" ]; then
            source utils/Packages.sh
            source utils/NerdFontsInstaller.sh
            source utils/CopyMove.sh 
            break
        elif [ "$choice" == "no" ]; then
            printf "you will choice what to do\n"
             packages
             fonts
             copymove

            break
        else
            printf "type yes or no\n"
        fi

        done
}
driver
