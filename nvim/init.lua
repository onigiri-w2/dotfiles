-- ┌─────────────────────────────────────────────────────────┐
-- │ ⚠️  この設定は macOS 専用です                           │
-- │ Linux/Windows では一部機能が動作しない可能性があります  │
-- │ (trash コマンド、zsh シェル等)                          │
-- └─────────────────────────────────────────────────────────┘

-- macOS チェック（警告のみ、処理は継続）
if vim.fn.has("mac") ~= 1 then
	vim.notify("Warning: この Neovim 設定は macOS 専用です", vim.log.levels.WARN)
end

-- lazy設定
require("config.lazy")
