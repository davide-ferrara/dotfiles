# dotfiles
Download JetBrainsMono Nerd Font from: 
`https://www.nerdfonts.com/font-downloads`

Unzip the folder to the Fedora Font Dir:
```bash
  unzip JetBrainsMono.zip -d ~/.local/share/fonts/
```

Install dependecines on Fedora:

```bash
  sudo dnf -y install hypridle hyprlock hyprpaper waybar neovim python3-neovim wofi
```

Stow the .configs:
```bash
  stow $(ls -d */) 
```
