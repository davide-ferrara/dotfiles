#!/bin/bash

# Directory where the repository's config files are located
CONFIG_DIR=$(pwd)/config

# Destination directory (~/.config)
DEST_DIR="$HOME/.config"

# Function to create symlink if it doesn't already exist or overwrite if necessary
create_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ -L "$dest" ] || [ -d "$dest" ]; then
        echo "Removing existing $dest"
        rm -rf "$dest"
    fi

    ln -s "$src" "$dest"
    echo "Created symlink: $src -> $dest"
}

# Create symbolic links for each configuration file/folder
create_symlink "$CONFIG_DIR/i3" "$DEST_DIR/i3"
create_symlink "$CONFIG_DIR/kitty" "$DEST_DIR/kitty"
create_symlink "$CONFIG_DIR/nitrogen" "$DEST_DIR/nitrogen"
create_symlink "$CONFIG_DIR/nvim" "$DEST_DIR/nvim"
create_symlink "$CONFIG_DIR/polybar" "$DEST_DIR/polybar"

echo "Symbolic links successfully created."

