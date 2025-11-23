return {
	-- Mason: LSP/フォーマッター/リンターのインストーラー
	{
		"mason.nvim",
		keys = {
			{ "<leader>cm", false },
			{ "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = {
			ensure_installed = { "rust-analyzer" },
		},
	},

	-- LSP: vtsls のキーマップ変更
	-- LazyVim の vtsls.keys 配列内の特定キーだけ変更するため、opts 関数で動的に書き換え
	-- 全体の上書きではなく、既存の設定を保持しつつ一部だけ変更する形にしている
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			-- vtsls のキーマップ変更
			if opts.servers.vtsls then
				opts.servers.vtsls.keys = vim.tbl_map(function(key)
					if key[1] == "<leader>cM" then
						key[1] = "<leader>cm"
					end
					return key
				end, opts.servers.vtsls.keys or {})
			end

			-- eslint, prettier のフォーマットを優先するためにTypeScript/JavaScript の LSP フォーマット無効化
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

			return opts
		end,
	},
}
