-- Neovim Configuration

-- Basic Settings
-- mapleaderはlazy.luaで設定してる。
vim.opt.encoding = "utf-8" -- 内部エンコーディングをUTF-8に設定
vim.opt.fileencoding = "utf-8" -- ファイル保存時のエンコーディングをUTF-8に設定
vim.g.bigfile_size = 1024 * 1024 * 1 -- cf) https://github.com/neovim/neovim/issues/29900
-- UI Settings
vim.opt.number = true -- 行番号を表示
vim.opt.relativenumber = false -- 相対行番号を無効化
vim.opt.title = true -- ウィンドウタイトルにファイル名を表示
vim.opt.showcmd = true -- 入力中のコマンドを表示
vim.opt.cmdheight = 1 -- コマンドラインの高さを1行に設定
vim.opt.laststatus = 3 -- グローバルステータスラインを有効化（Neovim 0.7+）
vim.opt.scrolloff = 10 -- カーソルの上下に最低10行の余白を保持
-- vim.opt.termguicolors = true -- ターミナルの色を24ビットに設定

-- Indentation Settings
vim.opt.autoindent = true -- 自動インデントを有効化
vim.opt.smartindent = true -- スマートインデントを有効化
vim.opt.expandtab = true -- タブをスペースに変換
vim.opt.shiftwidth = 2 -- インデント幅を2スペースに設定
vim.opt.tabstop = 2 -- タブ文字の表示幅を2スペースに設定
vim.opt.smarttab = true -- スマートタブを有効化
vim.opt.breakindent = true -- 折り返し行のインデントを保持

-- Search Settings vim.opt.hlsearch = true -- 検索結果をハイライト vim.opt.ignorecase = true -- 検索時に大文字小文字を区別しない vim.opt.path:append({ "**" }) -- ファイル検索にサブディレクトリを含める
vim.opt.wildignore:append({ "*/node_modules/*" }) -- node_modulesを検索から除外
vim.opt.cmdheight = 0 -- コマンドラインの高さを1行に設定

-- Editor Behavior
vim.opt.wrap = false -- 長い行を折り返さない
vim.opt.backspace = "indent,eol,start"
vim.opt.splitbelow = true -- 水平分割時に新しいウィンドウを下に開く
vim.opt.splitright = true -- 垂直分割時に新しいウィンドウを右に開く
vim.opt.splitkeep = "cursor" -- ウィンドウ分割時にカーソル位置を保持
vim.opt.mouse = "" -- マウスサポートを無効化

-- File Handling
vim.opt.backup = false -- バックアップファイルを作成しない
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" } -- 特定ディレクトリのバックアップを作成しない
vim.opt.inccommand = "split" -- 置換プレビューを分割ウィンドウで表示

-- Shell Setting
vim.opt.shell = "zsh" -- 外部コマンド実行時のシェルをfishに設定

-- Version Specific Settings
if vim.fn.has("nvim-0.8") == 1 then
	vim.opt.cmdheight = 0 -- Neovim 0.8以上でコマンドラインを必要時のみ表示
end

-- Disable Statusline
vim.opt.laststatus = 0

-- mode切り替え時のスタック回避
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
