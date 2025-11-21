-- 追加の treesitter パーサー（LazyVim デフォルト: js, ts, python, lua, json, markdown 等）
-- see: see: https://www.lazyvim.org/plugins/treesitter
-- パーサー一覧: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"css",
				"zsh",
				"gitignore",
				"go",
				"graphql",
				"http",
				"rust",
				"scss",
				"sql",
			},
		},
	},
}
