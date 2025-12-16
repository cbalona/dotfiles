local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- APPEARANCE
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 11.0

-- WINDOW
config.window_background_opacity = 0.8
config.win32_system_backdrop = 'Acrylic'
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- INTERACTION

config.selection_word_boundary = ' \t\n{}[]()<>:;.,-+*/=%"\''
config.scrollback_lines = 10000

return config