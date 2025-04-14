#!/bin/bash


PACKAGES(){

    # languages and utiliy to code 
    sudo python3 --version  || sudo apt install -y python3
    sudo apt install -y python3-venv # as i understand you can't check the version so it will just install 
    sudo apt install -y pipx
    pipx ensurepath
    pipx install poetry
    sudo gcc --version || sudo apt install -y build-essential
    sudo clang --version || sudo apt install -y clang
    sudo go verison || sudo apt install -y golang
    sudo git --version || sudo apt install -y git # and if it was installed like a directory?
    sudo rust --version || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . "$HOME/.cargo/env"
    sudo nodejs --version || curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - && sudo apt-get install nodejs 
    
    # utiliy
    sudo unzip --version|| sudo apt install -y unzip
    sudo curl --version || sudo apt install -y curl
    sudo neofetch --version || sudo apt install -y neofetch
    sudo htop --version || sudo apt install -y htop
    sudio ripgrep --version || sudo apt install -y ripgrep
    
    # neovim 
    sudo apt-get install -y ninja-build gettext cmake curl build-essential
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git switch release-0.11  
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd ~/dotfiles/

    # installing nvim-lspconfig
    git clone --depth 1 https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig



    # docker section
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo apt install docker-compose


    # tmux 
    tmux --version || sudo apt install -y tmux # actually  it doesn't view version of tmux 


    # setup git config 
    git config --global user.name "arsyhiy"
    git config --global user.email arsyhiy32@gmail.com

    # zsh and plugins
    sudo zsh --version || sudo apt install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


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
            PACKAGES
            COPYMOVE
            break
        elif [ "$choice" == "no" ]; then
            printf "you will choice what to do\n"
             packages
             copymove
            break
        else
            printf "type yes or no\n"
        fi

        done
}
driver # NOTE: это для запуска driver
