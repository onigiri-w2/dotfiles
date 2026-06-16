# safe-chain シェルフック（npm/bun/pip 等を wrap する関数を定義）
# 毎回読み込み。本体は safe-chain setup が ~/.safe-chain/scripts に生成する（install.zsh 参照）。
# 未インストールのマシンでも壊れないようガードする。
[[ -f "$HOME/.safe-chain/scripts/init-posix.sh" ]] && source "$HOME/.safe-chain/scripts/init-posix.sh"
