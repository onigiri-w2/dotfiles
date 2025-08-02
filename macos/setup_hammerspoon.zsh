#!/bin/zsh

echo "Setting up Hammerspoon..."

# Define paths
DOTFILES_DIR="$(dirname "$(dirname "$(realpath "${(%):-%x}")")")"
HAMMERSPOON_CONFIG_DIR="$DOTFILES_DIR/config/hammerspoon"
HAMMERSPOON_INSTALL_DIR="$HOME/.hammerspoon"

# Remove existing installation
rm -rf "$HAMMERSPOON_INSTALL_DIR"

# Create symlink
ln -s "$HAMMERSPOON_CONFIG_DIR" "$HAMMERSPOON_INSTALL_DIR"

echo "✓ Hammerspoon setup completed!"
