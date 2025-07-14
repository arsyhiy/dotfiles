from sys import platform 
import os 
import subprocess

def os_check():
  if platform == 'win32':
    print("windows user huh?")
    subprocess.run(["powershell", "windows/./hello.ps1"], shell=True, check=True)
  elif platform == 'linux':
    print("i use arch btw")
  elif platform == 'darwin':
    print("are you rich man?")
    
os_check()


