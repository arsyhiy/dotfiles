!/bin/bash

PACKAGES(){

   # fonts
   # add there that script

   # languages and utiliy to code 

   ## python
   pipx --version || sudo apt install -y pipx
   pipx ensurepath
   sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
   poetry --version || pipx install poetry # for sudo poetry i get : command not found and 100% trying installing every time.
	
   ## git
   git --version || sudo apt install -y git # and if it was installed like a directory?

   gcc --version || sudo apt install -y build-essential
   cmake --version || sudo apt install -y cmake
    
   ## go
   sudo go ||  wget https://git.io/go-installer.sh && bash go-installer.sh	       
	
   node --version || sudo apt install -y nodejs npm
 
   ## tmux
   tmux --version || sudo apt install -y tmux
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   bear --version || sudo apt install -y bear
    
   ## utiliy
   unzip --version || sudo apt install -y unzip # like go do the second thing even if first = true.
   curl --version || sudo apt install -y curl

   # i need find analogue to neofetch.
   # sudo neofetch --version || sudo pacman -S --noconfirm neofetch

   htop --version || sudo apt install -y htop
   ripgrep  --version || sudo apt install -y ripgrep
   fzf --version || sudo apt install -y fzf
   lazygit --version || sudo apt install -y lazygit
    
   # flatpak apps
   flatpak install flathub org.telegram.desktop
   flatpak install flathub com.discordapp.Discord
   flatpak install flathub md.obsidian.Obsidian
   flatpak install flathub org.torproject.torbrowser-launcher

   # neovim
   nvim --version || sudo apt install -y neovim
   git clone https://github.com/arsyhiy/nvim.git ~/.config/nvim # it will not cloning if if directory already there. so it will cost not much.

   # emacs
   emacs --version || sudo apt install -y emascs
	
   # setup git config 
   git config --global user.name "arsyhiy"
   git config --global user.email arsyhiy32@gmail.com

   # ssh
   ssh --version || sudo apt install -y openssh-server

   # disc drive
   wodim --version || sudo apt install -y wodim
   alsa-utils --version || sudo apt install -y alsa-utils
   mpv --version || sudo apt install -y mpv 
   pipewire --version || sudo apt install -y pipewire
   pipewire-alsa --version || sudo apt install -y pipewire-alsa
   pipewire-pulse --version || sudo apt install -y pipewire-pulse
   wireplumber --version || sudo apt install -y wireplumber
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
    sudo apt install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
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
            break
        elif [ "$choice" == "n" ]; then
            printf "you will choice what to do\n"
             packages
             copymove
             zsh
             break
        else
            printf "type y or n\n"
        fi

        done
}
driver # NOTE: это для запуска driver

