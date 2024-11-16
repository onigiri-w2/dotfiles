-- TODO: tree-sitterをちゃんと勉強して、ハイライトを自由自在にカスタマイズする
-- TODO: tree-sitterで、必要な言語のハイライトを初期からちゃんと追加しておく。prismaとか。
return {
	{
		"maxmx03/solarized.nvim",
		lazy = false,
		priority = 1000,
		---@type solarized.config
		opts = {},
		config = function(_, opts)
			vim.o.termguicolors = true
			vim.o.background = "dark"
			require("solarized").setup(opts)
			-- vim.cmd.colorscheme("solarized")
		end,
	},
	{ "sainnhe/sonokai" },
	{ "sainnhe/edge" },
	{ "navarasu/onedark.nvim" },
	{
		-- 欲を言うなら...
		-- 定義した型は全て同じ色（オレンジ）に統一してほしい
		-- record型のフィールドの色はもう少し薄い青にしてほしい
		-- undefinedはbuitinの赤、もしくは、定義型のオレンジに合わせてほしい
		-- 関数/メソッドの色はもう黄色とかにしてほしい。
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		priority = 1000,
		lazy = false,
		opts = {
			specs = {
				all = {},
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "storm",
			on_colors = function(colors)
				-- ここで必要に応じて色を追加または変更できます
				colors.lightGreen = "#90ee90"
				colors.white = "#dddddd"
			end,
			on_highlights = function(hl, c)
				-- Neo-treeのハイライトをカスタマイズ
				hl.NeoTreeGitUntracked = { fg = c.white, bg = c.bg }
				hl.NeoTreeDirectoryIcon = { fg = c.sidebar_fg, bg = c.bg }
				hl.NeoTreeDirectoryName = { fg = c.sidebar_fg, bg = c.bg }
				hl.NeoTreeGitUntracked = { fg = c.blue5, bg = c.bg }
				hl.NeoTreeGitModified = { fg = c.yellow, bg = c.bg }
				hl.NeoTreeGitAdded = { fg = c.lightGreen, bg = c.bg }
				hl.NeoTreeGitStaged = { fg = c.lightGreen, bg = c.bg }
				hl.NeoTreeFileName = { fg = c.white, bg = c.bg }
				hl.NeoTreeDiagnosticError = { fg = c.red1, bg = c.bg }
			end,
		},
	},
}
