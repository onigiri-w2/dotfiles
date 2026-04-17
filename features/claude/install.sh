# Claude Code CLI (native installer)
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

# Setup: .claude/skills を ~/.claude 内にシンボリックリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.claude"
ln -sfn "$SCRIPT_DIR/.claude/skills" "$HOME/.claude/skills"
