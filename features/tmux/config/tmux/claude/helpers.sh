#!/usr/bin/env bash
# 共有ヘルパー。craftzdog/tmux-claude-session-manager (MIT) を取り込んで改変。

# session_hash <string>
# パスからセッション名を導く短い安定ハッシュ（8文字）。末尾改行込みでハッシュ
# するのは `echo "$path" | md5` 流儀と互換にするため（既存セッション名が変わらない）。
session_hash() {
  local out
  if command -v md5 >/dev/null 2>&1; then
    out="$(printf '%s\n' "$1" | md5 -q)"
  elif command -v md5sum >/dev/null 2>&1; then
    out="$(printf '%s\n' "$1" | md5sum)"
  else
    out="$(printf '%s\n' "$1" | shasum)"
  fi
  printf '%s' "${out%% *}" | cut -c1-8
}

# file_mtime <path>
# 最終更新の epoch 秒。BSD stat (macOS) を先に試し、GNU stat にフォールバック。
file_mtime() {
  stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null
}

# claude_transcript_mtime <session-id>
# その Claude セッションの transcript への最終書き込み時刻 = 最後に何かした時刻。
# `claude agents --json` は startedAt しか返さないので transcript の mtime で代用。
# パスは Claude Code の内部実装なので glob で探す。見つからなければ空（age は '-'）。
claude_transcript_mtime() {
  local base f
  base="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  for f in "$base"/projects/*/"$1".jsonl; do
    [ -f "$f" ] && {
      file_mtime "$f"
      return
    }
  done
}
