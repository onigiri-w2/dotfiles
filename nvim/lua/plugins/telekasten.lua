-- https://github.com/nvim-telekasten/telekasten.nvim?tab=readme-ov-file#base-setup

return {
	"renerocksai/telekasten.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	lazy = false,
	enabled = false,
	config = function()
		require("telekasten").setup({
			home = vim.fn.expand("~/zettelkasten"),
		})
		-- telekasten ファイルを markdown として扱うための設定
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "telekasten",
			callback = function()
				-- ファイルタイプを markdown に設定
				vim.bo.filetype = "markdown"

				-- Tree-sitter パーサーの設定
				vim.treesitter.language.register("markdown", "telekasten")

				-- フォールディングをより安定した方法に設定
				vim.opt_local.foldmethod = "indent"
			end,
		})
	end,
}
