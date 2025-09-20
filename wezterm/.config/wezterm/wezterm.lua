-- local b = require("utils/background")
-- local w = require("utils/wallpaper")

---@type WeztermPlugin

local wezterm = require("wezterm")
---@type WeztermConfig
local config = wezterm.config_builder()
local act = wezterm.action

-- Color scheme
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance, light, dark)
	if appearance:find("Dark") then
		return dark
	else
		return light
	end
end

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = scheme_for_appearance(get_appearance(), "One Light (Gogh)", "One Half Black (Gogh)")

-- Font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 17.5
-- config.font_size = 15.5

-- Wallpaper
config.background = {
	{
		source = {
			File = scheme_for_appearance(
				get_appearance(),
				"/Users/solomon/Pictures/.drawings/zzz/colors/catppuccin-latte-light.png",
				"/Users/solomon/Pictures/.drawings/zzz/colors/catppuccin-mocha-dark.png"
				-- "C:/Users/Jesse/Pictures/Walli/.drawings/zzz/colors/vs-code-light.png",
				-- "C:/Users/Jesse/Pictures/Walli/.drawings/zzz/colors/vs-code.png"
			),
		},
		attachment = "Fixed",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		vertical_align = "Middle",
		vertical_offset = 0,
		horizontal_align = "Center",
		horizontal_offset = 0,
		opacity = 1,
	},

	-- {
	-- 	source = {
	-- 		File = "C:/Users/Jesse/Pictures/Walli/.drawings/v2/endless-summer.jpg",
	-- 	},
	-- 	attachment = "Fixed",
	-- 	repeat_x = "NoRepeat",
	-- 	vertical_align = "Middle",
	-- 	vertical_offset = 0,
	-- 	horizontal_align = "Center",
	-- 	horizontal_offset = 0,
	-- 	opacity = 0.1,
	-- 	-- opacity = 0.1,
	-- 	hsb = nil,
	-- 	-- height = "100%",
	-- 	-- width = "100%",
	-- },
}

-- Other stuff
config.keys = {
	-- { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- terminal
	{
		key = "c",
		mods = "SUPER",
		action = act.SendKey({ key = "c", mods = "CTRL" }),
	},

	{
		key = "l",
		mods = "SUPER",
		action = act.SendKey({ key = "l", mods = "CTRL" }),
	},
	{
		key = "d",
		mods = "SUPER",
		action = act.SendKey({ key = "d", mods = "CTRL" }),
	},
	{
		key = "z",
		mods = "SUPER",
		action = act.SendKey({ key = "z", mods = "CTRL" }),
	},

	-- neovim
	{
		key = "q",
		mods = "SUPER",
		action = act.SendKey({ key = "q", mods = "CTRL" }),
	},
	{
		key = "r",
		mods = "SUPER",
		action = act.SendKey({ key = "r", mods = "CTRL" }),
	},
	{
		key = "i",
		mods = "SUPER",
		action = act.SendKey({ key = "i", mods = "CTRL" }),
	},
	{
		key = "o",
		mods = "SUPER",
		action = act.SendKey({ key = "o", mods = "CTRL" }),
	},
	{
		key = "w",
		mods = "SUPER",
		action = act.SendKey({ key = "w", mods = "CTRL" }),
	},
}

config.window_padding = {
	bottom = 0,
	left = 0,
	right = 0,
	top = 0,
}

-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.window_close_confirmation = "NeverPrompt"
config.automatically_reload_config = true
config.warn_about_missing_glyphs = false

-- dont know what this means, but do not set this to false
-- config.send_composed_key_when_right_alt_is_pressed = false

return config
