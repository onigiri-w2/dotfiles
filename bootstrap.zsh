# bootstrap.zsh
# .zshrc から source される唯一のファイル
DOTFILES="${0:A:h}"

source "$DOTFILES/shell.zsh"

# 1. zinit を先に初期化
source "$DOTFILES/features/zinit/shell.zsh"

# 2. 残りの features を読み込み
for feature in "$DOTFILES/features/"*/; do
    [[ "$feature" == *"/zinit/" ]] && continue  # zinit はスキップ
    if [[ -f "$feature/zinit.zsh" ]]; then
        source "$feature/zinit.zsh"
    fi
    if [[ -f "$feature/shell.zsh" ]]; then
        source "$feature/shell.zsh"
    fi
done
