#!/usr/bin/env bash
# tmux セッションを fzf で選んで切替。
#   enter  : そのセッションへ切替
#   ctrl-x : 選択中のセッションを kill して一覧を即リロード（複数消せる）
# tmux.conf の `bind s` から display-popup 経由で呼ばれる。

set -uo pipefail

# 一覧取得コマンド。fzf の reload からも同じものを使う。
# `-F "#{session_name}"` だと fzf が {session_name} をプレースホルダと誤解する
# ため、ブレースを避けて list-sessions の既定出力から名前だけ切り出す。
list_cmd='tmux list-sessions | cut -d: -f1'

sess=$(eval "$list_cmd" | fzf --reverse \
	--header 'enter: switch / ctrl-x: kill' \
	--bind "ctrl-x:execute-silent(tmux kill-session -t {})+reload($list_cmd)")

# Esc / 何も選ばず終了なら空 → 何もしない。
[ -z "${sess:-}" ] && exit 0

tmux switch-client -t "$sess"
