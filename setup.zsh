#!/bin/zsh

# dotfiles セットアップ
# 使い方: ./setup.zsh

# zsh 専用（${0:A:h} 等を使う）。sh 等で実行されたら明示的に弾く。
if [ -z "$ZSH_VERSION" ]; then
  echo "setup.zsh は zsh で実行してください: ./setup.zsh（または zsh setup.zsh）" >&2
  exit 1
fi

DOTFILES="${0:A:h}"

# Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew 全体の設定を dotfiles 管理下に置く（brew bundle install より前に必要）。
# シェルを介さないので、対話シェルでも setup.zsh 内でも同じ設定が効く。
mkdir -p "$HOME/.homebrew"
ln -sf "$DOTFILES/config/brew.env" "$HOME/.homebrew/brew.env"

# 全 feature の Brewfile を連結して brew パッケージを導入。
# install.zsh より先に走らせる（install.zsh は jq / goenv / mise 等に依存するため）。
# --no-upgrade: 従来の `brew install`（既にあれば何もしない）の挙動を保つ。
# bundle は既定で outdated を upgrade するが、更新は `brew upgrade` で明示的にやりたい。
cat "$DOTFILES/features/"*/Brewfile | brew bundle install --no-upgrade --quiet --file=-

# 全 features インストール
for feature in "$DOTFILES/features/"*/; do
    [[ -f "$feature/install.zsh" ]] && source "$feature/install.zsh"
done

# platform 設定
[[ "$(uname)" == "Darwin" ]] && source "$DOTFILES/platform/macos.zsh"

# .zshrc に bootstrap を追加
grep -q "bootstrap.zsh" ~/.zshrc 2>/dev/null || echo "source $DOTFILES/bootstrap.zsh" >> ~/.zshrc

echo "Done!"
