-- テスト実行フレームワーク（adapters はキー名から自動 require される）
-- see: https://www.lazyvim.org/extras/test/core

return {
	{
		"nvim-neotest/neotest",
		dependencies = { "nvim-neotest/neotest-jest" },
		opts = {
			adapters = {
				["neotest-jest"] = {
					jestCommand = "npm test --",
				},
			},
		},
	},
}
