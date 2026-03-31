-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local mux = wezterm.mux

config = {
  default_domain = 'WSL:Ubuntu',
  default_prog = { "wsl.exe", "--distribution", "Ubuntu", "--cd", "~/workspace", "--exec", "/bin/zsh" },
  audible_bell = "Disabled",
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  -- enable_scroll_bar = true,
  scrollback_lines = 10000,
  -- color_scheme = "Ayu Mirage (Gogh)", -- Dark
  color_scheme = "tokyonight_night",
  -- color_scheme = 'ayu_light', --Light
  -- font = wezterm.font 'JetBrains Mono',
  font = wezterm.font_with_fallback({ {
    family = "IosevkaTerm Nerd Font",
    weight = "Regular",
    stretch = "SemiExpanded",
  }, 'JetBrains Mono' }),
  font_size = 15.0,
  window_decorations = "TITLE | RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },
  initial_cols = 200,
  initial_rows = 80,
  window_background_opacity = 1.0,
  max_fps = 120,
  keys = { { -- for tmux compatibility
    key = "c",
    mods = "CTRL|ALT",
    action = wezterm.action.SpawnCommandInNewTab {
      domain = "DefaultDomain",
      cwd = '~/workspace/'
    }
  }, {
    key = '"',
    mods = "CTRL|ALT|SHIFT",
    action = act.SplitVertical({
      domain = "CurrentPaneDomain",
      cwd = '~/workspace/'
    })
  }, {
    key = "%",
    mods = "CTRL|ALT|SHIFT",
    action = act.SplitHorizontal({
      domain = "CurrentPaneDomain",
      cwd = '~/workspace/'
    })
  }, {
    key = "h",
    mods = "CTRL|ALT",
    action = act.ActivatePaneDirection("Left")
  }, {
    key = "l",
    mods = "CTRL|ALT",
    action = act.ActivatePaneDirection("Right")
  }, {
    key = "k",
    mods = "CTRL|ALT",
    action = act.ActivatePaneDirection("Up")
  }, {
    key = "j",
    mods = "CTRL|ALT",
    action = act.ActivatePaneDirection("Down")
  }, {
    key = ',',
    mods = 'CTRL|ALT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      initial_value = 'wezterm',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }
  } }
}
for i = 1, 8 do
  -- ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT|CTRL",
    action = act.ActivateTab(i - 1)
  })
end
-- rename tab entry in command palette
wezterm.on("augment-command-palette", function(window, pane)
  return { {
    brief = "Rename tab",
    icon = "md_rename_box",

    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    })
  } }
end)
wezterm.on("gui-startup", function(cmd)
  if mux then
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end
end)
-- and finally, return the configuration to wezterm
return config
