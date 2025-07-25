return {
	{
		"mason.nvim",
		keys = {
			{ "<leader>cm", false },
			{ "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" }, -- 大文字Mに変更
		},
		opts = {
			ensure_installed = {
				"rust-analyzer",
			},
		},
	},
}
