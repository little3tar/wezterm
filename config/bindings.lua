local wezterm = require('wezterm')
local platform = require('utils.platform')()
local backdrops = require('utils.backdrops')
local act = wezterm.action

-- 个人代理端口（仅在本地使用）
local PROXY_PORT = '2080'

-- 生成设置代理的环境变量语句：unix 为 true 时用 bash/zsh 语法，否则用 PowerShell 语法
local function proxy_env(unix)
   local proxy = 'http://127.0.0.1:' .. PROXY_PORT
   if unix then
      return 'export http_proxy="' .. proxy .. '"; export HTTP_PROXY="$http_proxy"; export https_proxy="' .. proxy .. '"; export HTTPS_PROXY="$https_proxy"; export no_proxy="localhost,127.0.0.1,.local"; export NO_PROXY="$no_proxy"'
   end
   return '$env:http_proxy="' .. proxy .. '"; $env:HTTP_PROXY=$env:http_proxy; $env:https_proxy="' .. proxy .. '"; $env:HTTPS_PROXY=$env:https_proxy; $env:no_proxy="localhost,127.0.0.1"; $env:NO_PROXY=$env:no_proxy'
end

-- 当前窗格需要 bash 语法时返回 true；无法判断时按 Windows shell 处理
local function is_unix_shell(pane)
   -- WSL 域里跑的是 Linux shell，且域内前台进程名取不到，按域名判断
   local domain = (pane:get_domain_name() or ''):lower()
   if domain:find('wsl', 1, true) then
      return true
   end
   -- 前台是 ssh/docker 等时，实际接收输入的是远端 Linux shell
   local name = (pane:get_foreground_process_name() or ''):lower()
   for _, pattern in ipairs({ 'bash', 'zsh', 'fish', 'wsl', 'ssh', 'docker', 'podman', 'kubectl' }) do
      if name:find(pattern, 1, true) then
         return true
      end
   end
   return false
end

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },

   -- custom commands --
   {
      key = 'F6',
      mods = 'NONE',
      action = act.InputSelector({
         title = 'Quick Commands',
          choices = {
             { label = 'Set Proxy', id = 'proxy' },
             { label = 'Set Proxy + dsh web', id = 'dsh-web' },
          },
          action = wezterm.action_callback(function(window, pane, id)
             if id == 'proxy' or id == 'dsh-web' then
                -- 按当前窗格环境自动选择 PowerShell / bash 语法
                pane:send_text(proxy_env(is_unix_shell(pane)) .. '\r')
                -- dsh web 复用同一代理环境启动；--port 0 避开 3080 占用，--no-open 不弹浏览器
                if id == 'dsh-web' then
                   pane:send_text('dsh web --port 0 --no-open\r')
                end
             end
          end),
      }),
   },
   {
      key = 'u',
      mods = mod.SUPER,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- cursor movement --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },

   -- copy/paste --
   { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },
   { key = 'Insert',     mods = 'SHIFT',       action = act.PasteFrom('PrimarySelection') },

   -- tabs --
   -- tabs: spawn+close
   { key = 'Enter',      mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab('DefaultDomain') },
   { key = 'w',          mods = mod.SUPER,     action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
    { key = 'h',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
    { key = 'l',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
    { key = 'h',          mods = mod.SUPER .. '|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 'l',          mods = mod.SUPER .. '|SHIFT', action = act.MoveTabRelative(1) },

   -- window --
   -- spawn windows
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

    -- panes: close pane
    { key = 'x', mods = mod.SUPER_REV, action = act.CloseCurrentPane({ confirm = true }) },
    -- panes: zoom pane
    { key = 'z', mods = mod.SUPER, action = act.TogglePaneZoomState },

   -- panes: navigation
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

    -- scrollback
    { key = 'PageUp',   mods = 'SHIFT', action = act.ScrollByPage(-0.5) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(0.5) },

    -- fonts: resize
    { key = 'UpArrow',    mods = mod.SUPER_REV,     action = act.IncreaseFontSize },
    { key = 'DownArrow',  mods = mod.SUPER_REV,     action = act.DecreaseFontSize },
    { key = 'r',          mods = mod.SUPER_REV,     action = act.ResetFontSize },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
          timeout_milliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timeout_milliseconds = 1000,
      }),
   },
}

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
   -- Windows Terminal-style right-click:
   -- copy and clear the selection when text is selected; otherwise paste
   {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
         local selection = window:get_selection_text_for_pane(pane)

         if selection ~= '' then
            window:perform_action(act.CopyTo('Clipboard'), pane)
            window:perform_action(act.ClearSelection, pane)
         else
            window:perform_action(act.PasteFrom('Clipboard'), pane)
         end
      end),
   },
}

return {
   disable_default_key_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
