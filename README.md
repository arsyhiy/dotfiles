# This repository is intended for minimal setup of my workspace
# NOTE: all the instructions were written for the future me
before the start to clone this repo you need git
```bash 
sudo apt install git 
```

```bash
git clone --recurse-submodules https://github.com/arsyhiy/dotfiles.git
```

## installation:
### main.sh 
```bash 
sudo apt install docker-compose #paste to make it executable and
./main.sh" #to run it
```
### docker 
```bash 
docker compose up -d # to run in background 
```

# главная цель этого репо:
написан он специально raspberry pi как мой домашний сервер и как средство работы на линуксе 


# future ideas
- adding pipx
- adding poetry
- refactor installing packages into : sudo apt install -y
- movin zsh section into the end
- refactor nvim section. reason : AppImages require FUSE to run.
- update nodejs section to install latest version
