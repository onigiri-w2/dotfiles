# hammerspoon を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install --cask hammerspoon

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
ln -sfn "$SCRIPT_DIR/config/hammerspoon" "$HOME/.hammerspoon"
