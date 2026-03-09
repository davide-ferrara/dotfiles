#!/usr/bin/env bash

# Backup explicitly installed packages
pacman -Qqe > packages.txt

echo "Packages saved to packages.txt"
