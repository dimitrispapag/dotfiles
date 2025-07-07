#!/bin/bash
# Enhanced dotfiles sync script

cd ~/dotfiles

echo "=== Syncing dotfiles ==="

# Define what files to sync
DOTFILES=(
    ".bashrc"
    ".bash_profile"
    ".zshrc"
    ".gitconfig"
    ".p10k.zsh"
    ".fehbg"
    ".tmux.conf"
    ".xinitrc"
    ".Xresources"
)

# Define config directories to sync
CONFIG_DIRS=(
    "i3"
    "i3blocks"
    "kitty"
    "alacritty"
    "nvim"
    "picom"
    "rofi"
    "btop"
    "gtk-3.0"
    "nitrogen"
)

# Sync individual dotfiles
for file in "${DOTFILES[@]}"; do
    if [[ -f ~/$file ]] && [[ ! -L ~/$file ]]; then
        cp ~/$file ~/dotfiles/
        echo "✓ Synced $file"
    elif [[ -L ~/$file ]]; then
        echo "↷ Skipped $file (symlink)"
    fi
done

# Sync config directories
for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d ~/.config/$dir ]]; then
        mkdir -p ~/dotfiles/.config/
        rsync -av --delete ~/.config/$dir/ ~/dotfiles/.config/$dir/
        echo "✓ Synced .config/$dir"
    fi
done

# Check for changes
if [[ -n $(git status -s) ]]; then
    echo -e "\n=== Changes detected ==="
    git status -s
    
    # Add all changes
    git add .
    
    # Use custom message if provided, otherwise use timestamp
    if [[ -n "$1" ]]; then
        COMMIT_MSG="$*"
    else
        COMMIT_MSG="Sync dotfiles: $(date '+%Y-%m-%d %H:%M')"
    fi
    
    # Commit with message
    git commit -m "$COMMIT_MSG"
    
    # Push to remote
    git push
    echo "✓ Pushed to GitHub"
else
    echo "✓ No changes to sync"
fi
