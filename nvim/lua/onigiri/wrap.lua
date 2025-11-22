local M = {}

M.toggle = function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Wrap: " .. (vim.wo.wrap and "Enabled" or "Disabled"))
end

return M
