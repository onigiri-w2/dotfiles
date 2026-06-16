# safe-chain (Aikido): npm/npx/yarn/pnpm/bun/pip/poetry/uv 等の
# パッケージ導入時にマルウェアをスキャンする supply-chain 保護。
# 1回だけ実行。

# npm が必要なので lang-node を先に保証（install は冪等）
source "$DOTFILES/features/lang-node/install.zsh"

# 本体をグローバル導入
npm install -g @aikidosec/safe-chain

# mise で node を入れ直しても safe-chain が消えないよう、
# default パッケージに登録（mise が新規 node 導入時に自動再インストールする）。冪等。
default_pkgs="$HOME/.default-npm-packages"
grep -qxF "@aikidosec/safe-chain" "$default_pkgs" 2>/dev/null \
  || echo "@aikidosec/safe-chain" >> "$default_pkgs"

# シェルフック本体（~/.safe-chain/scripts/）と MITM スキャン用証明書（~/.safe-chain/certs/）を生成。
safe-chain setup

# setup は ~/.zshrc に init スクリプトの source 行を直接追記するが、
# dotfiles ではシェル読み込みを features/safe-chain/shell.zsh に一元化するため、その追記行を除去する。
sed -i '' '/Safe-chain.*initialization script/d' "$HOME/.zshrc"

# uninstall は自動化しない（dotfiles 方針）。手動で消すときは `safe-chain teardown` を実行。
