-- tmux 内では tmux 側の status bar と重なって邪魔なので、tmux 内でだけ無効化。
return {
	{
		"nvim-lualine/lualine.nvim",
		enabled = vim.env.TMUX == nil,
	},
}
