return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false }, -- これは良い設定ですね
			servers = {
				lua_ls = {},
			},
		},
	},
}
