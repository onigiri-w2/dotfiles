# このscriptのpathを取得
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# 各setupを実行
# source $SCRIPT_DIR/setup_homebrew.zsh
source $SCRIPT_DIR/setup_settings.zsh
source $SCRIPT_DIR/setup_volta.zsh
source $SCRIPT_DIR/setup_hammerspoon.zsh
source $SCRIPT_DIR/setup_wezterm.zsh
source $SCRIPT_DIR/setup_tmux.zsh
