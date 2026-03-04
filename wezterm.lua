local Config = require('config')

require('utils.backdrops'):set_files():random()

require('events.right-status').setup()
require('events.left-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()

local wezterm = require 'wezterm'
local mux = wezterm.mux
wezterm.on('gui-attached', function(domain)
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)

return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
