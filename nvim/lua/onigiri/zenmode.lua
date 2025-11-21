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
			vim.o.relativenumber = not zen_enabled
			vim.o.showtabline = zen_enabled and 0 or 2
		end,
	})
end

M.toggle = function()
	M.is_active = not M.is_active

	-- lualine の存在チェック（グレースフルデグレード）
	-- lualine がなくても Zen モードの基本機能（行番号・タブライン非表示）は動作する
	-- ステータスライン非表示は lualine がある場合のみ有効
	local ok, lualine = pcall(require, "lualine")

	if M.is_active then
		vim.o.number = false
		vim.o.relativenumber = false
		vim.o.showtabline = 0
		if ok then
			lualine.hide({ unhide = false, place = { "statusline" } })
		end
		setup_buffer_settings(true)
		vim.notify("ZenMode On")
	else
		vim.o.number = true
		vim.o.relativenumber = true
		vim.o.showtabline = 2
		if ok then
			lualine.hide({ unhide = true, place = { "statusline" } })
		end
		setup_buffer_settings(false)
		vim.notify("ZenMode Off")
	end
end

return M
