#!/bin/bash
# Package installation script

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📦 Installing packages...${NC}"

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Installing yay AUR helper...${NC}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Install official packages
if [ -f "system/pacman-packages.txt" ]; then
    echo -e "${GREEN}Installing official packages...${NC}"
    sudo pacman -S --needed $(cat system/pacman-packages.txt | awk '{print $1}')
fi

# Install AUR packages
if [ -f "system/aur-packages.txt" ] && [ -s "system/aur-packages.txt" ]; then
    echo -e "${GREEN}Installing AUR packages...${NC}"
    yay -S --needed $(cat system/aur-packages.txt | awk '{print $1}')
fi

echo -e "${GREEN}✅ Package installation complete!${NC}"
echo -e "${YELLOW}🔄 Restart your system or i3 to ensure all changes take effect${NC}"
