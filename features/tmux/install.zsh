# tmux を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install tmux
brew install tmuxinator
# tmux.conf が依存する外部コマンド（凝集性優先で他 feature と重複してもよい）
brew install fzf        # prefix + u の Claude ピッカー (config/tmux/claude/picker.sh)
brew install lazygit    # prefix + g の lazygit ポップアップ
brew install lazydocker # prefix + D の lazydocker ポップアップ
brew install git-delta  # lazygit の diff pager (config/lazygit/config.yml)
brew install jq         # Claude ピッカーが `claude agents --json` の解析に使う

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/config/tmux" "$HOME/.config/tmux"
ln -sfn "$SCRIPT_DIR/config/lazygit" "$HOME/.config/lazygit"
