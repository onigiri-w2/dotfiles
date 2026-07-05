local M = {}
-- Zen mode の状態を保持
M.is_active = false

-- Autocmdのグループを作成
local augroup = vim.api.nvim_create_augroup("ZenMode", { clear = true })

-- zen 中のみ、バッファ切り替えでも行番号・タブラインを隠し続ける autocmd を張る。
-- zen off 時はこの augroup を丸ごと clear するだけ（復帰用 autocmd は残さない）。
-- 通常時の number/relativenumber/showtabline は options.lua が持つのでここでは触らない。
local function apply_zen_autocmd()
	vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufWinEnter" }, {
		group = augroup,
		callback = function()
			vim.o.number = false
			vim.o.relativenumber = false
			vim.o.showtabline = 0
		end,
	})
end

M.toggle = function()
	M.is_active = not M.is_active

	if M.is_active then
		vim.o.number = false
		vim.o.relativenumber = false
		vim.o.showtabline = 0
		apply_zen_autocmd()
		vim.notify("ZenMode On")
	else
		-- zen 用 autocmd を消してから、options.lua の通常設定へ戻す
		vim.api.nvim_clear_autocmds({ group = augroup })
		vim.o.number = true
		vim.o.relativenumber = false
		vim.o.showtabline = 2
		vim.notify("ZenMode Off")
	end
end

return M
