# docker を このPCにセットアップする
#
# Docker Desktop（GUIアプリ）を毎回開かないと daemon が立ち上がらないのが
# だるいので、colima（ヘッドレス VM）+ 素の docker CLI に置き換える。
# colima は brew services でログイン時に自動起動するため、GUI を手動で
# 開く操作自体が不要になる。
# パッケージは Brewfile を参照。

# docker 系 formula の bin を Docker Desktop 由来の symlink より優先させる
# （既に symlink があると brew は警告して link をスキップするため）
brew link --overwrite docker docker-compose docker-buildx

# docker compose / buildx を CLI プラグインとして認識させる + credsStore を
# Docker Desktop 非依存の osxkeychain に切替（既存の設定は壊さずマージ）
mkdir -p ~/.docker
jq '.cliPluginsExtraDirs = ["/opt/homebrew/lib/docker/cli-plugins"] | .credsStore = "osxkeychain"' \
	~/.docker/config.json >~/.docker/config.json.tmp 2>/dev/null ||
	echo '{"cliPluginsExtraDirs":["/opt/homebrew/lib/docker/cli-plugins"],"credsStore":"osxkeychain"}' >~/.docker/config.json.tmp
mv ~/.docker/config.json.tmp ~/.docker/config.json

# colima をバックグラウンドサービス化してログイン時に自動起動させる
# `brew services` は TMUX 環境変数が立っていると「tmux 内では実行不可」と
# して拒否する（tmux 内で実行してこの制約に一度ハマった）ため、
# env -u TMUX で一時的に隠して実行する。
env -u TMUX brew services start colima

# 旧 Docker Desktop アプリが残っていれば削除を試みる（daemon の二重管理を
# 避けるため）。ただし管理者権限が無いアカウントでは cask uninstall が
# 失敗する（正常）。その場合はアプリを起動しなければ colima と共存でき、
# 必須の後片付けではないので失敗しても無視してよい。
if [ -d "/Applications/Docker.app" ]; then
	osascript -e 'quit app "Docker Desktop"' 2>/dev/null
	brew uninstall --cask docker 2>/dev/null ||
		echo "Docker Desktop の削除は管理者権限が要るためスキップ（起動しなければ問題なし）"
fi
