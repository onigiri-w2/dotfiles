-- hsの診断が邪魔なので無効化
---@diagnostic disable: undefined-global

local M = {}

-- アニメーションなしでウィンドウを移動する関数
local function moveWindowWithoutAnimation(win, f)
	local animationDuration = hs.window.animationDuration
	hs.window.animationDuration = 0
	win:setFrame(f)
	hs.window.animationDuration = animationDuration
end

-- ウィンドウを左半分に移動
function M.moveLeft()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end

-- ウィンドウを右半分に移動
function M.moveRight()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w / 2)
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end

-- ウィンドウを左1/4に移動
function M.moveLeftQuarter()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 4
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end

-- ウィンドウを右1/4に移動
function M.moveRightQuarter()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w * 3 / 4)
	f.y = max.y
	f.w = max.w / 4
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end

-- ウィンドウを最大化
function M.maximize()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.h
	moveWindowWithoutAnimation(win, f)
end

-- ウィンドウを中央に配置
function M.center()
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
end

-- ウィンドウを中央に小さめ配置
function M.centerSmall()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	local width = max.w * 0.4
	local height = max.h * 0.4
	f.x = max.x + ((max.w - width) / 2)
	f.y = max.y + ((max.h - height) / 2)
	f.w = width
	f.h = height
	moveWindowWithoutAnimation(win, f)
end

-- delta 分移動
function M.moveBy(dx, dy)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	f.x = f.x + dx
	f.y = f.y + dy
	moveWindowWithoutAnimation(win, f)
end

-- delta 分リサイズ (右下角を動かすイメージ)
function M.resizeBy(dw, dh)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	f.w = math.max(100, f.w + dw)
	f.h = math.max(100, f.h + dh)
	moveWindowWithoutAnimation(win, f)
end

-- 四隅 1/4 (画面の縦横を半分にしたエリア)
local function moveToQuadrant(xRatio, yRatio)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local max = win:screen():frame()
	f.w = max.w / 2
	f.h = max.h / 2
	f.x = max.x + max.w * xRatio
	f.y = max.y + max.h * yRatio
	moveWindowWithoutAnimation(win, f)
end

function M.moveTopLeftQuarter()
	moveToQuadrant(0, 0)
end

function M.moveTopRightQuarter()
	moveToQuadrant(0.5, 0)
end

function M.moveBottomLeftQuarter()
	moveToQuadrant(0, 0.5)
end

function M.moveBottomRightQuarter()
	moveToQuadrant(0.5, 0.5)
end

-- サイズ維持で画面中央にスナップ
function M.snapCenter()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local max = win:screen():frame()
	f.x = max.x + (max.w - f.w) / 2
	f.y = max.y + (max.h - f.h) / 2
	moveWindowWithoutAnimation(win, f)
end

-- 隣のディスプレイへ移動
function M.moveToNextScreen()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	win:moveToScreen(win:screen():next())
end

function M.moveToPreviousScreen()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	win:moveToScreen(win:screen():previous())
end

local originalFrames = {}
function M.toggleMax()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local id = win:id()

	-- 現在最大化されているかチェック
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	-- 最大化されているかの判定
	local isMaximized = f.x == max.x and f.y == max.y and f.w == max.w and f.h == max.h

	if isMaximized then
		-- 元のサイズが保存されている場合は戻す
		if originalFrames[id] then
			moveWindowWithoutAnimation(win, originalFrames[id])
			originalFrames[id] = nil
		end
	else
		-- 現在のサイズを保存して最大化
		originalFrames[id] = f
		M.maximize()
	end
end

return M
