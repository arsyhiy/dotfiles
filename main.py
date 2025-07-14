import os
import subprocess


def main():
    if os.name == "posix":
        # print and sleep 5 "installing goods for linux"
        try:
            subprocess.run(["src/linux/./main.sh"], shell=True, check=True)
        except subprocess.CalledProcessError as err:
            print(err)  # need  a more informatic error message
    elif os.name == "win32":
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
