#!/bin/bash


PACKAGES(){

    # languages and utiliy to code 
    sudo python3 --version  || sudo apt-get install -y python3
    sudo apt install -y python3-venv # as i understand you can't check the version so it will just install 
    sudo pipx --version || sudo apt-get install -y pipx \ pipx ensurepath
    sudo poetry --version || pipx install poetry
    sudo gcc --version || sudo apt-get install -y build-essential
    sudo clang --version || sudo apt-get install -y clang
    sudo go verison || sudo apt-get install -y golang
    sudo git --version || sudo apt-get install -y git # and if it was installed like a directory?
    sudo gh --version || sudo apt-get install -y gh
    sudo rustc --version || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh \
        . "$HOME/.cargo/env" # redo the rust installation
    sudo node --version || curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - && sudo apt install nodejs 
    docker --version || curl -fsSL https://get.docker.com -o get-docker.sh \ 
        sudo sh get-docker.sh \ 
        sudo apt-get install docker-compose \ 
        rm get-docker.sh
    tmux -V || sudo apt install-get -y tmux 
    sudo bear --version || sudo apt-get install -y bear
    
    # utiliy
    sudo unzip --version|| sudo apt-get install -y unzip
    sudo curl --version || sudo apt-get install -y curl
    sudo neofetch --version || sudo apt-get install -y neofetch
    sudo htop --version || sudo apt-get install -y htop
    sudo ripgrep --version || sudo apt-ge install -y ripgrep
    
    # snap apps
    # sudo snap --version || sudo apt-get install snapd
    #sudo snap --version || sudo apt-get install snapd # make sure you have snapd
    #sudo snap install telegram-desktop
    #sudo snap install anki-desktop
    #sudo snap install obsidian --classic
    # the reason why i use snap instead of flatpak is because its slow
	
    # steam
    #sudo apt-get install steam
    # don't forget to read https://ubuntu.com/blog/linux-gaming-with-ubuntu-desktop-steam-and-proton
    
    # retroarch
    #sudo snap install retroarch
    #sudo snap connect retroarch:removable-media
    
    # flatpak apps
    #flatpak install pcsx2 # the only app that can be install by flatpak
    
    # setup git config 
    git config --global user.name "arsyhiy"
    git config --global user.email arsyhiy32@gmail.com

    # krita
    #sudo apt-get install krita

    #ssh
    sshd -V || sudo apt-get install -y openssh-server
}


COPYMOVE(){
    printf "\n"
    printf "=======================================================================\n"
    printf "executing config.sh .\n"
    printf "=======================================================================\n"
    chmod +x config.sh
    ./config.sh
}

ZSH(){
    printf "\n"
    printf "=======================================================================\n"
    printf "installing zsh .\n"
    printf "=======================================================================\n"

    # zsh and plugins
    sudo zsh --version || sudo apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


}


FONTS(){
    printf "\n"
    printf "=======================================================================\n"
    printf "executting fonts .\n"
    printf "=======================================================================\n"
    chmod +x font.sh
    ./font.sh
}



I3(){
    printf "\n"
    printf "=======================================================================\n"
    printf "installing i3 .\n"
    printf "=======================================================================\n"
    sudo i3 --version || sudo apt-get install -y i3
    sudo pavucontrol --version || sudo apt-get install -y pavucontrol
    sudo rofi -version || sudo apt-get install -y rofi
}

NEOVIM(){
    printf "\n"
    printf "=======================================================================\n"
    printf "installing neovim .\n"
    printf "=======================================================================\n"
    sudo ninja --version || sudo apt-get install ninja-build  
    sudo gettext --version || sudo apt-get install gettext 
    sudo cmake --version || sudo apt-get install cmake 
    sudo unzip -v || sudo apt-get install unzip
    sudo curl --version || sudo apt-get install curl
    nvim --version ||  cd | git clone https://github.com/neovim/neovim | cd neovim make CMAKE_BUILD_TYPE=Realease | sudo make install |cd ~/dotfiles
    git clone --depth 1 https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig 
    git clone https://github.com/arsyhiy/nvim.git ~/.config/nvim 
}


packages(){
    while true; do
        printf "install necessary packages? (e.g y - yes or n - no ):"
        read -r choice

        if [ "$choice" == "y" ]; then
            PACKAGES
            break
        elif [ "$choice" == "n" ]; then
            printf "installing packages is canceled\n"
            break
        else
            printf "type y or n\n"
        fi

    done
}


copymove(){
        while true; do 
            printf "move all necessary files? (e.g y - yes or n - no ):"
            read -r choice

                if [ "$choice" == "y" ]; then
                    COPYMOVE
                break
            elif [ "$choice" == "n" ]; then
                printf "installing fonts is canceled\n"
                break
            else
                printf "type y or n\n"
            fi

        done
}


zsh(){
    while true; do 
        printf "would you like to install zsh? (e.g y - yes or n - no ):"
        read -r choice

        if [ "$choice" == "y" ]; then
            ZSH
            break
        elif [ "$choice" == "n" ]; then
            printf "installing zsh is canceled\n"
            break
        else
            printf "type y or n\n"
        fi

    done

}

fonts(){
    while true; do 
        printf "would you like to install fonts? (e.g y - yes or n - no ):"
        read -r choice

        if [ "$choice" == "y" ]; then
            FONTS
            break
        elif [ "$choice" == "n" ]; then
            printf "installing fonts is canceled\n"
            break
        else
            printf "type y or n \n"
        fi

    done

}

neovim(){
    while true; do
        printf "install neovim? (e.g y - yes or n - no ):"
        read -r choice

        if [ "$choice" == "y" ]; then
            NEOVIM
            break
        elif [ "$choice" == "n" ]; then
            printf "installing neovim is canceled\n"
            break
        else
            printf "type y or n\n"
        fi

    done
}

i3(){
    while true; do
        printf "install i3? (e.g y - yes or n - no ):"
        read -r choice

        if [ "$choice" == "y" ]; then
            I3
            break
        elif [ "$choice" == "n" ]; then
            printf "installing i3 is canceled\n" 
            break
        else
            printf "type y or n\n"
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
        printf "would you like to do all scrpits? (e.g y - yes or n - no):"
        read -r choice

        if [ "$choice" == "y" ]; then
            PACKAGES
            COPYMOVE
            ZSH
            FONTS
            NEOVIM
            I3
            break
        elif [ "$choice" == "n" ]; then
            printf "you will choice what to do\n"
             packages
             copymove
             zsh
             fonts
             neovim
             i3
            break
        else
            printf "type y or n\n"
        fi

        done
}
driver # NOTE: это для запуска driver
