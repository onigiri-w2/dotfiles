# AI エージェント系のうち brew で入らないものをセットアップする。
# GUI アプリ（Claude Desktop / OpenCode Desktop）と pi は Brewfile 側。
#
# ここに並ぶ CLI はいずれも自己更新型（`opencode upgrade` / `kimi upgrade`）。
# 既にあれば何もしない（冪等）ので、バージョン更新は各ツールに任せる。

# opencode CLI: 公式インストーラ。~/.opencode/ に node_modules ごと展開して
# bin/opencode（単一バイナリ）を置く。$OPENCODE_INSTALL_DIR で移せるが既定のままにする。
if [[ ! -x "$HOME/.opencode/bin/opencode" ]]; then
  curl -fsSL https://opencode.ai/install | bash
fi

# kimi-code CLI (MoonshotAI): 公式インストーラ。~/.kimi-code/bin/kimi に単一バイナリを置く。
# 同ディレクトリに config.toml / credentials / sessions も作られるので消さないこと。
if [[ ! -x "$HOME/.kimi-code/bin/kimi" ]]; then
  curl -fsSL https://code.kimi.com/install.sh | bash
fi

# インストーラは ~/.zshrc に PATH 追記するが、dotfiles ではシェル読み込みを
# features/ai/shell.zsh に一元化するので、その追記行を除去する
# （features/safe-chain/install.zsh と同じ方式）。
sed -i '' '/\.opencode\/bin/d;/\.kimi-code\/bin/d' "$HOME/.zshrc"
