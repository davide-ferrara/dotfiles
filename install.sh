#!/bin/bash

echo "Installando le dipendenze"
sudo pacman -S jq github-cli libreoffice-fresh
yay -S thorium-browser-bin

echo "Settando il browser di default..."
xdg-mime default thorium-browser.desktop x-scheme-handler/http
xdg-mime default thorium-browser.desktop x-scheme-handler/https
xdg-mime default thorium-browser.desktop text/html

xdg-settings set default-web-browser thorium-browser.desktop

echo "Autorizzando KDE connect nel Firewall.."
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --reload

echo "Congiurando le cartelle..."
mkdfir -p /home/dave/Pictures/Wallpapers
mkdir /home/dave/Documents
mkdir /home/dave/Videos

HYPR_DIR="/home/dave/.config/hypr"
HYPR_CUSTOM_DIR="$(pwd)/hypr/custom-dave"
HYPR_MAIN_CONF="$HYPR_DIR/hyprland.conf"

echo "Linkando i dotfiles..."

ln -sfn "$HYPR_CUSTOM_DIR" "$HYPR_DIR/custom-dave"
echo "Symlink creato in $HYPR_DIR/custom-dave"

echo "Aggiornamento hyprland.conf..."

read -r -d '' TO_APPEND <<EOM

# --- CUSTOM DAVE CONFIG ---
source = ~/.config/hypr/custom-dave/execs.conf
source = ~/.config/hypr/custom-dave/general.conf
source = ~/.config/hypr/custom-dave/rules.conf
source = ~/.config/hypr/custom-dave/keybinds.conf
# --------------------------
EOM

if grep -q "custom-dave" "$HYPR_MAIN_CONF"; then
  echo " Le configurazioni custom sembrano già presenti in hyprland.conf. Salto questo passaggio."
else
  echo "$TO_APPEND" >>"$HYPR_MAIN_CONF"
  echo "Configurazioni aggiunte alla fine di $HYPR_MAIN_CONF"
fi

echo "Installando gli sfondi..."
git clone https://github.com/pacman2108/wallpapers-chromeos.git /home/dave/Pictures/Wallpapers

echo "Adesso effettuerai il login su GitHub"
gh auth login
