-- LazyVim の wrap/spell 自動設定を無効化（日本語メインなので不要）
-- see: https://github.com/LazyVim/LazyVim/blob/c64a617/lua/lazyvim/config/autocmds.lua#L97-L105
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
