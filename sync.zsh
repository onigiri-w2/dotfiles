#!/bin/zsh

# dotfiles 同期: 既存マシンに新しい install を反映させる
# 使い方: ./sync.zsh
#
# setup.zsh との違い:
# - Homebrew 自体のインストールは行わない（既に入っている前提）
# - macOS defaults 適用は行わない
# - .zshrc への bootstrap 追記は行わない

# zsh 専用（${0:A:h} 等を使う）。sh 等で実行されたら明示的に弾く。
if [ -z "$ZSH_VERSION" ]; then
  echo "sync.zsh は zsh で実行してください: ./sync.zsh（または zsh sync.zsh）" >&2
  exit 1
fi

DOTFILES="${0:A:h}"

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not installed. Run ./setup.zsh first."
    exit 1
fi

# 前回 sync から進んでいたら cleanup の声がけ
LAST_SYNC_FILE="$HOME/.dotfiles-last-sync"
if [[ -f $LAST_SYNC_FILE ]]; then
    LAST_SYNC=$(cat "$LAST_SYNC_FILE")
    BEHIND=$(git -C "$DOTFILES" rev-list --count "${LAST_SYNC}..HEAD" 2>/dev/null || echo "?")
    if [[ "$BEHIND" != "0" && "$BEHIND" != "?" ]]; then
        echo "⚠️  $BEHIND commits since last sync. 削除された install の痕跡が残っているかも。"
        echo "   Claude に「このPCを sync して」と頼むと cleanup → sync → marker 更新まで面倒見ます。"
        echo "   このまま続行する場合は cleanup スキップ。5秒後に進めます (Ctrl-C で中断)"
        sleep 5
    fi
fi

for feature in "$DOTFILES/features/"*/; do
    [[ -f "$feature/install.zsh" ]] && source "$feature/install.zsh"
done

echo "Sync done!"
