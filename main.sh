#!/bin/bash
packages(){
    while true; do
        printf "install necessary packages? (e.g yes or no )\n"
        read -r choice

        if [ "$choice" == "yes" ]; then
            source utils.packages.sh
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
        printf "install Fonts ? (e.g yes or no )\n"
        read -r choice

            if [ "$choice" == "yes" ]; then
            source utils/nerdfonts_installer.sh 
            break
        elif [ "$choice" == "no" ]; then
            printf "installing fonts is canceled\n"
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

    packages
    
    fonts

}
driver
