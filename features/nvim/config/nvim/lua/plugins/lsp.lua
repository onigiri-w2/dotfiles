return {
	-- Mason: LSP/フォーマッター/リンターのインストーラー
	{
		"mason.nvim",
		keys = {
			{ "<leader>cm", false },
			{ "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = {
			ensure_installed = { "rust-analyzer", "gopls" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			--------------------------------------------------
			-- vtsls
			--------------------------------------------------
			if opts.servers.vtsls then
				opts.servers.vtsls.keys = vim.tbl_map(function(key)
					if key[1] == "<leader>cM" then
						key[1] = "<leader>cm"
					end
					return key
				end, opts.servers.vtsls.keys or {})
			end

			local orig_on_attach = opts.servers.vtsls and opts.servers.vtsls.on_attach
			if not opts.servers.vtsls then
				opts.servers.vtsls = {}
			end
			opts.servers.vtsls.on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				if orig_on_attach then
					orig_on_attach(client, bufnr)
				end
			end

			--------------------------------------------------
			-- gopls
			--------------------------------------------------
			if not opts.servers.gopls then
				opts.servers.gopls = {}
			end

			opts.servers.gopls.settings = vim.tbl_deep_extend("force", opts.servers.gopls.settings or {}, {
				gopls = {
					buildFlags = { "-tags=integration" },
				},
			})

			return opts
		end,
	},
}
