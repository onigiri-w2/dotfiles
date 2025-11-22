# tmux を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install tmux
brew install tmuxinator

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sf "$SCRIPT_DIR/config/tmux" "$HOME/.config/tmux"
