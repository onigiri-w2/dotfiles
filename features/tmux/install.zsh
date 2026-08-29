# tmux を このPCにセットアップする
# パッケージは Brewfile を参照。

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
