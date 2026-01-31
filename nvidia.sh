#!/bin/bash

# Colori per l'output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}--- Script di Ottimizzazione NVIDIA per Hyprland ---${NC}"

# 1. Controllo Permessi di Root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Per favore esegui questo script come root (usa sudo).${NC}"
  exit
fi

# 2. STEP 1: Installazione Pacchetti
echo -e "\n${GREEN}[Step 1] Installazione driver e pacchetti Wayland...${NC}"

# Cerchiamo di capire quali headers servono (standard o zen)
KERNEL_RELEASE=$(uname -r)
if [[ $KERNEL_RELEASE == *"zen"* ]]; then
  HEADERS="linux-zen-headers"
else
  HEADERS="linux-headers"
fi

echo -e "Rilevato kernel: $KERNEL_RELEASE. Installerò $HEADERS."

# Installa driver, utils, supporto wayland e headers
# Usa --needed per non reinstallare se sono già presenti
pacman -S --needed --noconfirm nvidia-dkms nvidia-utils egl-wayland libva-nvidia-driver $HEADERS

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✔ Installazione pacchetti completata.${NC}"
else
  echo -e "${RED}✘ Errore durante l'installazione dei pacchetti.${NC}"
  exit 1
fi

# 3. STEP 2: Configurazione GRUB (Kernel Mode Setting)
echo -e "\n${GREEN}[Step 2] Attivazione Kernel Mode Setting (nvidia_drm.modeset=1)...${NC}"

GRUB_FILE="/etc/default/grub"

if [ -f "$GRUB_FILE" ]; then
  # Controllo se l'opzione è già presente
  if grep -q "nvidia_drm.modeset=1" "$GRUB_FILE"; then
    echo -e "${YELLOW}⚠ nvidia_drm.modeset=1 è già presente in GRUB. Salto questo passaggio.${NC}"
  else
    echo "Trovato GRUB. Procedo alla modifica."

    # Backup del file originale
    cp "$GRUB_FILE" "${GRUB_FILE}.bak"
    echo "Backup creato in ${GRUB_FILE}.bak"

    # Aggiungo il parametro usando sed (lo inserisce all'inizio delle virgolette)
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1 /' "$GRUB_FILE"

    echo "Aggiornamento configurazione GRUB in corso..."

    # Rileva il comando giusto per aggiornare grub (su Arch/Endeavour è grub-mkconfig)
    grub-mkconfig -o /boot/grub/grub.cfg

    if [ $? -eq 0 ]; then
      echo -e "${GREEN}✔ GRUB aggiornato con successo.${NC}"
    else
      echo -e "${RED}✘ Errore nell'aggiornamento di GRUB.${NC}"
    fi
  fi
else
  echo -e "${RED}⚠ Non ho trovato il file /etc/default/grub.${NC}"
  echo "Se usi systemd-boot (e non GRUB), devi aggiungere 'nvidia_drm.modeset=1' manualmente nel file in /boot/loader/entries/."
fi

# 4. Aggiunta variabili Env (Opzionale ma consigliato per script completi)
# Lo aggiungiamo a un file globale in /etc/profile.d per sicurezza,
# così vale per tutto il sistema, non solo per il tuo utente.
echo -e "\n${GREEN}[Extra] Creazione variabili ambiente globali per NVIDIA...${NC}"
echo "export LIBVA_DRIVER_NAME=nvidia" >/etc/profile.d/nvidia-wayland.sh
echo "export XDG_SESSION_TYPE=wayland" >>/etc/profile.d/nvidia-wayland.sh
echo "export GBM_BACKEND=nvidia-drm" >>/etc/profile.d/nvidia-wayland.sh
echo "export __GLX_VENDOR_LIBRARY_NAME=nvidia" >>/etc/profile.d/nvidia-wayland.sh
chmod +x /etc/profile.d/nvidia-wayland.sh
echo -e "${GREEN}✔ Variabili impostate in /etc/profile.d/nvidia-wayland.sh${NC}"

# Conclusione
echo -e "\n${YELLOW}------------------------------------------------${NC}"
echo -e "${GREEN}TUTTO FATTO! ORA RIAVVIA IL PC.${NC}"
echo -e "${YELLOW}------------------------------------------------${NC}"
