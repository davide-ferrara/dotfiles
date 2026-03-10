#!/usr/bin/env bash

EXCLUDE_PATTERNS=(
  "omarchy"
  "nvidia"
  "amd-ucode"
  "^linux$"
  "linux-headers"
  "linux-firmware"
  "lib32-nvidia"
  "libva-nvidia"
)

EXCLUDE_REGEX=$(IFS='|'; echo "${EXCLUDE_PATTERNS[*]}")

pacman -Qqe | grep -v -E "^(${EXCLUDE_REGEX})" > packages.txt

echo "Packages saved to packages.txt (machine-specific packages excluded)"
