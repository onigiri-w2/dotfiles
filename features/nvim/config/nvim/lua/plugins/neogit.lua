-- lazygit (<leader>gg) の代替候補として試す、Magit風のフル git クライアント。
-- 気に入らなければこのファイルを削除するだけで無効化できる。
return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
	},
	cmd = "Neogit",
	keys = {
		{
			"<leader>gn",
			function()
				require("neogit").open()
			end,
			desc = "Neogit",
		},
	},
	opts = {
		integrations = {
			diffview = true,
		},
	},
}
