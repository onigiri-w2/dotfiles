return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "buffers",
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)

		-- showtablineを常に0に保つ
		-- vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "TabEnter" }, {
		-- 	callback = function()
		-- 		vim.opt.showtabline = 0
		-- 	end,
		-- })
	end,
}
