# zoxide 初期化（cd の代わりに z が使えるようになる）
eval "$(zoxide init zsh)"
# zinit が zi エイリアスを先に定義するため、zoxide の zi (interactive jump) で上書き
unalias zi 2>/dev/null; alias zi='__zoxide_zi'

# Ctrl+F で zoxide + fzf のインタラクティブ検索
function zoxide_fzf_widget() {
  local dir
  dir=$(zoxide query -l 2>/dev/null | fzf --height 40% --reverse --header="Jump to directory")

  if [[ -n "$dir" ]]; then
    zoxide add "$dir"
    cd "$dir" || return
    zle reset-prompt
  fi
}

zle -N zoxide_fzf_widget
bindkey '^f' zoxide_fzf_widget
