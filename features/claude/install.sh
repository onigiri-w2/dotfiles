brew install --cask claude

# Setup: .claudeの中身を~/.claude 内にシンボリックリンク
SCRIPT_DIR="${0:A:h}"
mkdir -p "$HOME/.claude"
ln -sf "$SCRIPT_DIR/claude/skills" "$HOME/.claude/skills"
