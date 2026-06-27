-- Basic Settings
vim.opt.encoding = "utf-8" -- 内部エンコーディングをUTF-8に設定
vim.opt.fileencoding = "utf-8" -- ファイル保存時のエンコーディングをUTF-8に設定

-- UI Settings
vim.opt.number = true -- 行番号を表示
vim.opt.relativenumber = false -- 相対行番号を無効化（パフォーマンス重視）
vim.opt.title = true -- ウィンドウタイトルにファイル名を表示
vim.opt.showcmd = true -- 入力中のコマンドを表示
vim.opt.cmdheight = 0 -- コマンドラインを必要時のみ表示
vim.opt.laststatus = 0 -- ステータスラインを無効化
vim.opt.scrolloff = 3 -- カーソルの上下に最低3行の余白を保持（パフォーマンス重視）

-- Indentation Settings
vim.opt.autoindent = true -- 自動インデントを有効化
vim.opt.smartindent = true -- スマートインデントを有効化
vim.opt.expandtab = true -- タブをスペースに変換
vim.opt.shiftwidth = 2 -- インデント幅を2スペースに設定
vim.opt.tabstop = 2 -- タブ文字の表示幅を2スペースに設定
vim.opt.smarttab = true -- スマートタブを有効化
vim.opt.breakindent = true -- 折り返し行のインデントを保持

-- Search Settings
vim.opt.hlsearch = true -- 検索結果をハイライト
vim.opt.path:append({ "**" }) -- ファイル検索にサブディレクトリを含める

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
vim.opt.shell = "zsh" -- 外部コマンド実行時のシェルをzshに設定

-- Performance optimizations
vim.opt.updatetime = 300 -- カーソルイベント頻度を下げる (was 100)
vim.opt.redrawtime = 1500 -- faster redraw timeout
vim.opt.lazyredraw = false -- noice.nvimとの互換性のため無効化
vim.opt.ttyfast = true -- 高速ターミナル接続を前提とした最適化
vim.opt.synmaxcol = 200 -- 200文字以降はシンタックスハイライト無効
vim.opt.cursorline = false -- カーソル行ハイライト無効化
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.g.bigfile_size = 1024 * 1024 * 0.5 -- file sizeが500KB以上で重い機能を無効化

-- File types
vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

-- Lazyvim rust settings
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
-- vim.g.lazyvim_rust_diagnostics = "bacon-ls"  -- bacon-ls を使用する場合は Mason でインストールしてから有効化
