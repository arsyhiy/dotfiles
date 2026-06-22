#!/usr/bin/env bash

# all packages with the same name as you use
packages=(
	nodejs
	npm
)

# all packages with not the same name as you use
declare -A exceptions=(
	["ssh"]="openssh-server"
)

log_file="packages.log"
> "$log_file"

for pkg in "${packages[@]}"; do
	if rpm -q "$pkg" >/dev/null 2>&1; then
		echo "$pkg already installed."
	else
		echo "installing $pkg..."

		if sudo dnf install -y "$pkg"; then
			echo "$pkg installed successfully."
		else
			echo "$pkg failed" | tee -a "$log_file"
		fi
	fi
done

for bin in "${!exceptions[@]}"; do
	pkg="${exceptions[$bin]}"

	if command -v "$bin" >/dev/null 2>&1; then
		echo "$bin already present"
	else
		echo "Installing $pkg (for $bin)..."

		if sudo dnf install -y "$pkg"; then
			echo "$pkg installed"
		else
			echo "$pkg failed" | tee -a "$log_file"
		fi
	fi
done



# NOTE: единственная реальная проблема  это медленная скачивание.
if ! command -v flatpak >/dev/null 2>&1; then
	echo "Flatpak not found. Installing..."
	sudo dnf install -y flatpak
fi

if ! flatpak remote-list | grep -q flathub; then
	echo "Adding Flathub..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

flatpaks=(
	"org.telegram.desktop"
	"com.discordapp.Discord"
	"md.obsidian.Obsidian"
)

for app in "${flatpaks[@]}"; do
	if flatpak info "$app" >/dev/null 2>&1; then
		echo "$app already installed."
	else
		echo "installing $app..."
		flatpak install -y flathub "$app"
	fi
done


if [[ -s "$log_file" ]]; then
	echo "Some packages failed. See $log_file"
else
	echo "All packages installed successfully."
fi
