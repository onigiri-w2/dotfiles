# nvim を このPCにセットアップする
# パッケージは Brewfile を参照。

# 依存: lang-node (LSP等で必要)
source "${0:A:h:h}/lang-node/install.zsh"

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/config/nvim" "$HOME/.config/nvim"
