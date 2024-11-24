-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "json", "jsonc", "markdown" },
-- 	callback = function()
-- 		vim.opt.conceallevel = 0
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function(event)
-- 		vim.schedule(function()
-- 			require("noice.text.markdown").keys(event.buf)
-- 		end)
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "markdown", "txt" },
-- 	callback = function()
-- 		vim.opt_local.spell = false
-- 	end,
-- })

-- zenmode
vim.api.nvim_create_user_command("ZenMode", function()
	-- 行番号を非表示
	vim.opt.number = false
	-- vim.opt.relativenumber = false
	-- lualineを非表示
	require("lualine").hide()
end, {
	desc = "Enable Zen mode (hide numbers and statusline)",
})

vim.api.nvim_create_user_command("ZenModeOff", function()
	-- 行番号を表示（LazyVimのデフォルトに戻す）
	vim.opt.number = true
	-- vim.opt.relativenumber = true
	-- lualineを表示
	require("lualine").hide({ unhide = true })
end, {
	desc = "Disable Zen mode (show numbers and statusline)",
})
