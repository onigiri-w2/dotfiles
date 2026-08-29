# terminal を このPCにセットアップする
# パッケージは Brewfile を参照。

SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/config/wezterm" "$HOME/.config/wezterm"
