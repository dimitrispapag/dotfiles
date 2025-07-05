     1	#!/bin/bash
     2	# Enhanced dotfiles sync script
     3	
     4	cd ~/dotfiles
     5	
     6	echo "=== Syncing dotfiles ==="
     7	
     8	# Define what files to sync
     9	DOTFILES=(
    10	    ".bashrc"
    11	    ".bash_profile"
    12	    ".zshrc"
    13	    ".gitconfig"
    14	    ".p10k.zsh"
    15	    ".fehbg"
    16	    ".tmux.conf"
    17	    ".xinitrc"
    18	    ".Xresources"
    19	)
    20	
    21	# Define config directories to sync
    22	CONFIG_DIRS=(
    23	    "i3"
    24	    "i3blocks"
    25	    "kitty"
    26	    "alacritty"
    27	    "nvim"
    28	    "picom"
    29	    "rofi"
    30	    "btop"
    31	    "gtk-3.0"
    32	    "nitrogen"
    33	)
    34	
    35	# Sync individual dotfiles
    36	for file in "${DOTFILES[@]}"; do
    37	    if [[ -f ~/$file ]]; then
    38	        cp ~/$file ~/dotfiles/
    39	        echo "✓ Synced $file"
    40	    fi
    41	done
    42	
    43	# Sync config directories
    44	for dir in "${CONFIG_DIRS[@]}"; do
    45	    if [[ -d ~/.config/$dir ]]; then
    46	        mkdir -p ~/dotfiles/.config/
    47	        rsync -av --delete ~/.config/$dir/ ~/dotfiles/.config/$dir/
    48	        echo "✓ Synced .config/$dir"
    49	    fi
    50	done
    51	
    52	# Check for changes
    53	if [[ -n $(git status -s) ]]; then
    54	    echo -e "\n=== Changes detected ==="
    55	    git status -s
    56	    
    57	    # Add all changes
    58	    git add .
    59	    
    60	    # Commit with timestamp
    61	    git commit -m "Sync dotfiles: $(date '+%Y-%m-%d %H:%M')"
    62	    
    63	    # Push to remote
    64	    git push
    65	    echo "✓ Pushed to GitHub"
    66	else
    67	    echo "✓ No changes to sync"
    68	fi
