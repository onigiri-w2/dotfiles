# tmux を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install tmux
brew install tmuxinator
# tmux.conf が依存する外部コマンド（凝集性優先で他 feature と重複してもよい）
brew install fzf     # prefix + s のセッション切替 (session-switcher.sh)
brew install lazygit # prefix + g の lazygit ポップアップ

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/config/tmux" "$HOME/.config/tmux"
