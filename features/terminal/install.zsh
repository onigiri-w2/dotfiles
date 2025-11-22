# terminal を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install --cask wezterm

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sf "$SCRIPT_DIR/config/wezterm" "$HOME/.config/wezterm"
