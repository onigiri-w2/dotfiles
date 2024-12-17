-- ~/.config/nvim/lua/plugins/icons.lua
return {
	"echasnovski/mini.icons",
	config = function()
		require("mini.icons").setup({
			extension = {
				["test.ts"] = { glyph = "", hl = "MiniIconsOrange" },
				["test.js"] = { glyph = "", hl = "MiniIconsOrange" },
				["spec.ts"] = { glyph = "", hl = "MiniIconsOrange" },
				["spec.js"] = { glyph = "", hl = "MiniIconsOrange" },
			},
		})
	end,
}
