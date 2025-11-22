local wezterm = require("wezterm")
local M = {}

-- Opacity Operations
function M.change_opacity(window, opacity)
	local overrides = window:get_config_overrides() or {}
	overrides.window_background_opacity = opacity
	window:set_config_overrides(overrides)
end

function M.toggle_opacity(window, opacity1, opacity2)
	local overrides = window:get_config_overrides() or {}
	local current = overrides.window_background_opacity or opacity1
	local new_opacity = (current == opacity1) and opacity2 or opacity1
	M.change_opacity(window, new_opacity)
end

-- Action Creators
function M.create_opacity_action(opacity)
	return wezterm.action_callback(function(window, _)
		M.change_opacity(window, opacity)
	end)
end

function M.create_toggle_action(opacity1, opacity2)
	return wezterm.action_callback(function(window, _)
		M.toggle_opacity(window, opacity1, opacity2)
	end)
end

return M
