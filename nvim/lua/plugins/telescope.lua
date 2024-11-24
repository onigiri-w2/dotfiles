return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						n = {
							["<C-c>"] = actions.close,
							["<C-d>"] = actions.delete_buffer,
						},
						i = {
							["<C-c>"] = actions.close,
							["<C-d>"] = actions.delete_buffer,
						},
					},
					layout_config = {
						prompt_position = "top",
					},
					sorting_strategy = "ascending",
				},
				pickers = {
					buffers = {
						sort_mru = true,
						sort_lastused = true,
						previewer = false,
					},
				},
			})
		end,
	},
}
