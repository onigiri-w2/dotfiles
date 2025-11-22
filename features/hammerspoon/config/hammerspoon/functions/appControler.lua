-- hsの診断が邪魔なので無効化
---@diagnostic disable: undefined-global

local M = {}

-- アプリケーションを開く、または前面に持ってくる
function M.openApp(appName)
	return function()
		hs.application.launchOrFocus("/Applications/" .. appName .. ".app")
	end
end

function M.hideApp()
	local currentApp = hs.application.frontmostApplication()
	if currentApp then
		currentApp:hide()
	end
end

-- アプリケーションの切り替え（開く/隠す/前面に出す）
function M.toggleApp(appName)
	return function()
		local app = hs.application.find(appName)
		if app == nil then
			hs.application.launchOrFocus("/Applications/" .. appName .. ".app")
		elseif app:isFrontmost() then
			app:hide()
		else
			app:activate()
		end
	end
end

return M
