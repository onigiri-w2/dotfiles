---@diagnostic disable: undefined-global
-- hsの診断が邪魔なので無効化

local M = {}

function M.keyCode(key, modifiers)
	modifiers = modifiers or {}
	return function()
		hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
		hs.timer.usleep(1000)
		hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
	end
end

return M
