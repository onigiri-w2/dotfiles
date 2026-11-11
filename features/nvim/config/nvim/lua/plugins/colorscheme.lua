return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "storm",
			transparent = true,
			-- transparent だと背景が WezTerm の #24283b になり、既定の LineNr (#3b4261) が溶けて見えないので明るくする
			on_highlights = function(hl, c)
				hl.LineNr = { fg = c.dark5 }
				hl.LineNrAbove = { fg = c.dark5 }
				hl.LineNrBelow = { fg = c.dark5 }
			end,
		},
	},
}
