local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- font settings
config.font = wezterm.font_with_fallback({
	{ family = "Monaco" },
	{ family = "MonaspiceNe Nerd Font" },
	{ family = "Hiragino Sans" },
})
config.font_size = 20
config.line_height = 1
config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font_with_fallback({
			{ family = "Monaco", weight = "Medium" },
			{ family = "MonaspiceNe Nerd Font", weight = "Medium" },
			{ family = "Hiragino Sans", weight = "Medium" },
		}),
	},
	{
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Monaco", italic = true },
			{ family = "MonaspiceNe Nerd Font", italic = true },
			{ family = "Hiragino Sans", italic = true },
		}),
	},
	{
		italic = true,
		intensity = "Bold",
		font = wezterm.font_with_fallback({
			{ family = "Monaco", italic = true, weight = "Medium" },
			{ family = "MonaspiceNe Nerd Font", italic = true, weight = "Medium" },
			{ family = "Hiragino Sans", italic = true, weight = "Medium" },
		}),
	},
}

-- window settings
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_padding = { top = 24, bottom = 0, left = 0, right = 0 }
config.use_resize_increments = true -- めっちゃ重要: https://www.reddit.com/r/neovim/comments/27rukht/comment/l77qltn/
config.adjust_window_size_when_changing_font_size = false

-- colorscheme
config.color_scheme = "tokyonight-storm"
-- config.color_scheme = "tokyonight_day"

-- background settings
config.window_background_opacity = 1
config.macos_window_background_blur = 0

-- keybindings
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
local opacity = require("functions.opacity")
config.keys = {
	{ key = "0", mods = "CMD", action = opacity.create_toggle_action(1, 0.9) },
	{ key = "9", mods = "CMD", action = wezterm.action.ToggleFullScreen },
}

return config
