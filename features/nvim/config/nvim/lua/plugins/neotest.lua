-- テスト実行フレームワーク（adapters はキー名から自動 require される）
-- see: https://www.lazyvim.org/extras/test/core

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-jest",
			-- "marilari88/neotest-vitest",
			-- NOTE: neotest-vitest は package.json のないプロジェクト（Rust等）で
			-- rootPath が nil になりクラッシュするため無効化中
			-- see: https://github.com/marilari88/neotest-vitest/issues
			-- "marilari88/neotest-vitest",
			"rouge8/neotest-rust",
		},
		opts = {
			adapters = {
				["neotest-jest"] = {
					jestCommand = "npm test --",
				},
				-- ["neotest-vitest"] = {
				-- 	vitestCommand = "npx vitest run",
				-- },
				["neotest-rust"] = {},
			},
		},
	},
}
