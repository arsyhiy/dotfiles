import os
import subprocess


dotfiles= """
     ______   _______  _______  _______  ___   ___      _______  _______ 
    |      | |       ||       ||       ||   | |   |    |       ||       |
    |  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|
    | | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ 
    | |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |
    |       ||       |  |   |  |   |    |   | |       ||   |___  _____| |
    |______| |_______|  |___|  |___|    |___| |_______||_______||_______|
                                                          made by arsyhiy
"""



def main():
    print(dotfiles)



def install_package():
    with open("src/linux/package.txt", "r") as f:
        packages = [line.strip() for  line in f  if line.strip()]
        f.close()

    for package in packages:
        try:
            subprocess.run(["sudo", "apt", "install", "-y", package], check=True)
            print(f" Установлен: {package}")
        except subprocess.CalledProcessError as e:
            print(f" Ошибка при установке {package}: {e}")
            
    return subprocess.CompletedProcess

def checksystem():
    if os.name == "posix": # linux
        # print and sleep 5 "installing goods for linux"
        install_package()
    elif os.name == "nt": # windows
        # print and sleep 5 "installing goods for windows"
        try:
            subprocess.run(
                ["powershell", "src/windows/./hello.ps1"], shell=True, check=True
            )
        except subprocess.CalledProcessError as err:
            print(err)  # need  a more informatic error message

    return subprocess.CompletedProcess



if __name__ == "__main__":
    main()
