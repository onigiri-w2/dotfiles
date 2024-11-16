local keymap = vim.keymap
------------------------------------
-- LazyVim のデフォルトkeymapsを一部消去
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
------------------------------------
keymap.del("n", "<leader>l")
keymap.del("n", "<leader>L")
keymap.del("n", "<leader>-")
keymap.del("n", "<leader>|")

keymap.del("n", "<leader><tab>l")
keymap.del("n", "<leader><tab>o")
keymap.del("n", "<leader><tab>f")
keymap.del("n", "<leader><tab><tab>")
keymap.del("n", "<leader><tab>]")
keymap.del("n", "<leader><tab>d")
keymap.del("n", "<leader><tab>[")

keymap.del("n", "<C-h>")
keymap.del("n", "<C-j>")
keymap.del("n", "<C-k>")
keymap.del("n", "<C-l>")

keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Right>")

------------------------------------
-- ユーザー独自設定
------------------------------------
-- sを無効化
keymap.set("n", "s", "<Nop>")

-- レジスタを影響させずに操作
keymap.set("n", "x", '"_x') -- 文字を削除

-- コーディング
keymap.set("n", "+", "<C-a>") -- 数字をインクリメント
keymap.set("n", "-", "<C-x>") -- 数字をデクリメント
keymap.set("n", "<C-a>", "gg<S-v>G") -- 全選択
keymap.set("n", "<leader>.", "<leader>cr", { desc = "Rename", remap = true }) -- コードを実行

-- バッファ操作
keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next Buffer", silent = true })
keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer", silent = true })
keymap.set("n", "<leader>bb", "<cmd>bprevious<cr>", { desc = "Previous Buffer", silent = true })

-- ウィンドウ操作
keymap.set("n", "ss", "<C-w>v") -- 垂直分割
keymap.set("n", "sh", "<C-w>h") -- ウィンドウを左に移動
keymap.set("n", "sk", "<C-w>k") -- ウィンドウを上に移動
keymap.set("n", "sj", "<C-w>j") -- ウィンドウを下に移動
keymap.set("n", "sl", "<C-w>l") -- ウィンドウを右に移動
-- 閉じる系の操作
keymap.set("n", ";q", "<C-w>c", { desc = "remove window" }) -- ウィンドウを閉じる
keymap.set("n", ";w", LazyVim.ui.bufremove, { desc = "remove buffer" }) -- バッファを閉じる
keymap.set("n", ";<tab>", ":tabclose<Return>") -- タブを閉じる

-- 定義ジャンプ
keymap.set("n", "gs", "<C-w>v<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "split definition" }) -- 定義を分割

-- ファイル生成
vim.keymap.set("n", "<leader>n", ":e %:h/", { noremap = true })

-- ファイル検索
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", telescope.buffers, {
	noremap = true,
	desc = "buffers",
})

-- Lualineの表示/非表示を切り替えるキーマップ
vim.keymap.set(
	"n",
	"<leader>u0",
	':lua require("lualine").hide()<CR>',
	{ desc = "hide lualine", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>u9",
	':lua require("lualine").hide({unhide=true})<CR>',
	{ desc = "show lualine", noremap = true, silent = true }
)
