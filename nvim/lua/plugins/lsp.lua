return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.inlay_hints = { enabled = false }
			opts.servers.lua_ls = {}

			-- vtsls のキーマッピング変更
			if opts.servers.vtsls then
				opts.servers.vtsls.keys = vim.tbl_map(function(key)
					if key[1] == "<leader>cM" then
						key[1] = "<leader>cm"
					end
					return key
				end, opts.servers.vtsls.keys or {})
			end

			return opts
		end,
	},
}
