# Claude Code CLI: native installer に統一（brew cask は使わない）
# 既に claude があれば何もしない（冪等）。
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# .claude/skills を ~/.claude 内にシンボリックリンク（冪等）
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.claude"
skills_src="$SCRIPT_DIR/.claude/skills"
skills_dst="$HOME/.claude/skills"
if [[ -L "$skills_dst" || ! -e "$skills_dst" ]]; then
  # 未作成、または既にシンボリックリンク → 貼り直し（冪等）
  ln -sfn "$skills_src" "$skills_dst"
else
  # 実ファイル/ディレクトリが居座っている → 上書きせず警告（手動対応）
  echo "⚠️  $skills_dst が symlink でないためスキップしました（中身を確認して手動で対応してください）"
fi

# 自作スクリプト群を ~/.claude/scripts にディレクトリごと symlink（skills と同じ方式）。
# 今後スクリプトを増やしても config/scripts/ に置くだけでよく、install.zsh の編集は不要。
scripts_src="$SCRIPT_DIR/config/scripts"
scripts_dst="$HOME/.claude/scripts"
chmod +x "$scripts_src"/*.sh
if [[ -L "$scripts_dst" || ! -e "$scripts_dst" ]]; then
  ln -sfn "$scripts_src" "$scripts_dst"
else
  echo "⚠️  $scripts_dst が symlink でないためスキップしました（中身を確認して手動で対応してください）"
fi

# statusLine: 入力欄の下にモデル名 + コンテキスト使用率を表示（冪等）。
# 設定を ~/.claude/settings.json にマージ（excludesfile と同じ「マージ生成」方式）。
# settings.json 実体は手動管理なので、上書きせず statusLine キーだけ差し込む。
settings="$HOME/.claude/settings.json"
[[ -f "$settings" ]] || echo '{}' > "$settings"
tmp="$(mktemp)"
if jq --arg cmd "$scripts_dst/statusline.sh" \
      '.statusLine = {type: "command", command: $cmd, padding: 2}' \
      "$settings" > "$tmp"; then
  mv "$tmp" "$settings"
else
  rm -f "$tmp"
  echo "⚠️  $settings への statusLine マージに失敗しました（jq を確認してください）"
fi

# adblue プロジェクトの .claude/settings.json を dotfiles 管理下に置く（symlink）。
# adblue は git 側で **/.claude が無視されるためリポジトリにコミットできない。
# checkout されているマシンでのみ symlink（他マシンでは skip・冪等）。
adblue_claude="$HOME/projects/adblue/.claude"
adblue_src="$SCRIPT_DIR/config/adblue-settings.json"
adblue_dst="$adblue_claude/settings.json"
if [[ -d "$adblue_claude" ]]; then
  if [[ -L "$adblue_dst" || ! -e "$adblue_dst" ]]; then
    ln -sfn "$adblue_src" "$adblue_dst"
  else
    # 実ファイルが居座っている → dotfiles と差分が無ければ symlink に置換、あれば警告
    if diff -q "$adblue_src" "$adblue_dst" >/dev/null 2>&1; then
      ln -sfn "$adblue_src" "$adblue_dst"
    else
      echo "⚠️  $adblue_dst が dotfiles と差分ありのため置換をスキップしました（手動で確認してください）"
    fi
  fi
fi
