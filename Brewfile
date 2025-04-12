# カレントディレクトリの.netrc_*ファイルを確認
netrc_files=(.netrc_*(N))

# カレントディレクトリに無い場合はホームディレクトリを確認
if [ ${#netrc_files} -eq 0 ]; then
    netrc_files=(~/.netrc_*(N))
fi

if [ ${#netrc_files} -eq 0 ]; then
    echo "Error: .netrc_* ファイルが見つかりません。"
    return 1
fi

# pecoで選択させる
selected=$(print -l ${netrc_files[@]} | peco)

if [ -z "$selected" ]; then
    echo "ファイルが選択されていません。"
    return 1
fi

# 選択されたファイルをホームディレクトリの.netrcにコピー
if [ -f "$selected" ]; then
    cp "$selected" ~/.netrc
    echo "$selected を ~/.netrc にコピーしました。"
else
    echo "Error: 選択されたファイルが存在しません。"
    return 1
fi
# --------------------- #
# cmd tools
# --------------------- #
cask "kitty"
brew "peco"
brew "tree"
brew "git"
brew "nvim"
brew "ripgrep"
brew "fd"
brew "lazygit"
brew "trash"
brew "tmux"
brew "tmuxinator"

# --------------------- #
# python
# --------------------- #
brew "pyenv"
brew "pyenv-virtualenv"
brew "poetry"

# --------------------- #
# volta
# --------------------- #
brew volta


# --------------------- #
# react native
# --------------------- #
brew "watchman"

# --------------------- #
# fonts
# --------------------- #
font-monaspace-nerd-font

# --------------------- #
# browser
# --------------------- #
cask "arc"

# --------------------- #
# Mac tools
# --------------------- #
cask "rectangle"
cask "alfred"
cask "clipy"
cask "karabiner-elements"
cask "postman"
cask "selfcontrol"
cask "hammerspoon"
cask "hyperkey"
cask "alt-tab"

