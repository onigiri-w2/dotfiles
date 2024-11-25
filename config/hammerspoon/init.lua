-- hsの診断が邪魔なので無効化
---@diagnostic disable: undefined-global

-- 初期設定
hs.loadSpoon("RecursiveBinder")
spoon.RecursiveBinder.escapeKey = { {}, "escape" }
spoon.RecursiveBinder.showBindHelper = true -- ヘルパー表示を有効化

-- open app の keymap
local appControler = require("functions.appControler")
-- local keymapOfApp = {
-- 	[spoon.RecursiveBinder.singleKey("h", "Chrome")] = appControler.openApp("Google Chrome"),
-- 	[spoon.RecursiveBinder.singleKey("l", "Claude")] = appControler.openApp("Claude"),
-- 	[spoon.RecursiveBinder.singleKey("i", "Wezterm")] = appControler.openApp("Wezterm"),
-- 	[spoon.RecursiveBinder.singleKey("o", "Obsidian")] = appControler.openApp("Obsidian"),
-- 	[spoon.RecursiveBinder.singleKey("s", "Simulator")] = appControler.openApp("Simulator"),
-- }
-- local bindOfApp = spoon.RecursiveBinder.recursiveBind(keymapOfApp)
-- hs.hotkey.bind({ "ctrl", "cmd" }, "o", bindOfApp)
hs.hotkey.bind({ "ctrl", "cmd" }, "i", appControler.openApp("Wezterm"))
hs.hotkey.bind({ "ctrl", "cmd" }, "l", appControler.openApp("Claude"))
hs.hotkey.bind({ "ctrl", "cmd" }, "o", appControler.openApp("Google Chrome"))
hs.hotkey.bind({ "ctrl", "cmd" }, "n", appControler.openApp("Obsidian"))
hs.hotkey.bind({ "ctrl", "cmd" }, ";", appControler.toggleApp("Simulator"))

-- vim移動のkeymap
local keyCode = require("functions.keyUtils").keyCode
hs.hotkey.bind({ "ctrl" }, "h", keyCode("left"), nil, keyCode("left"))
hs.hotkey.bind({ "ctrl" }, "j", keyCode("down"), nil, keyCode("down"))
hs.hotkey.bind({ "ctrl" }, "k", keyCode("up"), nil, keyCode("up"))
hs.hotkey.bind({ "ctrl" }, "l", keyCode("right"), nil, keyCode("right"))

-- window keymap
local windowControler = require("functions.windowControler")
hs.hotkey.bind({ "ctrl", "alt" }, "h", windowControler.moveLeft)
hs.hotkey.bind({ "ctrl", "alt" }, "l", windowControler.moveRight)
hs.hotkey.bind({ "ctrl", "alt" }, "j", windowControler.maximize)
hs.hotkey.bind({ "ctrl", "alt" }, "k", windowControler.center)
