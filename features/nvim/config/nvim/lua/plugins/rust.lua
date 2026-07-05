-- rustaceanvim (LazyVim rust extra) への上書き。
-- LazyVim デフォルトに deep-merge されるので、ここでは差分だけ書く。
-- LazyVim 側で既に checkOnSave=true / diagnostics.enable=true / files.watcher="client" 等は設定済み。
-- see: features/nvim/config/nvim/lua/config/options.lua の lazyvim_rust_diagnostics
return {
	"mrcjkb/rustaceanvim",
	opts = {
		server = {
			default_settings = {
				["rust-analyzer"] = {
					-- 保存時の check を有効化（bool）し、その check に clippy を使う。
					-- 旧スキーマ checkOnSave = { command = "clippy" } は現行 rust-analyzer では
					-- 型不一致（checkOnSave は boolean）となり flycheck が壊れて診断が更新されなくなる。
					-- 現行スキーマでは checkOnSave(bool) + check.command(string) に分離されている。
					checkOnSave = true,
					check = {
						command = "clippy",
					},
				},
			},
		},
	},
}
