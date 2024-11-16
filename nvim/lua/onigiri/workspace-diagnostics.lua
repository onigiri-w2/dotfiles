-- テキトーに作ったから、バグある可能性大。まあ、YAGNIってことで許してほしい。
-- TODO: 性能が終わってると思われるので、カリカリにした方がいいですね。
local M = {}

M.options = {
	workspace_files = function()
		-- gitのルートディレクトリを取得
		local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		if not git_root or git_root == "" then
			print("Not a git repository or git command failed")
			return {}
		end

		-- 全てのファイル（tracked + untracked）を取得
		local all_files = vim.fn.systemlist("git ls-files --cached --others --exclude-standard")

		-- deleted状態のファイルを取得
		local deleted_files = vim.fn.systemlist("git ls-files --deleted")

		-- deletedファイルを除外
		local file_set = {}
		for _, file in ipairs(all_files) do
			file_set[file] = true
		end
		for _, file in ipairs(deleted_files) do
			file_set[file] = nil
		end

		-- 最終的なファイルリストを作成（絶対パス）
		local workspace_files = {}
		for file, _ in pairs(file_set) do
			table.insert(workspace_files, git_root .. "/" .. file)
		end

		return workspace_files
	end,
	lsp_client_name = "vtsls",
	extent_languageid_map = {
		ts = "typescript",
		tsx = "typescriptreact",
	},
}

-- fileの内容を取得する関数
local function get_file_content(file_path)
	local file = io.open(file_path, "r")
	if not file then
		error("Failed to open file: " .. file_path)
		return
	end
	local content = file:read("*all")
	file:close()
	return content
end

-- ファイルpathから、languageIdを取得する関数
local function get_language_id(file_path)
	local extension = file_path:match("^.+%.(.+)$")
	return M.options.extent_languageid_map[extension] or nil
end

local function get_lsp_client()
	for _, client in ipairs(vim.lsp.get_clients()) do
		if client.name == M.options.lsp_client_name then
			return client
		end
	end
	return nil
end

-- lspに1つのファイル情報を送りつける関数
local function send_to_lsp(file_path)
	local client = get_lsp_client()
	if client == nil then
		-- 使えるLSPクライアントが見つからない場合はエラー
		error("LSP client " .. M.options.lsp_client_name .. " is not active")
		return
	end

	local content = get_file_content(file_path)
	if content == nil then
		error("Failed to get content of file: " .. file_path)
		return
	end

	local language_id = get_language_id(file_path)
	if language_id == nil then
		-- 対応するlanguage_idが見つからない = 対応してない拡張子なので無視
		return
	end

	local params = {
		textDocument = {
			uri = vim.uri_from_fname(file_path),
			languageId = language_id,
			version = 0,
			text = content,
		},
	}
	client.notify("textDocument/didOpen", params)
end

-- メイン処理：診断を実行する関数
local function notify_workspace_to_lsp()
	local workspace_files = M.options.workspace_files() or {}
	for _, file_path in ipairs(workspace_files) do
		-- 非同期に実行して次のファイルを処理したほうがいい
		send_to_lsp(file_path)
	end
end

-- ファイルの変更保存/削除イベントを検知する関数
local function setup_file_watchers()
	-- ファイルが保存されたら、LSPに通知する
	vim.api.nvim_create_autocmd("BufWritePost", {
		-- typescript系だけ
		pattern = "*.{ts,tsx}",
		callback = function()
			notify_workspace_to_lsp()
		end,
	})
end

-- プラグインのセットアップ関数
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
	setup_file_watchers()
end

return M
