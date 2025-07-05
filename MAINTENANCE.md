     1	# Dotfiles Maintenance Cheatsheet
     2	
     3	## Quick Commands
     4	- `dotsync` - Sync all tracked configs to GitHub
     5	- `cd ~/dotfiles && git status` - Check what changed
     6	- `cd ~/dotfiles && git log --oneline -5` - Recent changes
     7	
     8	## Adding New Configs
     9	1. Copy to dotfiles: `cp ~/.newconfig ~/dotfiles/`
    10	2. Add to sync script: `nvim ~/dotfiles/scripts/sync-all.sh`
    11	3. Commit: `cd ~/dotfiles && git add . && git commit -m "Add newconfig"`
    12	
    13	## What's Tracked
    14	- Shell: .bashrc, .zshrc, .p10k.zsh
    15	- WM: i3, i3blocks, picom, rofi
    16	- Editors: nvim
    17	- Terminals: kitty, alacritty
    18	- Tools: git, tmux (if added)
    19	
    20	## Emergency Restore
    21	```bash
    22	cd ~/dotfiles
    23	git pull
    24	./scripts/manage.sh install
