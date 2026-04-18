#!/usr/bin/bash

# all packages with the same name as you use
packages=(
	cmake
	nodejs
	npm
	tmux
	vim
	htop
	unzip
	curl
  gdb
)

# all packages with not the same name as you use
declare -A exceptions=(
	["ssh"]="openssh-server"
	["gcc"]="build-essential"
)

log_file="packages.log"
>"$log_file"

for pkg in "${packages[@]}"; do
	if dpkg -s "$pkg" >/dev/null 2>&1; then
		echo "$pkg all ready installed."
	else
		echo "installing $pkg..."
		if sudo apt install -y "$pkg"; then
			echo "$pkg installed with success."
		else
			echo "$pkg cannot install it. write to log."
			echo "$pkg" >>"$log_file"
		fi
	fi
done

for bin in "${!exceptions[@]}"; do
	pkg="${exceptions[$bin]}"

	if command -v "$bin" >/dev/null 2>&1; then
		echo "$bin allready present"
	else
		echo "Installing $pkg (for $bin)..."
		if sudo apt install -y "$pkg"; then
			echo "$pkg installed"
		else
			echo "$pkg failed"
			echo "$pkg" >>"$log_file"
		fi
	fi
done

# Flatpak apps
flatpaks=(
	"org.telegram.desktop"
	"com.discordapp.Discord"
	"md.obsidian.Obsidian"
)

for app in "${flatpaks[@]}"; do
	if flatpak list | grep -q "$app"; then
		echo "$app allready installed."
	else
		echo "installing $app..."
		flatpak install -y flathub "$app"
	fi
done

if [ -s "$log_file" ]; then
	echo "cannot install specific packages. write in to $log_file . read for more information"
fi
