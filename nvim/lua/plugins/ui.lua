return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "storm",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				callback = function()
					require("lualine").hide()
				end,
			})
		end,
	},
}
