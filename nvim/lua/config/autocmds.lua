vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" }, -- 対象のファイルタイプを指定
	callback = function()
		vim.opt_local.spell = false
	end,
})
