-- TODO: ちゃんと初期からinstallすべきlanguage serverを指定する。
-- TODO: ちゃんと勉強して、的確な設定を行う。
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false }, -- これは良い設定ですね
		},
	},
}
