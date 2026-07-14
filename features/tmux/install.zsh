# tmux を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install tmux
brew install tmuxinator
# tmux.conf が依存する外部コマンド（凝集性優先で他 feature と重複してもよい）
brew install fzf        # prefix + s のセッション切替 (session-switcher.sh)
brew install lazygit    # prefix + g の lazygit ポップアップ
brew install lazydocker # prefix + D の lazydocker ポップアップ
brew install git-delta  # lazygit の diff pager (config/lazygit/config.yml)

# TPM (tmux plugin manager) を clone。
# tmux.conf 末尾の `run '.../tpm/tpm'` が @plugin を読み込む。
# 初回は tmux 起動後に prefix + I でプラグイン取得。
if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/config/tmux" "$HOME/.config/tmux"
ln -sfn "$SCRIPT_DIR/config/lazygit" "$HOME/.config/lazygit"
