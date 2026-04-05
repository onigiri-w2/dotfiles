return {
	-- Mason: LSP/フォーマッター/リンターのインストーラー
	{
		"mason.nvim",
		keys = {
			{ "<leader>cm", false },
			{ "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = {
			ensure_installed = {
				-- "bacon",
				-- "bacon-ls",
			},
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

			-- =========================
			-- LuaLS 設定（重要）
			-- =========================
			opts.servers.lua_ls = opts.servers.lua_ls or {}
			opts.servers.lua_ls.settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" }, -- ← vim設定コード警告対策
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME, -- ← Neovim API 補完強化
						},
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			}

			-- -- Neovim 0.11はworkspace/diagnostic/refreshに未対応のため、ハンドラを自前で登録
			-- vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
			-- 	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			-- 		local clients = vim.lsp.get_clients({ bufnr = bufnr, id = ctx.client_id })
			-- 		if #clients > 0 then
			-- 			vim.lsp.buf_request(bufnr, "textDocument/diagnostic", {
			-- 				textDocument = vim.lsp.util.make_text_document_params(bufnr),
			-- 			})
			-- 		end
			-- 	end
			-- 	return vim.NIL
			-- end
			--
			-- -- publishDiagnostics受信時にvirtual textの再描画を強制する
			-- -- Neovim 0.11でdiagnosticデータ更新後にvirtual textがクリアされないバグへの対処
			-- local orig_publish_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
			-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
			-- 	orig_publish_handler(err, result, ctx, config)
			-- 	vim.schedule(function()
			-- 		local bufnr = vim.uri_to_bufnr(result.uri)
			-- 		if vim.api.nvim_buf_is_loaded(bufnr) then
			-- 			vim.diagnostic.show(nil, bufnr)
			-- 		end
			-- 	end)
			-- end

			return opts
		end,
	},
}
