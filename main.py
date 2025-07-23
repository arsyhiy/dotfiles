import os
import subprocess

def main():
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



if __name__ == "__main__":
    main()
