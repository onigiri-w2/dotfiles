-- Copilot: インライン補完のみ使用
-- blink.cmp 連携は options.lua の vim.g.ai_cmp = false で無効化

return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				auto_trigger = true,
				hide_during_completion = false,
				keymap = {
					accept = false, -- Tab キーで独自処理。後述のkeysで設定。
					next = false,
					prev = false,
				},
			},
			panel = { enabled = false },
		},
		keys = {
			-- 提案があれば accept、なければ通常 Tab
			{
				"<Tab>",
				function()
					local suggestion = require("copilot.suggestion")
					if suggestion.is_visible() then
						suggestion.accept()
					else
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
					end
				end,
				mode = "i",
				desc = "Copilot accept or Tab",
			},
		},
	},
}
