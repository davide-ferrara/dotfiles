# Dotfiles setup

Base configs are from `https://github.com/basecamp/omarchy`, I would like to save
my own configuration of Omarchy in this repository.
Right now I have customized `waybar`, `neovim`, some `keybinds` of `hyprland`
to fit my `glove80` keyboard.
Config files are stored in ~/.config, we use GNU stow to manage symlinks to the home folder.

## Package Backup

List explicitly installed packages:
```bash
pacman -Qqe > packages.txt
```

Restore packages on another machine:
```bash
yay -S --needed $(cat packages.txt)
```

## Stow Setup

Directory structure:
```
dotfiles/
├── waybar/
│   └── .config/waybar/
├── neovim/
│   └── .config/nvim/
├── hyprland/
│   └── .config/hypr/
├── ghostty/
│   └── .config/ghostty/
├── tmux/
│   └── .config/tmux/
└── ...
```

Install stow and create symlinks:
```bash
# Stow all packages (creates symlinks from home to dotfiles/)
stow -t "$HOME" .

# Remove a package's symlinks
stow -t "$HOME" -D waybar

# Restow a package
stow -t "$HOME" -R waybar
```

The stow packages directory should mirror the home folder structure (e.g., `.config/waybar` inside the stow package). Stow will create the symlinks at `~/.config/waybar` pointing to the files in the repo.

## Scripts

- `backup-packages.sh` - Backup explicitly installed packages to packages.txt
- `setup.sh` - Install packages and setup dotfiles via stow
