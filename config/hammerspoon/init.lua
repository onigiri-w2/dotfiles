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
hs.hotkey.bind({ "ctrl", "cmd" }, "n", appControler.toggleApp("Cosense"))

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
hs.hotkey.bind({ "ctrl", "alt" }, "h", windowControler.moveLeft)
hs.hotkey.bind({ "ctrl", "alt" }, "l", windowControler.moveRight)
hs.hotkey.bind({ "ctrl", "alt" }, "j", windowControler.toggleMax)
hs.hotkey.bind({ "ctrl", "alt" }, "k", windowControler.center)
