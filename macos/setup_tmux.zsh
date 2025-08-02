#!/bin/zsh

echo "Setting up Tmux..."

# Define paths
DOTFILES_DIR="$(dirname "$(dirname "$(realpath "${(%):-%x}")")")"
TMUX_CONFIG_DIR="$DOTFILES_DIR/config/tmux"
TMUX_INSTALL_DIR="$HOME/.config/tmux"

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Remove existing installation
rm -rf "$TMUX_INSTALL_DIR"

# Create symlink
ln -s "$TMUX_CONFIG_DIR" "$TMUX_INSTALL_DIR"

echo "✓ Tmux setup completed!"
