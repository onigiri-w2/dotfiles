local module = {}

function toggleApp(appName, key)
	hs.hotkey.bind({ "ctrl", "cmd" }, key, function()
		local app = hs.application.find(appName)
		if app == nil then
			hs.application.launchOrFocus("/Applications/" .. appName .. ".app")
		elseif app:isFrontmost() then
			app:hide()
		else
			app:activate()
			-- hs.application.launchOrFocus("/Applications/" .. appName .. ".app")
		end
	end)
end

-- キーバインド変更用の関数群
function keyCode(key, modifiers)
	modifiers = modifiers or {}
	return function()
		hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
		hs.timer.usleep(1000)
		hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
	end
end

function remapKey(modifiers, key, keyCode)
	hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

return {
	toggleApp = toggleApp,
	remapKey = remapKey,
	keyCode = keyCode,
}
