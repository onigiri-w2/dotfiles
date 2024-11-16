return {
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local mapping = vim.tbl_deep_extend("force", {}, opts.mapping or {})

			-- TabとShift+Tabのマッピングを削除
			mapping["<Tab>"] = nil
			mapping["<S-Tab>"] = nil

			-- 新しいマッピングを設定
			opts.mapping = mapping
		end,
	},
	{
		"nvim-cmp",
		keys = function()
			-- keysフィールドを空にすることで、LazyVimのデフォルトのTab/S-Tabマッピングを無効化
			-- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/plugins/coding.lua#L86C1-L127C5
			-- どうやって見つけた？<cmd>imapの<Tab>を検索したら見つかった。
			return {}
		end,
	},
}
