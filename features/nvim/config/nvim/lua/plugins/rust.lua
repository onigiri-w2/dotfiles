return {
	"mrcjkb/rustaceanvim",
	opts = {
		server = {
			default_settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
					diagnostics = {
						refreshSupport = true,
					},
					files = {
						watcher = "server",
					},
				},
			},
		},
	},
}
