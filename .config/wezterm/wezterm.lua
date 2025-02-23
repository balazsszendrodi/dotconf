-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

config = {
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	--enable_scroll_bar = true,
	-- scrollback_lines = 3500,
	color_scheme = "Ayu Mirage (Gogh)", --Dark
	--color_scheme = 'ayu_light' --Light
	font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" }), -- /home/balazs/.fonts/HackNerdFontMono-Regular.ttf, FontConfig
	font_size = 16.0,
	window_decorations = "RESIZE",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	initial_cols = 200,
	initial_rows = 80,
	window_background_opacity = 1.0,
	max_fps = 120,
	--leader = { key = "Space", mods = "CTRL" },
	-- keys = {
	-- 	{ -- for tmux compatibility
	-- 		key = "v",
	-- 		mods = "LEADER",
	-- 		action = act.SpawnTab("CurrentPaneDomain"),
	-- 	},
	-- 	{
	-- 		key = '"',
	-- 		mods = "LEADER", -- "CTRL|SHIFT|ALT"
	-- 		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	-- 	},
	-- 	{
	-- 		key = "%",
	-- 		mods = "LEADER", -- "CTRL|SHIFT|ALT"
	-- 		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	-- 	},
	-- 	{
	-- 		key = "h",
	-- 		mods = "LEADER",
	-- 		action = act.ActivatePaneDirection("Left"),
	-- 	},
	-- 	{
	-- 		key = "l",
	-- 		mods = "LEADER",
	-- 		action = act.ActivatePaneDirection("Right"),
	-- 	},
	-- 	{
	-- 		key = "k",
	-- 		mods = "LEADER",
	-- 		action = act.ActivatePaneDirection("Up"),
	-- 	},
	-- 	{
	-- 		key = "j",
	-- 		mods = "LEADER",
	-- 		action = act.ActivatePaneDirection("Down"),
	-- 	},
	-- 	{
	-- 		key = "p",
	-- 		mods = "LEADER",
	-- 		action = act.PaneSelect,
	-- 	},
	-- },
}
-- for i = 1, 8 do
-- 	-- ALT + number to activate that tab
-- 	table.insert(config.keys, {
-- 		key = tostring(i),
-- 		mods = "ALT",
-- 		action = act.ActivateTab(i - 1),
-- 	})
-- end
-- rename tab entry in command palette
-- wezterm.on("augment-command-palette", function(window, pane)
-- 	return {
-- 		{
-- 			brief = "Rename tab",
-- 			icon = "md_rename_box",
--
-- 			action = act.PromptInputLine({
-- 				description = "Enter new name for tab",
-- 				action = wezterm.action_callback(function(window, pane, line)
-- 					if line then
-- 						window:active_tab():set_title(line)
-- 					end
-- 				end),
-- 			}),
-- 		},
-- 	}
-- end)
-- and finally, return the configuration to wezterm
return config
