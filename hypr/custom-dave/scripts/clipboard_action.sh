#!/bin/bash

# Argomento: copy, paste, o cut
ACTION=$1

# Ottieni la classe della finestra attiva (minuscolo per confronto facile)
ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r ".class" | tr '[:upper:]' '[:lower:]')

# --- LISTA DEI TERMINALI ---
# Aggiungi qui il nome del tuo terminale (tutto minuscolo) separato da |
# Ho aggiunto i più comuni usati su Arch/End-4
TERMINALS="kitty|foot|alacritty|wezterm|konsole|gnome-terminal|xterm|termite"

# Funzione notifiche (sovrascrive la precedente per non fare spam)
send_notif() {
  notify-send -h string:x-canonical-private-synchronous:clipboard \
    -u low -t 1000 -i "$1" "Smart Clipboard" "$2"
}

# Verifica se la finestra attiva è nella lista dei terminali
if [[ "$ACTIVE_CLASS" =~ $TERMINALS ]]; then
  # --- SIAMO IN UN TERMINALE ---
  case $ACTION in
  "copy")
    # Nel terminale si usa Ctrl+Shift+C
    hyprctl dispatch sendshortcut "CTRL SHIFT, C, activewindow"
    send_notif "edit-copy" "Copiato (Terminale)"
    ;;
  "paste")
    # Nel terminale si usa Ctrl+Shift+V
    hyprctl dispatch sendshortcut "CTRL SHIFT, V, activewindow"
    send_notif "edit-paste" "Incollato (Terminale)"
    ;;
  "cut")
    # "Taglia" non esiste davvero nel terminale, proviamo a cancellare la riga o inviare Ctrl+U
    # Oppure inviamo Ctrl+Shift+X se il terminale lo supporta
    hyprctl dispatch sendshortcut "CTRL SHIFT, X, activewindow"
    send_notif "edit-cut" "Taglia (Terminale)"
    ;;
  esac
else
  # --- SIAMO IN UN'APP NORMALE ---
  case $ACTION in
  "copy")
    hyprctl dispatch sendshortcut "CTRL, C, activewindow"
    send_notif "edit-copy" "Copiato"
    ;;
  "paste")
    hyprctl dispatch sendshortcut "CTRL, V, activewindow"
    send_notif "edit-paste" "Incollato"
    ;;
  "cut")
    hyprctl dispatch sendshortcut "CTRL, X, activewindow"
    send_notif "edit-cut" "Tagliato"
    ;;
  esac
fi
