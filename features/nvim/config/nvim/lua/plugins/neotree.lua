-- macOS 専用: trash コマンドの存在確認 (brew install trash)
local function check_trash_command()
	if vim.fn.executable("trash") ~= 1 then
		vim.notify("neo-tree: 'trash' command not found. Install it with 'brew install trash'", vim.log.levels.ERROR)
		return false
	end
	return true
end

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		init = function()
			-- gitignored のファイルを薄い色で表示するよう変更
			vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#6c6c6c" })
		end,
		opts = {
			enable_diagnostics = true,
			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						"node_modules",
						".cache",
						".git",
					},
				},
				case_sensitive = true,
				commands = {
					-- delete を trash コマンドで上書き
					-- see: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/202
					delete = function(state)
						if not check_trash_command() then
							return
						end

						local inputs = require("neo-tree.ui.inputs")
						local path = state.tree:get_node().path
						local msg = "Are you sure you want to trash " .. path
						inputs.confirm(msg, function(confirmed)
							if not confirmed then
								return
							end
							vim.fn.system({ "trash", vim.fn.fnameescape(path) })
							require("neo-tree.sources.manager").refresh(state.name)
						end)
					end,

					-- delete_visual を trash コマンドで上書き（複数選択用）
					delete_visual = function(state, selected_nodes)
						if not check_trash_command() then
							return
						end

						local inputs = require("neo-tree.ui.inputs")
						local count = #selected_nodes
						local msg = "Are you sure you want to trash " .. count .. " files?"
						inputs.confirm(msg, function(confirmed)
							if not confirmed then
								return
							end
							for _, node in ipairs(selected_nodes) do
								vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
							end
							require("neo-tree.sources.manager").refresh(state.name)
						end)
					end,
				},
			},
			window = {
				position = "float",
				width = 40,
				mappings = {
					["u"] = "navigate_up",
				},
			},
			default_component_configs = {
				git_status = {
					symbols = {
						untracked = "?",
						ignored = "",
						unstaged = "✗",
						staged = "✓",
						conflict = "!",
					},
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						-- ファイルが開かれたら neo-tree を閉じる
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		},
	},
}
