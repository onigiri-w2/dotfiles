#!/usr/bin/env bash
# 動いている Claude エージェントの fzf ピッカー。
#   picker.sh          ピッカーを開き、enter で選んだエージェントへジャンプ
#   picker.sh --list   行だけ出力（ctrl-x 後の reload 用）
#
# craftzdog/tmux-claude-session-manager (MIT) を取り込んで改変:
#   - 一覧にタイトル列を表示（プレビューを見なくても内容が分かるように）
#   - プレビューは既定で非表示。tab でトグル（開くと上 70%・追従スクロール）
#
# ジャンプは2種類:
#   dedicated  launch.sh が作った claude-* セッション → この popup 上で再 attach
#   loose      それ以外の pane で動く Claude → その pane をその場でフォーカス
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ "${1:-}" = '--list' ] && exec "$DIR/agents.sh"

for tool in fzf jq claude; do
  command -v "$tool" >/dev/null 2>&1 || {
    tmux display-message "claude picker: $tool is required"
    exit 0
  }
done

self="$DIR/picker.sh"
export FZF_DEFAULT_OPTS=''

# ctrl-x は Claude プロセス自体を kill する。dedicated セッションは最後の window と
# 共に消え、loose pane はホストしていたシェルが残る。reload は supervisor が
# `claude agents --json` から落とすまで一呼吸待つ。
sel=$("$DIR/agents.sh" | fzf --ansi --delimiter='\t' --with-nth=5,6,7,8,9 \
  --reverse --cycle \
  --header='enter: jump · tab: preview · ctrl-x: kill' \
  --preview='tmux capture-pane -ept {2}' \
  --preview-window='up,70%,follow,hidden' \
  --bind='tab:toggle-preview' \
  --bind="ctrl-x:execute-silent(kill {3})+reload(sleep 0.3; $self --list)")

[ -z "$sel" ] && exit 0
pane=$(printf '%s' "$sel" | cut -f2)
kind=$(printf '%s' "$sel" | cut -f4)

parent=$(tmux show-options -gqv @claude_parent 2>/dev/null)
session=$(tmux display-message -p -t "$pane" '#{session_name}' 2>/dev/null)

if [ "$kind" = loose ]; then
  # 外側クライアントをその pane にフォーカスするだけ。popup はスクリプト終了で閉じる。
  if [ -n "$parent" ]; then
    tmux switch-client -c "$parent" -t "$session" 2>/dev/null
  else
    tmux switch-client -t "$session" 2>/dev/null
  fi
  tmux select-window -t "$pane" 2>/dev/null
  tmux select-pane -t "$pane" 2>/dev/null
  exit 0
fi

# dedicated: 外側クライアントを起動元 window へ戻し（best-effort）、選んだ Claude の
# window をフォーカスしてから、この popup 上でそのセッションに attach し直す。
origin=$(tmux show-options -qv -t "$session" @claude_origin 2>/dev/null)
[ -n "$origin" ] && [ -n "$parent" ] &&
  tmux switch-client -c "$parent" -t "$origin" 2>/dev/null

tmux select-window -t "$pane" 2>/dev/null
tmux select-pane -t "$pane" 2>/dev/null
tmux attach-session -t "$session"
