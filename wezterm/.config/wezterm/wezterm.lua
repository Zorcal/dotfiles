local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- OpenGL for GPU acceleration, Software for CPU
config.front_end = 'OpenGL'

------------------------------------
-- Events
------------------------------------

local function get_child_dirs(parent_dir)
  local pfile = assert(io.popen(("find '%s' -mindepth 1 -maxdepth 1 -type d -printf '%%f\\0'"):format(parent_dir), 'r'))
  local list = pfile:read '*a'
  pfile:close()

  local child_dirs = {}
  for filename in string.gmatch(list, '[^%z]+') do
    table.insert(child_dirs, filename)
  end

  return child_dirs
end

local function path_exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
local function is_dir(path)
  -- "/" works on both Unix and Windows
  return path_exists(path .. '/')
end

wezterm.on('update-right-status', function(window, _)
  window:set_right_status(window:active_workspace())
end)

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then
    args = cmd.args
  end

  mux.spawn_window { workspace = 'default', cwd = wezterm.home_dir, args = args }
  mux.set_active_workspace 'default'
end)

------------------------------------
-- Appearance
------------------------------------

config.color_scheme = 'ayu'
-- config.color_scheme = 'Alabaster'

-- Transparency
config.window_background_opacity = 1
config.font_size = 12
config.line_height = 1.0
config.dpi = 96.0

-- Padding
local horizontalPadding = 0
local verticalPadding = 0
config.window_padding = {
  left = horizontalPadding,
  right = horizontalPadding,
  top = verticalPadding,
  bottom = verticalPadding,
}

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 0

config.scrollback_lines = 10000

------------------------------------
-- Key bindings
------------------------------------
config.skip_close_confirmation_for_processes_named = {}
config.disable_default_key_bindings = true
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Leader fix: Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A.
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendString '\x01' },
  -- Move between panes.
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 's', mods = 'LEADER', action = act.PaneSelect },
  -- Create/close panes.
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  -- Move between tabs.
  { key = '1', mods = 'LEADER', action = act.MoveTab(1 - 1) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(1 - 1) },
  { key = '2', mods = 'LEADER', action = act.MoveTab(2 - 1) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(2 - 1) },
  { key = '3', mods = 'LEADER', action = act.MoveTab(3 - 1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(3 - 1) },
  { key = '4', mods = 'LEADER', action = act.MoveTab(3 - 1) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(4 - 1) },
  { key = '5', mods = 'LEADER', action = act.MoveTab(5 - 1) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(5 - 1) },
  { key = '6', mods = 'LEADER', action = act.MoveTab(6 - 1) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(6 - 1) },
  { key = '7', mods = 'LEADER', action = act.MoveTab(7 - 1) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(7 - 1) },
  { key = '8', mods = 'LEADER', action = act.MoveTab(8 - 1) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(8 - 1) },
  { key = '9', mods = 'LEADER', action = act.MoveTab(9 - 1) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(9 - 1) },
  { key = 'p', mods = 'LEADER', action = act.MoveTabRelative(-1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.MoveTabRelative(1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  -- Create/close tabs.
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  -- Copy/paste.
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'ClipboardAndPrimarySelection' },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  -- Launcher.
  { key = 's', mods = 'LEADER|SHIFT', action = act.ShowLauncher },
  -- Workspaces.
  {
    key = 'w',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {
    key = 'f',
    mods = 'CTRL',
    -- Asks to select a workspace from a list of pre-defined and already existing workspaces.
    -- First, if the selected workspace does not already exist, spawn a window in it with
    -- a specifed cwd. Then, switch to the workspace.
    action = act.InputSelector {
      title = 'Select workspace',
      choices = (function()
        local choices = {}

        -- Add existing workspaces to the list of choices.
        for _, name in pairs(mux.get_workspace_names()) do
          table.insert(choices, { label = name, id = name })
        end

        -- Keep track of added workspaces.
        local added = {}
        for _, choice in pairs(choices) do
          added[choice.label] = true
        end

        local function add_workspace(path, choice)
          if added[path] == nil then
            table.insert(choices, choice)
            added[path] = true
          end
        end

        -- Add pre-defined workspaces to the list of choices if they exist.
        local dirs = {
          {
            path = wezterm.home_dir .. '/.dotfiles',
            with_subdirs = false,
          },
          {
            path = wezterm.home_dir .. '/.config/nvim',
            with_subdirs = false,
          },
          {
            path = wezterm.home_dir .. '/Scratch',
            with_subdirs = false,
          },
          {
            path = wezterm.home_dir .. '/Work',
            with_subdirs = true,
          },
          {
            path = wezterm.home_dir .. '/Projects',
            with_subdirs = true,
          },
        }
        for _, dir in pairs(dirs) do
          if not is_dir(dir.path) then
            wezterm.log_error('directory ' .. dir.path .. ' does not exist.')
            goto continue
          end

          add_workspace(dir.path, { label = dir.path, id = dir.path })

          if dir.with_subdirs then
            -- Only one level of recursion.
            for _, name in pairs(get_child_dirs(dir.path)) do
              local path = dir.path .. '/' .. name
              add_workspace(path, { label = path, id = path })
            end
          end

          ::continue::
        end

        table.sort(choices, function(a, b)
          return a.label < b.label
        end)

        return choices
      end)(),
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id and not label then
          return
        end

        local workspace_exists = false
        for _, name in pairs(mux.get_workspace_names()) do
          if name == id then
            workspace_exists = true
            break
          end
        end

        if not workspace_exists then
          mux.spawn_window { workspace = label, cwd = id }
          wezterm.log_info('spawning window for ' .. id .. '.')
        end

        window:perform_action(
          act.SwitchToWorkspace {
            name = label,
          },
          pane
        )
      end),
    },
  },
  { key = 'n', mods = 'LEADER|SHIFT', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'LEADER|SHIFT', action = act.SwitchWorkspaceRelative(-1) },
  -- Search.
  { key = '/', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = ' ', mods = 'LEADER', action = wezterm.action.QuickSelect },
}
config.key_tables = {
  search_mode = {
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
    { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
    { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
    { key = 'u', mods = 'CTRL', action = act.CopyMode 'NextMatchPage' },
    { key = 'd', mods = 'CTRL', action = act.CopyMode 'PriorMatchPage' },
  },
}

------------------------------------
-- General
------------------------------------
config.automatically_reload_config = true
config.window_close_confirmation = 'NeverPrompt'

return config
