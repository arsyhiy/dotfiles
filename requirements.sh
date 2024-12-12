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
sudo go verison || sudo apt install golang
sudo curl --version || sudo apt install curl

# zsh section
sudo zsh --version || sudo apt zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo chmod u+x nvim.appimage

# To expose nvim globally:
sudo mkdir -p /opt/nvim
sudo mv nvim.appimage /opt/nvim/nvim


