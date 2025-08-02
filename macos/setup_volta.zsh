#!/bin/zsh

echo "Setting up Volta (Node.js)..."

# Verify Volta is installed (should be from Brewfile)
if ! command -v volta &> /dev/null; then
    echo "❌ Error: Volta is not installed!"
    echo "Please install Volta first by running 'brew install volta' or check your Brewfile."
    exit 1
fi

volta install node@lts
volta install npm@latest

# Install useful global packages
echo "Installing global npm packages..."
npm install -g @anthropic-ai/claude-code

# Verify installations
echo "Verifying Node.js setup..."
echo "Volta version: $(volta --version)"
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"

echo "✓ Volta setup completed successfully!"
