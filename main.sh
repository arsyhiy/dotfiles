#!/bin/bash


PACKAGES(){

    # languages and utiliy to code 
    sudo python3 --version  || sudo dnf install -y python3
    sudo dnf install -y python3-venv # as i understand you can't check the version so it will just install 
    sudo dnf install -y pipx
    pipx ensurepath
    pipx install poetry
    sudo gcc --version || sudo apt dnf -y build-essential
    sudo clang --version || sudo dnf install -y clang
    sudo go verison || sudo dnf install -y golang
    sudo git --version || sudo dnf install -y git # and if it was installed like a directory?
    sudo rust --version || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . "$HOME/.cargo/env"
    sudo nodejs --version || curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - && sudo dnf install nodejs 
    
    # utiliy
    sudo unzip --version|| sudo apt dnf -y unzip
    sudo curl --version || sudo dnf install -y curl
    sudo neofetch --version || sudo dnf install -y neofetch
    sudo htop --version || sudo dnf install -y htop
    sudio ripgrep --version || sudo dnf install -y ripgrep
    
    # neovim 
    sudo dnf install -y nvim
    # installing nvim-lspconfig
    git clone --depth 1 https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig

    # docker section
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo dnf install docker-compose
    rm get-docker.sh

    # tmux 
    tmux --version || sudo dnf install -y tmux # actually  it doesn't view version of tmux 


    # setup git config 
    git config --global user.name "arsyhiy"
    git config --global user.email arsyhiy32@gmail.com


}


COPYMOVE(){
    printf "\n"
    printf "=======================================================================\n"
    printf "executing config.sh .\n"
    printf "=======================================================================\n"
    ./config.sh
}

ZSH(){
    printf "\n"
    printf "=======================================================================\n"
    printf "installing zsh .\n"
    printf "=======================================================================\n"

    # zsh and plugins
    sudo zsh --version || sudo dnf install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


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
            ZSH
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
            PACKAGES
            COPYMOVE
            ZSH
            break
        elif [ "$choice" == "no" ]; then
            printf "you will choice what to do\n"
             packages
             copymove
             zsh
            break
        else
            printf "type yes or no\n"
        fi

        done
}
driver # NOTE: это для запуска driver
