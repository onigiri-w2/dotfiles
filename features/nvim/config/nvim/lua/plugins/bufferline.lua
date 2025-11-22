-- bufferが1つのときでもbufferlineを表示したい
return {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				always_show_bufferline = true,
			},
		},
	},
}
