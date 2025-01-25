#!/bin/bash


PACKAGES(){

    # languages and utiliy to code 
    sudo python3 --version  || sudo apt install python3
    sudo apt install python3-venv # as i understand you can't check the version so it will just install 
    sudo gcc --version || sudo apt install build-essential
    sudo clang --version || sudo apt install clang
    sudo nodejs --version || sudo apt install nodejs
    sudo go verison || sudo apt install golang
    sudo git --version || sudo apt install git # and if it was installed like a directory?


    # utiliy
    sudo unzip --version|| sudo apt install unzip
    sudo curl --version || sudo apt install curl
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
    sudo apt install docker-compose


    # tmux 
    tmux --version || sudo apt install tmux # actually  it doesn't view version of tmux 


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
