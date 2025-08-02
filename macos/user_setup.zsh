# ----------------------------- #
# macOS System Settings Configuration
# ----------------------------- #

echo "Configuring macOS system settings..."

echo "Configuring Dock..."
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.1
defaults write com.apple.dock autohide-time-modifier -float 0.5

echo "Configuring Menu Bar..."
defaults write NSGlobalDomain _HIHideMenuBar -bool true

echo "Configuring Keyboard..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Applying changes..."
killall Dock
killall SystemUIServer

echo "System settings have been configured successfully!"
echo ""
echo "Changes applied:"
echo "✓ Dock moved to left side"
echo "✓ Dock auto-hide enabled"
echo "✓ Menu bar auto-hide enabled"
echo "✓ Key repeat rate set to maximum"
echo "✓ Initial key repeat delay set to minimum"
echo ""
echo "Note: Some changes may require a restart to take full effect."




# ----------------------------- #
# Volta Setup (Node.js Version Manager)
# ----------------------------- #
echo "Setting up Volta (Node.js)..."

# Verify Volta is installed (should be from Brewfile)
if ! command -v volta &> /dev/null; then
  echo "Error: Volta is not installed. Please check your Brewfile."
  exit 1
fi

volta setup

volta install node@lts
volta install npm@latest

# Install useful global packages
echo "Installing global npm packages..."
npm install -g @anthropic/claude-code

# Verify installations
echo "Verifying Node.js setup..."
echo "Volta version: $(volta --version)"
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"

echo "✓ Volta setup completed successfully!"
