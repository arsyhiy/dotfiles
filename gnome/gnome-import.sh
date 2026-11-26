#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INPUT="${SCRIPT_DIR}/gnome.dconf"

if ! command -v dconf >/dev/null 2>&1; then
    echo "Error: dconf is not installed." >&2
    exit 1
fi

if [[ ! -f "$INPUT" ]]; then
    echo "Error: $INPUT not found." >&2
    exit 1
fi

BACKUP="${SCRIPT_DIR}/gnome-backup-$(date +%Y%m%d-%H%M%S).dconf"

dconf dump /org/gnome/ > "$BACKUP"

dconf load /org/gnome/ < "$INPUT"

echo "GNOME settings restored from: $INPUT"
echo "Previous settings backed up to: $BACKUP"
