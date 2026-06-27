local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- マシン固有の local override をロード（git 管理外、無ければ無視）。
-- lazy.setup の前に読むことで、下のフラグ分岐に間に合う。
-- 例: local.lua に `vim.g.enable_codeium = false` でこの PC だけ Codeium を無効化。
pcall(require, "config.local")

local spec = {
	{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

	{ import = "lazyvim.plugins.extras.test.core" },
	{ import = "lazyvim.plugins.extras.dap.core" },
	{ import = "lazyvim.plugins.extras.lang.rust" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },
	{ import = "lazyvim.plugins.extras.lang.go" },
}

-- Codeium はデフォルト有効。local.lua で明示的に false にしたマシンだけ無効。
if vim.g.enable_codeium ~= false then
	table.insert(spec, { import = "lazyvim.plugins.extras.ai.codeium" })
end

-- 順番めっちゃ大事。import pluginsは最後にすること。設定を上書きできなくなる。
table.insert(spec, { import = "plugins" })

require("lazy").setup({
	spec = spec,
	defaults = {
		lazy = true, -- 全プラグインをデフォルトで遅延読み込み
		version = "*", -- 最新安定版タグを使用（version = false だと最新コミットを追う）
	},
	change_detection = {
		notify = false,
	},
})
