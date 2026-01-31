#!/bin/bash

# Interrompi lo script se un comando fallisce
set -e

# Variabili per rendere tutto generico
CURRENT_USER="$USER"
USER_HOME="$HOME"
HYPR_CONFIG_DIR="$USER_HOME/.config/hypr"
# Assumiamo che la cartella custom sia nella directory corrente dove lanci lo script
# Se la cartella si chiama ancora "custom-dave", cambiala qui sotto o rinominala
CUSTOM_FOLDER_NAME="custom-dave"
SOURCE_CUSTOM_DIR="$(pwd)/hypr/$CUSTOM_FOLDER_NAME"

echo "=== Inizio Installazione per l'utente: $CURRENT_USER ==="

echo "📦 Installando le dipendenze..."
# Nota: yay non deve essere eseguito come root, quindi niente sudo qui se lo script è lanciato da utente
sudo pacman -S --needed --noconfirm jq github-cli libreoffice-fresh npm gcc make git base-devel
if ! command -v yay &>/dev/null; then
  echo "⚠️ Yay non trovato. Installalo manualmente o assicurati che sia nel PATH."
else
  yay -S --needed --noconfirm thorium-browser-bin
fi

echo "🌍 Settando il browser di default (Thorium)..."
xdg-mime default thorium-browser.desktop x-scheme-handler/http
xdg-mime default thorium-browser.desktop x-scheme-handler/https
xdg-mime default thorium-browser.desktop text/html
# xdg-settings set default-web-browser thorium-browser.desktop

echo "🔥 Autorizzando KDE Connect nel Firewall..."
# Controlla se firewalld è in esecuzione prima di provare a configurarlo
if systemctl is-active --quiet firewalld; then
  sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
  sudo firewall-cmd --reload
else
  echo "⚠️ Firewalld non è attivo o non installato. Salto configurazione firewall."
fi

echo "📂 Configurando le cartelle utente..."
mkdir -p "$USER_HOME/Pictures/Wallpapers"
mkdir -p "$USER_HOME/Documents"
mkdir -p "$USER_HOME/Videos"

echo "🔗 Linkando i dotfiles..."
# Verifica che la cartella sorgente esista davvero
if [ -d "$SOURCE_CUSTOM_DIR" ]; then
  ln -sfn "$SOURCE_CUSTOM_DIR" "$HYPR_CONFIG_DIR/$CUSTOM_FOLDER_NAME"
  echo "✅ Symlink creato: $HYPR_CONFIG_DIR/$CUSTOM_FOLDER_NAME -> $SOURCE_CUSTOM_DIR"
else
  echo "❌ Errore: Non trovo la cartella sorgente $SOURCE_CUSTOM_DIR"
  exit 1
fi

echo "⚙️ Aggiornamento hyprland.conf..."
HYPR_MAIN_CONF="$HYPR_CONFIG_DIR/hyprland.conf"

# Debug: Stampiamo dove stiamo cercando di scrivere (così vedi se il percorso è giusto)
echo "   📍 File target: $HYPR_MAIN_CONF"
echo "   📍 Cartella custom: $CUSTOM_FOLDER_NAME"

# Controllo se il file esiste
if [ ! -f "$HYPR_MAIN_CONF" ]; then
  echo "❌ ERRORE: Il file $HYPR_MAIN_CONF non esiste!"
  exit 1
fi

# Controlla se è già stato modificato
if grep -q "$CUSTOM_FOLDER_NAME" "$HYPR_MAIN_CONF"; then
  echo "ℹ️  Le configurazioni sembrano già presenti. Salto."
else
  # 1. Aggiungo una riga vuota per sicurezza (evita di scrivere sulla stessa riga dell'ultimo comando)
  echo "" >>"$HYPR_MAIN_CONF"

  # 2. Uso cat con EOF per appendere il testo. È più affidabile di 'read'.
  cat <<EOM >>"$HYPR_MAIN_CONF"

# --- CUSTOM CONFIG ($CURRENT_USER) ---
source = ~/.config/hypr/$CUSTOM_FOLDER_NAME/execs.conf
source = ~/.config/hypr/$CUSTOM_FOLDER_NAME/general.conf
source = ~/.config/hypr/$CUSTOM_FOLDER_NAME/rules.conf
source = ~/.config/hypr/$CUSTOM_FOLDER_NAME/keybinds.conf
# -------------------------------------
EOM

  echo "✅ Configurazioni aggiunte in fondo a hyprland.conf"
fi

echo "🖼️ Installando gli sfondi ChromeOS..."
TEMP_WALL_DIR="/tmp/chromeos_walls"
TARGET_WALL_DIR="$USER_HOME/Pictures/Wallpapers"

# Clona in una temp dir per evitare conflitti
git clone --depth 1 https://github.com/pacman2108/wallpapers-chromeos.git "$TEMP_WALL_DIR"

# Sposta solo le immagini, ignorando i file git
echo "Sposto gli sfondi nella tua cartella..."
find "$TEMP_WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -exec cp {} "$TARGET_WALL_DIR" \;

# Pulizia
rm -rf "$TEMP_WALL_DIR"
echo "✅ Sfondi installati in $TARGET_WALL_DIR"

echo "🐙 Login GitHub..."
gh auth login

echo "=== 🎉 Installazione Completata! ==="
