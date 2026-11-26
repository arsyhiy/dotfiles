#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="${SCRIPT_DIR}/gnome.dconf"

if ! command -v dconf >/dev/null 2>&1; then
    echo "Error: dconf is not installed." >&2
    exit 1
fi

dconf dump /org/gnome/ > "$OUTPUT"

echo "GNOME settings exported to: $OUTPUT"
