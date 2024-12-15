#!/bin/bash
packages(){
    while true; do
        printf "install necessary packages? (e.g yes or no ):"
        read -r choice

        if [ "$choice" == "yes" ]; then
            source utils/Packages.sh
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
            source utils/NerdFontsInstaller.sh 
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
                source utils/CopyMove.sh 
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
            source utils/ZshInstall.sh 
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
