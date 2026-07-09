#!/usr/bin/env bash
# 指定ディレクトリ用の Claude セッションを起動（既存なら再接続）して popup で開く。
# 引数: <dir> [origin-window-id]   ※ tmux.conf の bind y から run-shell 経由で展開される
# popup は C-a d で detach すれば閉じる（Claude は裏で動き続ける）。
# craftzdog/tmux-claude-session-manager (MIT) を取り込んで改変。
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
. "$DIR/helpers.sh"

path="${1:-$PWD}"
window="${2:-}"
prefix='claude-'

session="${prefix}$(session_hash "$path")"

# セッション popup の中からさらに y を押した場合は何もしない
if [[ "$(tmux display-message -p '#S')" == "$prefix"* ]]; then
  tmux display-message '🫪 Popup window already open'
  exit 0
fi

tmux has-session -t "$session" 2>/dev/null ||
  tmux new-session -d -s "$session" -c "$path" claude

# どの window から起動したかを記録（picker がジャンプ時の戻り先に使う）
[ -n "$window" ] && tmux set-option -t "$session" @claude_origin "$window"

tmux display-popup -w 90% -h 90% -E "tmux attach-session -t $session"
