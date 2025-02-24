# dotfiles
Install dependecines on Fedora:

```bash
  sudo dnf -y install hypridle hyprlock hyprpaper waybar neovim python3-neovim wofi
```

Stow the .configs:
```bash
  stow --adopt $(ls -d */) 
```
