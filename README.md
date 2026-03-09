# Dotfiles

My personal dotfiles managed with GNU stow.

## What's Inside

- **waybar** - Custom status bar for Hyprland
- **neovim** - NeoVim config with LazyVim
- **hyprland** - Hyprland window manager config (glove80 optimized)
- **ghostty** - Ghostty terminal config
- **tmux** - Tmux config

## Setup

1. Clone this repo:

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd dotfiles
   ```

2. Run the script:

   ```bash
   ./setup.sh
   ```

## Backup

To backup installed packages:

```bash
./backup-packages.sh
```

This saves to `packages.txt`.

## Managing Configs

Add a new config (e.g., kitty):

```bash
mkdir -p kitty/.config/kitty
cp ~/.config/kitty/* kitty/.config/kitty/
stow -t "$HOME" -S kitty
```

Remove a config:

```bash
stow -t "$HOME" -D kitty
```

## Credits

Base config from [Omarchy](https://github.com/basecamp/omarchy)
