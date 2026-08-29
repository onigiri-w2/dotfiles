# lang-node を このPCにセットアップする
# パッケージ（mise）は Brewfile を参照。

# この install.zsh は features/nvim と features/safe-chain からも source されるため
# 1 回の sync で 3 回走る。`mise use` は毎回 config を読んで出力するので、
# 既に global に node が入っていれば何もしない。
mise ls --global 2>/dev/null | grep -q '^node' || mise use --global node@lts
