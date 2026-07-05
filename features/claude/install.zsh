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
