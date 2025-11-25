#!/bin/bash

PACKAGES(){

	# fonts
    sudo pacman -Q ttf-jetbrains-mono-nerd || sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd     
    sudo pacman -Q noto-fonts || sudo pacman -S --noconfirm noto-fonts
    sudo pacman -Q noto-fonts-emoji || sudo pacman -S --noconfirm noto-fonts-emoji
    sudo pacman -Q ttf-linux-libertine || sudo pacman -S --noconfirm ttf-linux-libertine
    sudo pacman -Q noto-fonts-cjk || sudo pacman -S --noconfirm noto-fonts-cjk

    # languages and utiliy to code 

    # python
    sudo pipx || sudo pacman -S --noconfirm python-pipx \ pipx ensurepath # you can't check pipx with pacman -Q
    poetry --version || pipx install poetry # for sudo poetry i get : command not found and 100% trying installing every time.
	
    # git
	sudo pacman -Q git || sudo pacman -S --noconfirm git # and if it was installed like a directory?
	sudo pacman -Q gh || sudo pacman -S --noconfirm github-cli

    sudo pacman -Q clang || sudo pacman -S --noconfirm clang
    sudo pacman -Q cmake || sudo pacman -S --noconfirm cmake
    
    sudo go || sudo pacman -S --noconfirm go # like with poetry. NOTE: i can't find the way not to do second after || comand.
	                                         # if go = True it will do the second thing 
	
    sudo pacman -Q cargo || sudo pacman -S --noconfirm rust
    sudo pacman -Q node || sudo pacman -S --noconfirm nodejs 
    sudo pacman -Q elixir || sudo pacman -S --noconfirm elixir 
    sudo pacman -Q erlang || sudo pacman -S --noconfirm erlang 

    # tmux
    sudo pacman -Q tmux || sudo pacman -S --noconfirm tmux 
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    sudo pacman -Q bear || sudo pacman -S --noconfirm bear
    
    # utiliy
    sudo pacman -Q unzip || sudo pacman -S --noconfirm unzip # like go do the second thing even if first = true.
    sudo pacman -Q curl || sudo pacman -S --noconfirm curl
    bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

    # i need find analogue to neofetch.
    #sudo neofetch --version || sudo pacman -S --noconfirm neofetch

    sudo pacman -Q htop || sudo pacman -S --noconfirm htop
    sudo pacman -Q ripgrep || sudo pacman -S --noconfirm ripgrep
    sudo pacman -S fzf
    sudo pacman -S lazygit
    
    # flatpak apps
    #flatpak install pcsx2 # the only app that can be install by flatpak
    flatpak install flathub org.telegram.desktop
    # we need to add anki installation
    # we need to uncomment /etc/pacman.d/mirrorlist read https://www.reddit.com/r/linux_gaming/comments/s9vfsk/installing_steam_on_arch/


    # neovim
    sudo pacman -Q nvim || sudo pacman -S --noconfirm neovim
    git clone https://github.com/arsyhiy/nvim.git ~/.config/nvim # it will not cloning if if directory already there. so it will cost not much.
    sudo pacman -Q neovide || sudo pacman -S --noconfirm neovide 
	
    # setup git config 
    git config --global user.name "arsyhiy"
    git config --global user.email arsyhiy32@gmail.com

    #ssh
    sudo pacman -Q sshd || sudo pacman -S --noconfirm openssh-server

    # archlinux hyprland utilites
    sudo pacman -Q brightnessctl || sudo pacman -S --noconfirm brightnessctl
    sudo pacman -Q pamixer || sudo pacman -S --noconfirm pamixer
    sudo pacman -Q npm || sudo pacman -S --noconfirm npm
    sudo pacman -Q hyprlock || sudo pacman -S --noconfirm hyprlock
    sudo pacman -Q hyprpaper || sudo pacman -S --noconfirm hyprpaper
    sudo pacman -Q hypridle || sudo pacman -S --noconfirm hypridle
    sudo pacman -Q wlogout || sudo pacman -S --noconfirm wlogout
    sudo pacman -Q swaync || sudo pacman -S --noconfirm swaync
    sudo pacman -Q yay || sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    sudo pacman -Q waybar || sudo pacman -S --noconfirm waybar
    go install go.senan.xyz/cliphist@latest
    sudo yay -S rofi-bluetooth-git
    
    # bluetooth
    sudo pacman -Q bluez || sudo pacman -S --noconfirm bluez
    sudo pacman -Q  bluez-utils || sudo pacman -S --noconfirm bluez-utils
    sudo pacman -Q blueman || sudo pacman -S --noconfirm blueman
    systemctl start bluetooth.service # maybe we need to check first

    # terminal
    sudo pacman -Q ghostty || sudo pacman -S --noconfirm ghostty
    


    # tor
    yay -S  torbrowser-launcher
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
    sudo pacman -Q zsh || sudo pacman -S --noconfirm -y zsh
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
