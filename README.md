# dotfiles

![immagine](https://github.com/user-attachments/assets/64257643-3157-41cf-913a-9c1981800415)

Download JetBrainsMono Nerd Font from: 
[nerdfonts.com](https://www.nerdfonts.com/font-downloads)

Unzip the folder to the Fedora font dir:
```bash
  unzip JetBrainsMono.zip -d ~/.local/share/fonts/
```

Install dependecines on Fedora:

```bash
  sudo dnf -y install stow hypridle hyprlock hyprpaper waybar neovim python3-neovim wofi
```

Stow the .configs:
```bash
  stow $(ls -d */) 
```
