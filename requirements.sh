# this file is meant to check all needed app in debian based linux distribution

# enter sudo to confirm root privileges
sudo 

# check updates before starting check other app
#sudo apt update

sudo python3 --version  || sudo apt install python3
sudo apt install python3-venv # as i understand you can't check the version so it will just install 
sudo htop --version || sudo apt install htop
sudo neofetch --version || sudo apt install neofetch
sudo firefox --version || sudo apt install firefox
sudo gcc --version || sudo apt install build-essential
sudo clang --version || sudo apt install clang
sudo git --version || sudo apt install git
sudo nodejs --version || sudo apt install nodejs
