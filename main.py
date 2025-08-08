import os
import subprocess


dotfiles = """
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

    while True:
        print("asking would you like install all this thing")
        a = input()  # get a normal name for variables
        if a == "y":
            print("answer is yes")
            if os.name == "posix":  # linux
                linux_install()
                break
            elif os.name == "nt":  # window
                windows_install()
                break
            else:
                print("somehow macos")

        elif a == "n":
            print("answer is no")
            print("exiting....")
            break
        else:
            print("type yes or no")


def linux_install():
    with open("src/linux/package.txt", "r") as f:
        packages = [line.strip() for line in f if line.strip()]
        f.close()

    for package in packages:
        try:
            subprocess.run(["sudo", "apt", "install", "-y", package], check=True)
            print(f" Установлен: {package}")
        except subprocess.CalledProcessError as e:
            print(f" Ошибка при установке {package}: {e}")

    return subprocess.CompletedProcess

def windows_install():
    pass


if __name__ == "__main__":
    main()
