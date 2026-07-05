# kenos CLI（GitHub releases からバイナリ導入）
# 既にあれば何もしない（冪等）。更新したいときは
#   rm ~/.kenos/bin/kenos && source features/kenos/install.zsh
# で latest を取り直す。
if [[ ! -x "$HOME/.kenos/bin/kenos" ]]; then
  mkdir -p "$HOME/.kenos/bin"
  curl -fsSL https://github.com/onigiri-w2/kenos/releases/latest/download/kenos_darwin_arm64 \
    -o "$HOME/.kenos/bin/kenos"
  chmod +x "$HOME/.kenos/bin/kenos"
fi
