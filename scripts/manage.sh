#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/dotfiles"

check_stow() {
    if ! command -v stow &> /dev/null; then
        echo -e "${RED}Error: GNU Stow is not installed${NC}"
        echo "Install with: sudo dnf install stow"
        exit 1
    fi
}

stow_dotfiles() {
    echo -e "${GREEN}Stowing dotfiles...${NC}"
    cd "$DOTFILES_DIR"
    
    echo -e "${BLUE}Checking for conflicts...${NC}"
    if stow -n . -t ~ 2>&1 | grep -q "conflict"; then
        echo -e "${YELLOW}Conflicts detected. Run with --force to override.${NC}"
        stow -n . -t ~ 
        return 1
    fi
    
    stow -v . -t ~
    echo -e "${GREEN}Dotfiles stowed successfully!${NC}"
}

unstow_dotfiles() {
    echo -e "${RED}Unstowing dotfiles...${NC}"
    cd "$DOTFILES_DIR"
    stow -D -v . -t ~
    echo -e "${GREEN}Dotfiles unstowed successfully!${NC}"
}

restow_dotfiles() {
    echo -e "${GREEN}Restowing dotfiles...${NC}"
    cd "$DOTFILES_DIR"
    stow -R -v . -t ~
    echo -e "${GREEN}Dotfiles restowed successfully!${NC}"
}

show_status() {
    echo -e "${BLUE}Dotfiles Status:${NC}"
    cd "$DOTFILES_DIR"
    
    find . -type f | while read -r file; do
        file=${file#./}
        target="$HOME/$file"
        
        if [[ -L "$target" ]]; then
            link_target=$(readlink "$target")
            if [[ "$link_target" == "$DOTFILES_DIR/$file" ]]; then
                echo -e "${GREEN}✓${NC} $file (linked)"
            else
                echo -e "${YELLOW}?${NC} $file (linked elsewhere: $link_target)"
            fi
        elif [[ -f "$target" ]]; then
            echo -e "${RED}✗${NC} $file (file exists, not linked)"
        else
            echo -e "${YELLOW}-${NC} $file (not present)"
        fi
    done
}

case "$1" in
    "stow"|"install")
        check_stow
        stow_dotfiles
        ;;
    "unstow"|"uninstall")
        check_stow
        unstow_dotfiles
        ;;
    "restow"|"reinstall")
        check_stow
        restow_dotfiles
        ;;
    "status")
        show_status
        ;;
    *)
        echo -e "${BLUE}Dotfiles Management Script${NC}"
        echo ""
        echo "Usage: $0 {command}"
        echo ""
        echo "Commands:"
        echo "  stow, install    - Create symlinks for all dotfiles"
        echo "  unstow, uninstall - Remove symlinks for all dotfiles"  
        echo "  restow, reinstall - Remove and recreate symlinks"
        echo "  status           - Show status of dotfiles"
        echo ""
        exit 1
        ;;
esac
