# fd + fzf で現在のディレクトリ以下に爆速移動
function fd_jump() {
    # fd でディレクトリのみをリストアップし、fzf で選択
    local dir=$(fd --type d --hidden --exclude .git . | fzf --height 40% --reverse --header="Jump to child directory")
    
    if [ -n "$dir" ]; then
        cd "$dir"
        zle reset-prompt
    fi
}

# ディレクトリ移動版 (ff = find folder)
alias ff='cd "$(fd --type d --hidden --exclude .git | fzf --height 40% --reverse --header="Select Directory")"'

# ファイルをエディタで開く版 (fv = find vimmer/view)
alias fv='${EDITOR:-code} "$(fd --type f --hidden --exclude .git | fzf --height 40% --reverse --header="Select File")"'
