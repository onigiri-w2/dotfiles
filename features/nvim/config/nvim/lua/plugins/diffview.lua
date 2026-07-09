-- PRのようにファイル一覧+diffパネルを並べてレビューするためのプラグイン。
-- mini.diff (<leader>go) が現在開いているファイル1枚のinline diffなのに対し、
-- こちらは変更された全ファイルを1つのタブページで巡回してレビューできる。
-- <leader>gd は Snacks picker の git diff で既に使われているため v を使う。
-- <leader>gh は元々 gitsigns の hunk 操作の which-key グループラベルだったが、
-- mini.diff extra で gitsigns 自体を無効化済みのため実体の無い死んだラベルだった。
-- 既に view が開いていれば閉じる、無ければ open_cmd で開く。
-- diffview.nvim は DiffviewOpen / DiffviewFileHistory どちらも同じ View 管理下に
-- 乗るので、開いている view を閉じるだけで両方のトグルに使い回せる。
local function toggle_diffview(open_cmd)
	return function()
		if require("diffview.lib").get_current_view() then
			vim.cmd("DiffviewClose")
		else
			vim.cmd(open_cmd)
		end
	end
end

return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	keys = {
		{ "<leader>gv", toggle_diffview("DiffviewOpen"), desc = "Diffview: Toggle" },
		{ "<leader>gh", toggle_diffview("DiffviewFileHistory"), desc = "Diffview: File History Toggle" },
	},
	opts = {},
}
