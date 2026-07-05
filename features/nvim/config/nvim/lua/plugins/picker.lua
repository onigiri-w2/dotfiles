return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				matcher = {
					-- 全 picker (grep 含む) で「よく開くファイル」のマッチをスコアブースト。
					-- item.file を持つ結果全てに効くので grep の行マッチも対象になる。
					frecency = true,
				},
			},
		},
		keys = {
			-- LazyVim デフォルトの <leader><space> (素の Find Files) を smart picker に差し替え。
			-- buffers + recent + files を frecency 順でマージするので、よく開くファイルが上位に出る。
			{
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
		},
	},
}
