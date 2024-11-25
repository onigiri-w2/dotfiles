local functions = require("functions")

-- アプリ開閉ショートカット
-- toggleApp("kitty", "i")
toggleApp("wezterm", "i")
toggleApp("obsidian", "n")
toggleApp("Google Chrome", "o")
-- toggleApp("obsidian", "o")
-- toggleApp("logseq", ":")
toggleApp("com.apple.iphonesimulator", ";")

-- キーバインド変更
remapKey({ "ctrl" }, "h", keyCode("left"))
remapKey({ "ctrl", "cmd" }, "h", keyCode("left", { "cmd" }))
remapKey({ "ctrl" }, "j", keyCode("down"))
remapKey({ "ctrl", "cmd" }, "j", keyCode("down", { "cmd" }))
remapKey({ "ctrl" }, "k", keyCode("up"))
remapKey({ "ctrl", "cmd" }, "k", keyCode("up", { "cmd" }))
remapKey({ "ctrl" }, "l", keyCode("right"))
remapKey({ "ctrl", "cmd" }, "l", keyCode("right", { "cmd" }))

-- ウィンドウのサイズ変更 + 移動
local function moveWindowWithoutAnimation(win, f)
	local animationDuration = hs.window.animationDuration
	hs.window.animationDuration = 0
	win:setFrame(f)
	hs.window.animationDuration = animationDuration
end
-- 左半分に移動
hs.hotkey.bind({ "ctrl", "alt" }, "h", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end)

-- 右半分に移動
hs.hotkey.bind({ "ctrl", "alt" }, "l", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w / 2)
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end)

-- 最大化
hs.hotkey.bind({ "ctrl", "alt" }, "j", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end)

-- 中央に配置
hs.hotkey.bind({ "ctrl", "alt" }, "k", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	local width = max.w * 0.75
	local height = max.h * 0.75

	f.x = max.x + ((max.w - width) / 2)
	f.y = max.y + ((max.h - height) / 2)
	f.w = width
	f.h = height
	moveWindowWithoutAnimation(win, f)
end)
