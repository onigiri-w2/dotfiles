#!/usr/bin/env bash
# picker を popup で開く。セッション popup の中から呼ばれた場合は、その popup を
# 閉じてから外側のクライアント上でフルサイズで開き直す。
# 引数: <client_name>   ※ tmux.conf の bind u から run-shell 経由で展開される
# craftzdog/tmux-claude-session-manager (MIT) を取り込んで改変。
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

prefix='claude-'

# キーを押したクライアントと、それが attach しているセッション。
# client_name の完全一致で引く（複数クライアントがいる時に他人を巻き込まないため）。
me="${1:-}"
my_session="$(tmux list-clients -F '#{client_name} #{session_name}' 2>/dev/null |
  awk -v me="$me" '$1 == me { print $2; exit }')"

case "$my_session" in
"$prefix"*)
  # セッション popup の中にいる: 閉じてから、元々開いた外側クライアントで開き直す。
  tmux detach-client -s "$my_session"
  for _ in $(seq 1 100); do
    tmux list-clients -F '#{session_name}' 2>/dev/null | grep -qx "$my_session" || break
    sleep 0.05
  done
  host="$(tmux show-options -gqv @claude_parent 2>/dev/null)"
  ;;
*)
  # 通常ケース: このクライアント自身がホスト。
  host="$me"
  tmux set-option -g @claude_parent "$host"
  ;;
esac

if [ -n "$host" ]; then
  tmux display-popup -c "$host" -w 90% -h 90% -E "$DIR/picker.sh"
else
  tmux display-popup -w 90% -h 90% -E "$DIR/picker.sh"
fi
