-- hsの診断が邪魔なので無効化
---@diagnostic disable: undefined-global

-- Window Mode: leader key で modal に入って、滞在中は単キーで window 操作。
-- 微調整 (移動・リサイズ) を連打したいのが主目的。
-- preset (center, maximize, 四隅 等) も exit せず滞在するので試行錯誤しやすい。

local windowControler = require("functions.windowControler")

local M = {}

-- 1 ストロークで動かす px 数
local STEP = 50

function M.setup(leaderMods, leaderKey)
	local mode = hs.hotkey.modal.new(leaderMods, leaderKey)

	function mode:entered()
		hs.alert.closeAll()
		hs.alert.show("Window Mode: entered", 0.5)
	end

	function mode:exited()
		hs.alert.closeAll()
		hs.alert.show("Window Mode: exited", 0.5)
	end

	-- 移動 (押しっぱなしで連打)
	local function move(dx, dy)
		return function()
			windowControler.moveBy(dx, dy)
		end
	end
	mode:bind({}, "h", move(-STEP, 0), nil, move(-STEP, 0))
	mode:bind({}, "j", move(0, STEP), nil, move(0, STEP))
	mode:bind({}, "k", move(0, -STEP), nil, move(0, -STEP))
	mode:bind({}, "l", move(STEP, 0), nil, move(STEP, 0))

	-- リサイズ (Shift+hjkl, 押しっぱなしで連打)
	-- メンタルモデル: 右下角をドラッグ
	local function resize(dw, dh)
		return function()
			windowControler.resizeBy(dw, dh)
		end
	end
	mode:bind({ "shift" }, "h", resize(-STEP, 0), nil, resize(-STEP, 0))
	mode:bind({ "shift" }, "l", resize(STEP, 0), nil, resize(STEP, 0))
	mode:bind({ "shift" }, "j", resize(0, STEP), nil, resize(0, STEP))
	mode:bind({ "shift" }, "k", resize(0, -STEP), nil, resize(0, -STEP))

	-- preset (滞在型: exit しない)
	mode:bind({}, "c", windowControler.center)
	mode:bind({ "shift" }, "c", windowControler.centerSmall)
	mode:bind({}, "m", windowControler.toggleMax)
	mode:bind({}, "1", windowControler.moveTopLeftQuarter)
	mode:bind({}, "2", windowControler.moveTopRightQuarter)
	mode:bind({}, "3", windowControler.moveBottomLeftQuarter)
	mode:bind({}, "4", windowControler.moveBottomRightQuarter)
	mode:bind({}, "5", windowControler.snapCenter)

	-- マルチディスプレイ
	mode:bind({}, "[", windowControler.moveToPreviousScreen)
	mode:bind({}, "]", windowControler.moveToNextScreen)

	-- 抜ける (leader 再押下でトグル + 一般的な exit キー)
	mode:bind(leaderMods, leaderKey, function()
		mode:exit()
	end)
	mode:bind({}, "escape", function()
		mode:exit()
	end)
	mode:bind({}, "q", function()
		mode:exit()
	end)
	mode:bind({}, "return", function()
		mode:exit()
	end)

	return mode
end

return M
