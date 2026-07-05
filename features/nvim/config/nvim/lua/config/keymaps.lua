local keymap = vim.keymap
------------------------------------
-- LazyVim のデフォルトkeymapsを一部消去
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
------------------------------------
-- LazyVim 側の keymap 変更で対象が存在しなくても起動を止めないよう pcall で囲む
local function safe_del(mode, lhs)
	pcall(keymap.del, mode, lhs)
end

safe_del("n", "<leader>l")
safe_del("n", "<leader>L")
safe_del("n", "<leader>-")
safe_del("n", "<leader>|")

safe_del("n", "<leader><tab>l")
safe_del("n", "<leader><tab>o")
safe_del("n", "<leader><tab>f")
safe_del("n", "<leader><tab><tab>")
safe_del("n", "<leader><tab>]")
safe_del("n", "<leader><tab>d")
safe_del("n", "<leader><tab>[")

safe_del("n", "<C-h>")
safe_del("n", "<C-j>")
safe_del("n", "<C-k>")
safe_del("n", "<C-l>")

safe_del("n", "<C-Up>")
safe_del("n", "<C-Down>")
safe_del("n", "<C-Left>")
safe_del("n", "<C-Right>")

safe_del("n", "f")

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
keymap.set("n", "<leader>a", "ggVG") -- ファイル全体選択
keymap.set("n", "<leader>.", "<leader>cr", { desc = "Rename", remap = true }) --- Rename

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
local zenmode = require("onigiri.zenmode")
keymap.set("n", "<leader>uz", zenmode.toggle, { desc = "Toggle Zen mode", noremap = true, silent = true })

-- wrap
local wrap = require("onigiri.wrap")
keymap.set("n", "<leader>uw", wrap.toggle, { desc = "Toggle wrap", noremap = true, silent = true })

-- seek
keymap.set({ "n", "x", "o" }, "f", "<cmd>lua require('flash').jump()<cr>", { desc = "Flash Jump" })
