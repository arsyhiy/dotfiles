``` bash

# cloning_configs.sh: cloning configs for programs from github with executing dependency.sh in them

#!/usr/bin/env bash

echo "FIXME: это прототип так что не расчитывай правильную работоспособность."

set -e

clone_and_install() {
    local repo="$1"
    local target="$2"

    echo "Клонирую $repo ..."
    git clone "$repo" "$target"

    if [[ -f "$target/dependency.sh" ]]; then
        echo "Найден dependency.sh, выполняю..."
        chmod +x "$target/dependency.sh"
        "$target/dependency.sh"
    else
        echo "dependency.sh не найден"
    fi
}

# neovim
clone_and_install \
    "https://github.com/arsyhiy/nvim.git" \
    "$HOME/.config/nvim"

# emacs
clone_and_install \
    "https://github.com/arsyhiy/.emacs.d.git" \
    "$HOME/.emacs.d"

# hypr
clone_and_install \
    "https://github.com/arsyhiy/hypr.git" \
    "$HOME/.config/hypr"

# wofi
clone_and_install \
    "https://github.com/arsyhiy/wofi.git" \
    "$HOME/.config/wofi"

# wlogout
clone_and_install \
    "https://github.com/arsyhiy/wlogout.git" \
    "$HOME/.config/wlogout"

# waybar

```

```  bash
# config.sh: copying config from the ENV

#!/usr/bin/env bash

./cloning_configs.sh

dry_run="0"
DEV_ENV="$HOME/dotfiles"
if [ -z "$XDG_CONFIG_HOME" ]; then
    echo "no xdg config hom"
    echo "using ~/.config"
    XDG_CONFIG_HOME=$HOME/.config
fi

if [ -z "$DEV_ENV" ]; then
    echo "env var DEV_ENV needs to be present"
    exit 1
fi

if [[ $1 == "--dry" ]]; then
    dry_run="1"
fi

log() {
    if [[ $dry_run == "1" ]]; then
        echo "[DRY_RUN]: $1"
    else
        echo "$1"
    fi
}

log "env: $DEV_ENV"

update_files() {
    log "copying over files from: $1"
    pushd $1 &> /dev/null
    (
        configs=`find . -mindepth 1 -maxdepth 1 -type d`
        for c in $configs; do
            directory=${2%/}/${c#./}
            log "    removing: rm -rf $directory"

            if [[ $dry_run == "0" ]]; then
                rm -rf $directory
            fi

            log "    copying env: cp $c $2"
            if [[ $dry_run == "0" ]]; then
                cp -r ./$c $2
            fi
```

