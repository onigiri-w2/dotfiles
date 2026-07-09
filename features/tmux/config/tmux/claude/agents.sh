#!/usr/bin/env bash
# 動いている Claude を tmux pane と突き合わせて、picker 用の行を1エージェント1行で出力。
# craftzdog/tmux-claude-session-manager (MIT) を取り込んで改変（タイトル列を追加）。
#
# `claude agents --json` が唯一の情報源。pane_current_command は macOS では親シェル
# しか返らず使えないので、pid -> tty -> pane の3段結合で「どの pane のどの Claude か」
# を特定する。identity は Claude プロセスなので、同一プロジェクトに複数 Claude が
# いてもそれぞれ1行ずつ出る。
#
#   行: rank \t pane_id \t pid \t kind \t icon \t age \t name \t loc \t path
#   rank/pane_id/pid/kind は fzf の --with-nth で非表示にするメタデータ。
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
. "$DIR/helpers.sh"

agents="$(claude agents --json 2>/dev/null)" || exit 0
rows="$(printf '%s' "$agents" |
  jq -r '.[] | select(.kind == "interactive") | [.pid, .status, .sessionId, .cwd, .name // "-"] | @tsv' 2>/dev/null)"
[ -n "$rows" ] || exit 0

# mtime は stat が要るので awk の外で解決しておく。
mtimes="$(printf '%s\n' "$rows" | cut -f3 | while IFS= read -r sid; do
  printf 'M\t%s\t%s\n' "$sid" "$(claude_transcript_mtime "$sid")"
done)"

# pid->tty / tty->pane / session->最終活動 の3ストリームにタグを付けて1つの awk へ。
# セッション数・pane 数によらずサブプロセスは3つで済む。
{
  ps -Ao pid=,tty= 2>/dev/null | awk '{ print "P\t" $1 "\t" $2 }'
  tmux list-panes -a -F $'T\t#{pane_tty}\t#{pane_id}\t#{session_name}\t#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null
  printf '%s\n' "$mtimes"
  printf '%s\n' "$rows" | sed $'s/^/A\t/'
} | awk -F'\t' -v now="$(date +%s)" -v home="$HOME" -v prefix='claude-' '
  $1 == "P" { tty_of[$2] = $3; next }
  $1 == "T" { sub(/^\/dev\//, "", $2); pane[$2] = $3; sess[$2] = $4; loc[$2] = $5; next }
  $1 == "M" { seen_at[$2] = $3; next }
  $1 == "A" {
    tty = tty_of[$2]
    if (tty == "" || !(tty in pane)) next   # tmux の外で動いている Claude

    if      ($3 == "waiting") { icon = "\033[33m●\033[0m waiting"; rank = 0 }  # 黄 - 入力待ち
    else if ($3 == "idle")    { icon = "\033[32m●\033[0m idle   "; rank = 1 }  # 緑 - 完了、こちらの番
    else if ($3 == "busy")    { icon = "\033[31m●\033[0m working"; rank = 3 }  # 赤 - 作業中、放置
    else                      { icon = "\033[90m●\033[0m   ?    "; rank = 2 }  # 灰 - 不明な状態

    age = (seen_at[$4] != "") ? int((now - seen_at[$4]) / 60) "m" : "-"
    kind = (index(sess[tty], prefix) == 1) ? "dedicated" : "loose"

    path = $5
    if (index(path, home) == 1) path = "~" substr(path, length(home) + 1)

    printf "%s\t%s\t%s\t%s\t%s\t%5s\t%s\t%s\t%s\n",
      rank, pane[tty], $2, kind, icon, age, $6, loc[tty], path
  }
' | sort -t$'\t' -k1,1n -k6,6n
# rank 昇順（手が必要なものが上に浮く）、同 rank 内は age 昇順（直近に idle に
# なったものがグループの先頭）。-k6,6n は age 先頭の数字を読む（"5m"->5, "-"->0）。
