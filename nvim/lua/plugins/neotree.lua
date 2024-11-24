return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		lazy = true,
		cmd = "Neotree",
		opts = {
			enable_diagnostics = true,
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				case_sensitive = true,
				commands = {
					-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/202
					-- over write default 'delete' command to 'trash'.
					delete = function(state)
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

					-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/202
					-- over write default 'delete_visual' command to 'trash' x n.
					delete_visual = function(state, selected_nodes)
						local inputs = require("neo-tree.ui.inputs")

						-- get table items count
						function GetTableLen(tbl)
							local len = 0
							for _ in pairs(tbl) do
								len = len + 1
							end
							return len
						end

						local count = GetTableLen(selected_nodes)
						local msg = "Are you sure you want to trash " .. count .. " files ?"
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
						-- Change '?' to a more intuitive icon or text
						untracked = "?", -- or you could use "New" or any other Unicode character
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
						-- ファイルが開かれたらneo-treeを閉じる
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		},
	},
}
