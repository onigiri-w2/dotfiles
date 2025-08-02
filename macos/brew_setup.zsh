# ----------------------------- #
# install Homebrew (if not already installed)
# ----------------------------- #
if command -v brew &> /dev/null; then
    echo "Homebrew is already installed at: $(which brew)"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # ----------------------------- #
    # Add Homebrew to PATH
    # ----------------------------- #
    # Detect architecture and set Homebrew path
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon (M1/M2)
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        # Intel
        HOMEBREW_PREFIX="/usr/local"
    fi
    
    # Add Homebrew to PATH for this session
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
    
    # Verify Homebrew is accessible
    if ! command -v brew &> /dev/null; then
      echo "Error: Homebrew installation failed or not accessible"
      exit 1
    fi
    
    echo "Homebrew installed successfully at: $(which brew)"
fi

# ----------------------------- #
# bundle Brewfile
# ----------------------------- #
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if Brewfile exists in the same directory as this script
if [[ ! -f "$SCRIPT_DIR/Brewfile" ]]; then
  echo "Error: Brewfile not found in $SCRIPT_DIR"
  exit 1
fi

# Create config directory and create symbolic link
mkdir -p "$HOME/.config/brew"
ln -sf "$SCRIPT_DIR/Brewfile" "$HOME/.config/brew/Brewfile"

echo "Installing Homebrew bundle..."

brew bundle install --file="$HOME/.config/brew/Brewfile"
