# git を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install git
brew install gh

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
ln -sf "$SCRIPT_DIR/config/.gitconfig" "$HOME/.gitconfig"
ln -sf "$SCRIPT_DIR/config/.gitignore_global" "$HOME/.gitignore_global"
