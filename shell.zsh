# shell.zsh
# グローバルなシェル環境設定

# ============================================
# Homebrew
# ============================================

eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================
# Options
# ============================================

# History
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

setopt inc_append_history   # 実行時に履歴をファイルに追加
setopt share_history        # 履歴を他のシェルとリアルタイム共有
setopt hist_ignore_dups     # 重複実行を記録しない

# ============================================
# Environment
# ============================================

export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
export KEYTIMEOUT=1  # vim の escape 対策

# ユーザ配下のバイナリ置き場。特定 feature のものではないのでここに置く。
# features/claude が claude を、features/lang-python の uv が python を入れる。
export PATH="$HOME/.local/bin:$PATH"

# ============================================
# Alias
# ============================================

# 基本
alias cl='clear'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'

# dotfiles
alias cddot='cd $DOTFILES'

# zsh
alias zshedit='vim ~/.zshrc'
alias zshreload='source ~/.zshrc'
