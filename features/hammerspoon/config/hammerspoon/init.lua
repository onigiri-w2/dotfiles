-- hsの診断が邪魔なので無効化
---@diagnostic disable: undefined-global

-- RecursiveBinder設定。今は使ってない。
-- hs.loadSpoon("RecursiveBinder")
-- spoon.RecursiveBinder.escapeKey = { {}, "escape" }
-- spoon.RecursiveBinder.showBindHelper = true -- ヘルパー表示を有効化

require("hs.ipc")

-- open app の keymap
local appControler = require("functions.appControler")
hs.hotkey.bind({ "ctrl", "cmd" }, "i", appControler.toggleApp("Wezterm"))
-- hs.hotkey.bind({ "ctrl", "cmd" }, ";", appControler.openApp("Claude"))

-- vim移動のkeymap
local keyCode = require("functions.keyUtils").keyCode
hs.hotkey.bind({ "ctrl" }, "h", keyCode("left"), nil, keyCode("left"))
hs.hotkey.bind({ "ctrl" }, "j", keyCode("down"), nil, keyCode("down"))
hs.hotkey.bind({ "ctrl" }, "k", keyCode("up"), nil, keyCode("up"))
hs.hotkey.bind({ "ctrl" }, "l", keyCode("right"), nil, keyCode("right"))
hs.hotkey.bind({ "ctrl", "cmd" }, "h", keyCode("left", { "cmd" }), nil, keyCode("left", { "cmd" }))
hs.hotkey.bind({ "ctrl", "cmd" }, "j", keyCode("down", { "cmd" }), nil, keyCode("down", { "cmd" }))
hs.hotkey.bind({ "ctrl", "cmd" }, "k", keyCode("up", { "cmd" }), nil, keyCode("up", { "cmd" }))
hs.hotkey.bind({ "ctrl", "cmd" }, "l", keyCode("right", { "cmd" }), nil, keyCode("right", { "cmd" }))

-- window keymap
local windowControler = require("functions.windowControler")

-- シングル/ダブルタップ対応のバインド
local lastHTime = 0
local lastLTime = 0
local lastKTime = 0
local doubleTapInterval = 0.3

hs.hotkey.bind({ "ctrl", "alt" }, "h", function()
	local now = hs.timer.secondsSinceEpoch()
	if (now - lastHTime) <= doubleTapInterval then
		windowControler.moveLeftQuarter()
		lastHTime = 0
	else
		windowControler.moveLeft()
		lastHTime = now
	end
end)

hs.hotkey.bind({ "ctrl", "alt" }, "l", function()
	local now = hs.timer.secondsSinceEpoch()
	if (now - lastLTime) <= doubleTapInterval then
		windowControler.moveRightQuarter()
		lastLTime = 0
	else
		windowControler.moveRight()
		lastLTime = now
	end
end)

hs.hotkey.bind({ "ctrl", "alt" }, "j", windowControler.toggleMax)

hs.hotkey.bind({ "ctrl", "alt" }, "k", function()
	local now = hs.timer.secondsSinceEpoch()
	if (now - lastKTime) <= doubleTapInterval then
		windowControler.centerSmall()
		lastKTime = 0
	else
		windowControler.center()
		lastKTime = now
	end
end)

-- ファイルが存在する場合のみ読み込む（エラー防止）
local localConfig = hs.configdir .. "/local.lua"
if hs.fs.attributes(localConfig) then
	dofile(localConfig)
end
