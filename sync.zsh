#!/bin/zsh

# dotfiles 同期: 既存マシンに新しい install を反映させる
# 使い方: ./sync.zsh
#
# setup.zsh との違い:
# - Homebrew 自体のインストールは行わない（既に入っている前提）
# - macOS defaults 適用は行わない
# - .zshrc への bootstrap 追記は行わない

DOTFILES="${0:A:h}"

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not installed. Run ./setup.zsh first."
    exit 1
fi

for feature in "$DOTFILES/features/"*/; do
    [[ -f "$feature/install.zsh" ]] && source "$feature/install.zsh"
done

echo "Sync done!"
