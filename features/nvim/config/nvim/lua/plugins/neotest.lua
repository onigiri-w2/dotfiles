-- テスト実行フレームワーク（adapters はキー名から自動 require される）
-- see: https://www.lazyvim.org/extras/test/core

return {
	{
		"nvim-neotest/neotest",
		dependencies = { "nvim-neotest/neotest-jest", "marilari88/neotest-vitest" },
		opts = {
			adapters = {
				["neotest-jest"] = {
					jestCommand = "npm test --",
				},
				["neotest-vitest"] = {
					vitestCommand = "npx vitest run",
				},
			},
		},
	},
}
