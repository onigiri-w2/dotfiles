#!/usr/bin/env bash
# Claude Code statusLine: 入力欄の下に「モデル名 + コンテキスト使用率バー + %」を表示。
# stdin に Claude Code から JSON が渡される。ローカル実行なので API トークンは消費しない。
set -euo pipefail

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
# used_percentage は入力トークンのみで算出。/compact 直後などは null になり得るので // 0。
pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# 10 文字のプログレスバー（▓ = 使用済み / ░ = 残り）
width=10
filled=$(( pct * width / 100 ))
(( filled > width )) && filled=$width
(( filled < 0 )) && filled=0
empty=$(( width - filled ))

bar=""
(( filled > 0 )) && { printf -v f "%${filled}s" ""; bar="${f// /▓}"; }
(( empty  > 0 )) && { printf -v e "%${empty}s"  ""; bar="${bar}${e// /░}"; }

printf '[%s] %s %s%%' "$model" "$bar" "$pct"
