#!/bin/zsh

# dotfiles セットアップ
# 使い方: ./setup.zsh

DOTFILES="${0:A:h}"

# Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 全 features インストール
for feature in "$DOTFILES/features/"*/; do
    [[ -f "$feature/install.zsh" ]] && source "$feature/install.zsh"
done

# platform 設定
[[ "$(uname)" == "Darwin" ]] && source "$DOTFILES/platform/macos.zsh"

# .zshrc に bootstrap を追加
grep -q "bootstrap.zsh" ~/.zshrc 2>/dev/null || echo "source $DOTFILES/bootstrap.zsh" >> ~/.zshrc

echo "Done!"
