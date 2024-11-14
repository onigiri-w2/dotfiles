# bootstrap.zsh

# set PATH for zsh
export PATH="${0:A:h}/bin:$PATH"

################################
# zinitのインストールと初期化
################################
# Install zinit if not exists
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} Installing zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi
# Initialize zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && *comps[zinit]=*zinit

# plugin読み込み
for file in ${0:a:h}/plugins/*.zsh; do
    source $file
done


################################
# core設定を読み込む
################################
for file in ${0:a:h}/core/env/*.zsh; do
    source $file
done
for file in ${0:a:h}/core/alias/*.zsh; do
    source $file
done


################################
# local設定を読み込む
################################
source ${0:a:h}/local.zsh

