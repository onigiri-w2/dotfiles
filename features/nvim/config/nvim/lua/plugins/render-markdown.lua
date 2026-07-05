-- markdown を「自動描画せず」トグルで 生 markdown ⇄ インライン描画 を切り替える。
-- 既存の <leader>u トグル群（uz: zenmode, uw: wrap）に合わせ <leader>um に割当。
--
-- なぜ LazyExtras (lang.markdown) を使わないか:
--   markdown の LazyExtra は renderer 単体では選べず、preview + marksman LSP +
--   markdownlint + prettier まで込みのバンドル。有効化すると prettier が
--   日本語 markdown（CJK の空白・折り返し）を触ってしまう。renderer だけ欲しい
--   今の要件では、extra を入れて不要分を打ち消すより単体追加の方が素直なため。
--   preview/LSP/lint も欲しくなったら :LazyExtras で lang.markdown を有効化し、
--   enabled=false や prettier 無効化を上書きする方針に切り替える。
return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-mini/mini.icons",
		},
		opts = {
			enabled = false, -- 開いても自動描画しない。<leader>um でトグルして初めて描画
			-- 見た目の微調整（LazyVim の markdown extra 準拠）
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
			-- 生 ⇄ 描画 のトグル。状態は render-markdown の get/set で管理され
			-- which-key に on/off が表示される。
			Snacks.toggle({
				name = "Render Markdown",
				get = require("render-markdown").get,
				set = require("render-markdown").set,
			}):map("<leader>um")
		end,
	},
}
