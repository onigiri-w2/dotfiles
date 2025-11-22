# bootstrap.zsh
# .zshrc から source される唯一のファイル

DOTFILES="${0:A:h}"  # このファイルの親 = dotfiles/

# グローバル shell 読み込み
source "$DOTFILES/shell.zsh"

# features の shell 読み込み
for feature in "$DOTFILES/features/"*/; do
    [[ -f "$feature/shell.zsh" ]] && source "$feature/shell.zsh"
done
