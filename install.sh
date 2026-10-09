#!/usr/bin/env bash

packages=(
  	stow
    vim 
    tmux
    fzf
    curl
    unzip
    lazygit
)

log_file="packages.log"
> "$log_file"

for pkg in "${packages[@]}"; do
	if rpm -q "$pkg" >/dev/null 2>&1; then
		echo "$pkg already installed."
	else
		echo "installing $pkg..."

		if sudo apt install -y "$pkg"; then
			echo "$pkg installed successfully."
		else
			echo "$pkg failed" | tee -a "$log_file"
		fi
	fi
done

if [[ -s "$log_file" ]]; then
	echo "Some packages failed. See $log_file"
else
	echo "All packages installed successfully."
fi
