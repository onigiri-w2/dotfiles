local M = {}
-- Zen mode の状態を保持
M.is_active = false

-- Autocmdのグループを作成
local augroup = vim.api.nvim_create_augroup("ZenMode", { clear = true })

-- バッファ切り替え時の設定を管理する関数
local function setup_buffer_settings(zen_enabled)
	vim.api.nvim_clear_autocmds({ group = augroup })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufWinEnter" }, {
		group = augroup,
		callback = function()
			vim.o.number = not zen_enabled
			vim.o.showtabline = zen_enabled and 0 or 2
		end,
	})
end

M.toggle = function()
	M.is_active = not M.is_active
	if M.is_active then
		-- Zen mode ON
		vim.o.number = false
		vim.o.showtabline = 0
		require("lualine").hide({ unhide = false, place = { "statusline" } })
		setup_buffer_settings(true)
		vim.notify("ZenMode On")
	else
		-- Zen mode OFF
		vim.o.number = true
		vim.o.showtabline = 2
		require("lualine").hide({ unhide = true, place = { "statusline" } })
		setup_buffer_settings(false)
		vim.notify("ZenMode On")
	end
end

return M
