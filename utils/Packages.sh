# this file is meant to check all needed app in debian based linux distribution

    # enter sudo to confirm root privileges
    sudo 

    # check updates before starting check other app
    sudo apt update

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
    nvim --version || curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage |
	    sudo chmod u+x nvim.appimage |
	    # To el status docker
xpose nvim globally:
	    sudo mkdir -p /opt/nvim |
	    sudo mv nvim.appimage /opt/nvim/nvim |
	    echo "end of nvim installation!" # Added echo operator to check if the "or" operator 
					                    # failed to execute provided that nvim has a version

    git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig

					 
    # oh my zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


    # docker section
    sudo docker --version || sudo apt install apt-transport-https ca-certificates curl software-properties-common -y | \

	    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	    sudo apt-key add -  | \
	    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
	    apt-cache policy docker-ce | \
	    sudo apt install docker-ce -y | \
	    sudo systemct
