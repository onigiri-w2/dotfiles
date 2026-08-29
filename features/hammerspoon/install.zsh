# hammerspoon を このPCにセットアップする
# パッケージは Brewfile を参照。

SCRIPT_DIR="${0:A:h}"
ln -sfn "$SCRIPT_DIR/config/hammerspoon" "$HOME/.hammerspoon"
