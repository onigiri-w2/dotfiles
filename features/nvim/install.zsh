# nvim を このPCにインストール & setup する
# 1回だけ実行

# 依存: lang-node (LSP等で必要)
source "${0:A:h:h}/lang-node/install.zsh"

# Install
brew install nvim
brew install ripgrep
brew install fd
brew install trash
brew install lazygit

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/config/nvim" "$HOME/.config/nvim"
