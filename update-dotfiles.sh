#!/bin/bash
# Update dotfiles from current system

echo "🔄 Updating dotfiles from current Arch system..."

# Update configs
cp -r ~/.config/i3 config/ 2>/dev/null
cp -r ~/.config/picom config/ 2>/dev/null
cp -r ~/.config/i3blocks config/ 2>/dev/null
cp -r ~/.config/rofi config/ 2>/dev/null
cp -r ~/.config/kitty config/ 2>/dev/null
cp -r ~/.config/nvim config/ 2>/dev/null

# Update shell configs
cp ~/.zshrc . 2>/dev/null
cp ~/.bashrc . 2>/dev/null
cp ~/.profile . 2>/dev/null

# Update package lists
pacman -Qe > system/pacman-packages.txt
pacman -Qm > system/aur-packages.txt

# Update wallpapers
cp ~/Pictures/wallpapers/* wallpapers/ 2>/dev/null

# Update conda environments
if command -v conda &> /dev/null; then
    conda env list | grep -v "^#" | awk '{print $1}' | grep -v "^$" | while read env; do
        if [ "$env" != "base" ]; then
            conda env export -n "$env" > "conda-envs/${env}.yml"
        fi
    done
    conda env export -n base > "conda-envs/base.yml" 2>/dev/null
fi

# Git add and commit
git add .
git commit -m "Update Arch Linux dotfiles $(date '+%Y-%m-%d %H:%M')"

echo "✅ Dotfiles updated! Push with: git push"
