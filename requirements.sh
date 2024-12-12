# this file is meant to check all needed app in debian based linux distribution

# enter sudo to confirm root privileges
sudo 

# check updates before starting check other app
#sudo apt update

sudo python3 --version  || sudo apt install python3
sudo htop --version || sudo apt install htop
sudo neofetch --version || sudo apt install neofetch
sudo firefox --version || sudo apt install firefox
sudo gcc --version || sudo apt install build-essential
sudo git --version || sudo apt install git
