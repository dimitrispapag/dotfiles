#!/bin/bash

echo "Backing up existing configurations..."

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

CONFIGS=(
    ".bashrc"
    ".bash_profile" 
    ".zshrc"
    ".vimrc"
    ".gitconfig"
    ".config/i3"
    ".config/alacritty"
    ".config/polybar"
    ".config/rofi"
    ".config/dunst"
    ".config/picom"
    ".config/kitty"
    ".config/fontconfig"
    ".local/bin"
)

for config in "${CONFIGS[@]}"; do
    if [[ -e "$HOME/$config" ]]; then
        echo "Backing up $config"
        mkdir -p "$BACKUP_DIR/$(dirname "$config")"
        cp -r "$HOME/$config" "$BACKUP_DIR/$config"
    fi
done

echo "Backup completed in: $BACKUP_DIR"
