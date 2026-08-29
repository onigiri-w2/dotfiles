# lang-bun 環境変数
# シェル起動時に毎回読み込む

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions（install 時に bun 自身が生成する。未生成のマシンでも壊れないようガード）
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
