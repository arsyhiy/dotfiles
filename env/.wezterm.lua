local wezterm = require 'wezterm'

return {
  color_scheme = 'Dark Pastel (Gogh)',

  font = wezterm.font("JetBrains Mono"),
  font_size = 15.0,

  enable_tab_bar = false,
  -- window_decorations = "RESIZE",

  window_background_opacity = 1,

  window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  },

  default_cursor_style = "SteadyBlock",

  scrollback_lines = 3000,

  keys = {
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = wezterm.action.CopyTo("Clipboard"),
    },
    {
      key = "v",
      mods = "CTRL|SHIFT",
      action = wezterm.action.PasteFrom("Clipboard"),
    },
  },
}
