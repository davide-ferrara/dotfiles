#!/usr/bin/env bash

set -e

echo "Installing packages (official + AUR)..."
yay -S --needed $(cat packages.txt)

echo "Setting up dotfiles with stow..."
stow -t "$HOME" .

echo "Setup complete!"
