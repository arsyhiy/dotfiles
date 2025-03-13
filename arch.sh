#!/bin/bash


PACKAGES(){

    # languages and utiliy to code 
    sudo python3 --version  || sudo pacman -S python3
    sudo gcc --version || sudo pacman -S  build-essential
    sudo clang --version || sudo pacman -S clang
    sudo nodejs --version || sudo pacman -S nodejs
    sudo go verison || sudo pacman -S go
    sudo git --version || sudo pacman -S git # and if it was installed like a directory?


    # utiliy
    sudo unzip --version|| sudo pacman -S unzip
    sudo curl --version || sudo pacman -S curl
    sudo neofetch --version || sudo pacman -S neofetch
    sudo htop --version || sudo pacman -S htop


    # neovim
    sudo nvim --verision || sudo pacman -S neovim  
  
    # installing nvim-lspconfig
    git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig


    # zsh and plugins
    sudo zsh --version || sudo pacman -S zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


    # docker section
    #curl -fsSL https://get.docker.com -o get-docker.sh
    #sudo sh get-docker.sh
    sudo pacman -S docker-compose


    # tmux 
    tmux --version || sudo pacman -S tmux # actually  it doesn't view version of tmux 


    # setup git config 
    git config --global user.name "arsyhiy"
    git config --global user.email arsyhiy32@gmail.com
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
