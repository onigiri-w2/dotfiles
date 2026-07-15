-- markdown を開いたら常時インライン描画する。
-- カーソル行を raw に戻す anti_conceal は無効化し、normal モード中は全行描画を維持。
-- insert モードに入るとバッファ全体が raw になる（render_modes のデフォルトに 'i' が無いため）。
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
			-- カーソル行を raw 表示に戻さない（insert モードまで描画を維持）
			anti_conceal = { enabled = false },
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
	},
}
