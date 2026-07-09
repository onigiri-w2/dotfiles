# git を このPCにインストール & setup する
# 1回だけ実行

# Install
brew install git
brew install gh
brew install git-delta # git diff 用のシンタックスハイライトpager（.gitconfig の core.pager）

# Setup: config をリンク
SCRIPT_DIR="${0:A:h}"
ln -sf "$SCRIPT_DIR/config/.gitconfig" "$HOME/.gitconfig"

# ~/.gitignore_global はマシン所有の実ファイル（symlink にしない）。
# マシン固有の無視パターンはこのファイルに直接追記してよく、git は excludesfile を
# 毎コマンド読み直すので即反映される（dotfiles リポジトリも汚れない）。
# install/sync 時は共有パターンの不足分だけを追記するマージ方式で、
# 手で足した行は消えない。共有側から消したパターンが各マシンに残るのは
# 「uninstall は自動化しない」方針の割り切り。
# 既存が symlink（旧方式）なら実ファイル化のため一度外す。
# ※ /bin/rm 直指定: このマシンの safe-chain 等が rm をラップして失敗すると、
#   symlink 越しに追跡ファイル本体を壊す事故につながるため。
[[ -L "$HOME/.gitignore_global" ]] && /bin/rm "$HOME/.gitignore_global"
touch "$HOME/.gitignore_global"
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  grep -qxF -- "$line" "$HOME/.gitignore_global" || print -r -- "$line" >> "$HOME/.gitignore_global"
done < "$SCRIPT_DIR/config/.gitignore_global"
