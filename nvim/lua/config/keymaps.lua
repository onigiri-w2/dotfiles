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
-- 全行選択
keymap.set("n", "<leader>a", "ggVG")

-- バッファ操作
keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next Buffer", silent = true })

-- ウィンドウ操作
keymap.set("n", "ss", "<C-w>v") -- 垂直分割
keymap.set("n", "sh", "<C-w>h") -- ウィンドウを左に移動
keymap.set("n", "sk", "<C-w>k") -- ウィンドウを上に移動
keymap.set("n", "sj", "<C-w>j") -- ウィンドウを下に移動
keymap.set("n", "sl", "<C-w>l") -- ウィンドウを右に移動
-- 閉じる系の操作
keymap.set("n", ";q", "<C-w>c", { desc = "remove window" }) -- ウィンドウを閉じる
keymap.set("n", ";w", "<cmd>lua Snacks.bufdelete()<cr>", { desc = "remove buffer" }) -- バッファを閉じる
keymap.set("n", ";bo", "<cmd>lua Snacks.bufdelete.other()<cr>", { desc = "remove other buffers" }) -- 他のバッファを閉じる
keymap.set("n", ";ba", "<cmd>lua Snacks.bufdelete.all()<cr>", { desc = "remove all buffers" }) -- 全てのバッファを閉じる

-- 定義ジャンプ
keymap.set("n", "gs", "<C-w>v<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "split definition" }) -- 定義を分割

-- ファイル生成
keymap.set("n", "<leader>n", ":e %:h/", { noremap = true })

-- zenmode
local zenmode = require("functions.zenmode")
keymap.set("n", "<leader>uz", zenmode.toggle, {
	desc = "Toggle Zen mode",
	noremap = true,
	silent = true,
})

-- wrap toggle
keymap.set("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Wrap: " .. (vim.wo.wrap and "Enabled" or "Disabled"))
end, { noremap = true, silent = true, desc = "Toggle wrap" })
