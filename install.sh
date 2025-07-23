#!/bin/bash
# Arch Linux Dotfiles Installation Script

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Installing Arch Linux i3 dotfiles...${NC}"

# Check if we're on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}❌ This script is designed for Arch Linux${NC}"
    exit 1
fi

# Create config directories
mkdir -p ~/.config

# Install configurations
echo -e "${GREEN}📂 Installing configurations...${NC}"
cp -r config/* ~/.config/ 2>/dev/null
cp .zshrc ~/ 2>/dev/null
cp .bashrc ~/ 2>/dev/null
cp .profile ~/ 2>/dev/null

# Install wallpapers
echo -e "${GREEN}🎨 Installing wallpapers...${NC}"
mkdir -p ~/Pictures/wallpapers
cp wallpapers/* ~/Pictures/wallpapers/ 2>/dev/null

# Check for package files
if [ -f "system/pacman-packages.txt" ]; then
    echo -e "\n${YELLOW}📦 To install packages, run:${NC}"
    echo -e "${BLUE}./install-packages.sh${NC}"
    echo -e "\nOr manually:"
    echo "sudo pacman -S --needed \$(cat system/pacman-packages.txt | awk '{print \$1}')"
    if [ -f "system/aur-packages.txt" ] && [ -s "system/aur-packages.txt" ]; then
        echo "yay -S --needed \$(cat system/aur-packages.txt | awk '{print \$1}')"
    fi
fi

# Conda environments
if [ -d conda-envs ] && [ "$(ls -A conda-envs)" ]; then
    echo -e "\n${YELLOW}🐍 To restore conda environments, run:${NC}"
    for yml in conda-envs/*.yml; do
        if [ -f "$yml" ]; then
            env_name=$(basename "$yml" .yml)
            echo -e "${BLUE}conda env create -f $yml${NC}"
        fi
    done
fi

echo -e "\n${GREEN}✅ Dotfiles installed!${NC}"
echo -e "${YELLOW}🔄 Next steps:${NC}"
echo "1. Install packages: ./install-packages.sh"
echo "2. Restart i3: MOD+Shift+R"
echo "3. Restore conda environments if needed"
