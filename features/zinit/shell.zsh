# zinit 初期化 + プラグイン
# シェル起動時に毎回読み込む

# 初期化
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# プラグイン
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/history-search-multi-word

# pure theme
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
