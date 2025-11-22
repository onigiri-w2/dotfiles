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
