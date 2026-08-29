#!/bin/zsh

# dotfiles 同期: 既存マシンを dotfiles の宣言に合わせる
# 使い方: ./sync.zsh
#
# setup.zsh との違い:
# - Homebrew 自体のインストールは行わない（既に入っている前提）
# - macOS defaults 適用は行わない
# - .zshrc への bootstrap 追記は行わない
# - 宣言から外れたものの棚卸し（cleanup）を最後に提示する

# zsh 専用（${0:A:h} 等を使う）。sh 等で実行されたら明示的に弾く。
if [ -z "$ZSH_VERSION" ]; then
  echo "sync.zsh は zsh で実行してください: ./sync.zsh（または zsh sync.zsh）" >&2
  exit 1
fi

DOTFILES="${0:A:h}"

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not installed. Run ./setup.zsh first."
    exit 1
fi

# Homebrew 全体の設定を dotfiles 管理下に置く（brew bundle install より前に必要）。
# シェルを介さないので、対話シェルでも setup.zsh 内でも同じ設定が効く。
mkdir -p "$HOME/.homebrew"
ln -sf "$DOTFILES/config/brew.env" "$HOME/.homebrew/brew.env"

# 全 feature の Brewfile を連結したものが「このマシンにあるべき brew パッケージ」の宣言。
# install.zsh より先に走らせる（install.zsh は jq / goenv / mise 等に依存するため）。
# --no-upgrade: 従来の `brew install`（既にあれば何もしない）の挙動を保つ。
# bundle は既定で outdated を upgrade するが、更新は `brew upgrade` で明示的にやりたい。
BREWFILE="$(cat "$DOTFILES/features/"*/Brewfile)"
print -r -- "$BREWFILE" | brew bundle install --no-upgrade --file=-

for feature in "$DOTFILES/features/"*/; do
    [[ -f "$feature/install.zsh" ]] && source "$feature/install.zsh"
done

# --- cleanup 候補の提示（列挙のみ。消しはしない） ---
#
# formula は `brew leaves`（何にも依存されていないもの）だけに絞る。これが判断単位。
# `brew bundle cleanup` は依存も全部並べるので 100 件超の壁になって読めない。
# 親を消せば依存は次回の実行で leaves として浮上するので、繰り返せば収束する。
# cask は依存関係が無いので導入済み全件と宣言の差分でよい。
extra_brews=$(comm -23 \
    <(brew leaves | sort) \
    <(print -r -- "$BREWFILE" | brew bundle list --brews --file=- | sort))
extra_casks=$(comm -23 \
    <(brew list --cask | sort) \
    <(print -r -- "$BREWFILE" | brew bundle list --casks --file=- | sort))

# 消えた feature が残した dangling symlink（リンク先が無いもの）。
# feature の config は概ね ~/.config 直下に貼るのでそこだけ見る。
# ~/.hammerspoon 等の直貼りは対象外なので気になったら手で確認する。
dangling=$(find "$HOME/.config" -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null)

# 種別ごとに件数付きの見出しを出し、名前は column で格子に並べる。
# column はタブ埋めなのでタブ幅で崩れる。expand で実スペースに潰してから字下げする。
_cleanup_group() {
    [[ -z "$2" ]] && return
    print -P "  %F{75}$1%f %F{240}($(print -r -- "$2" | wc -l | tr -d ' '))%f"
    print -r -- "$2" | column -c 72 | expand | sed 's/^/    /'
    echo
}

echo
if [[ -z "$extra_brews$extra_casks$dangling" ]]; then
    print -P "%F{75}━━ cleanup 候補 ━━%f  なし"
else
    print -P "%F{75}━━ cleanup 候補 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%f"
    echo
    _cleanup_group cask    "$extra_casks"
    _cleanup_group formula "$extra_brews"
    _cleanup_group symlink "$dangling"
    print -P "  %F{240}dotfiles の宣言に無いものです。手で入れたか、消した feature の残骸か。%f"
    echo
    echo "    残す   features/local/Brewfile に1行足す（次回から出なくなる）"
    echo "    消す   brew uninstall [--cask] <name> → brew autoremove"
    [[ -n "$dangling" ]] && echo "           symlink は unlink <path>"
    echo
fi

echo "Sync done!"
