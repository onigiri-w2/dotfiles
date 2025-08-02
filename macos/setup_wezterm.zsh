#!/bin/zsh

echo "Setting up WezTerm..."

# Define paths
DOTFILES_DIR="$(dirname "$(dirname "$(realpath "${(%):-%x}")")")"
WEZTERM_CONFIG_DIR="$DOTFILES_DIR/config/wezterm"
WEZTERM_INSTALL_DIR="$HOME/.config/wezterm"

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Remove existing installation
rm -rf "$WEZTERM_INSTALL_DIR"

# Create symlink
ln -s "$WEZTERM_CONFIG_DIR" "$WEZTERM_INSTALL_DIR"

echo "✓ WezTerm setup completed!"
