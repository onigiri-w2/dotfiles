# AI エージェント系のうち brew で入らないものをセットアップする。
# GUI アプリ（Claude Desktop / OpenCode Desktop）と pi は Brewfile 側。

# opencode CLI: 公式インストーラ。~/.opencode/ に node_modules ごと展開して
# bin/opencode（単一バイナリ）を置く。$OPENCODE_INSTALL_DIR で移せるが既定のままにする。
# 既にあれば何もしない（冪等）。更新は `opencode upgrade`。
if [[ ! -x "$HOME/.opencode/bin/opencode" ]]; then
  curl -fsSL https://opencode.ai/install | bash
fi

# インストーラは ~/.zshrc に PATH 追記するが、dotfiles ではシェル読み込みを
# features/ai/shell.zsh に一元化するので、その追記行を除去する
# （features/safe-chain/install.zsh と同じ方式）。
sed -i '' '/\.opencode\/bin/d' "$HOME/.zshrc"
