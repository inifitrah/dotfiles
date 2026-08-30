local scratchpads = require("modules.scratchpads")
local modes       = require("modules.modes")
local workspaces  = require("modules.workspaces")
------------------
-- MY PROGRAMS  --
------------------
local terminal    = "kitty"
local fileManager = "kitty -T yazi -e yazi"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod     = "SUPER" -- Sets "Windows" key as main modifier
local ipc         = "noctalia msg "

-- Per-layout binds: same key, different action depending on the active layout
local function layout_bind(bind_table)
    return function()
        local workspace = hl.get_active_special_workspace() or
            hl.get_active_workspace()

        if not workspace then
            return
        end

        local layout = workspace.tiled_layout

        if bind_table[layout] then
            hl.dispatch(bind_table[layout])
        elseif bind_table.default then
            hl.dispatch(bind_table.default)
        end
    end
end

hl.bind(mainMod .. "+ SHIFT + R", function()
    hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
end)

-- Noctalia
-- Core binds
hl.bind(mainMod .. "+ Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+ SHIFT + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. "+ SHIFT + Escape", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
hl.bind(mainMod .. "+ CTRL + V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind(mainMod .. "+ o", hl.dsp.exec_cmd(ipc .. "window-switcher"))
-- screenshot
hl.bind(mainMod .. "+ CTRL + S", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

local autoHide = false
hl.bind(mainMod .. "+ CTRL + B", function ()
    autoHide = not autoHide
    if autoHide then
        hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-auto-hide-set on"))
    else
        hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-auto-hide-set off"))
    end
    hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-reserve-toggle"))
    hl.dispatch(hl.dsp.exec_cmd(ipc .. "dock-toggle"))
end)


-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))


-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind("ALT" .. " + Q", hl.dsp.window.close())
hl.bind("ALT + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Toggle applications like MangoWM named scratchpads.
hl.bind(mainMod .. " + E", function()
    scratchpads.show_or_hide_app(hl.dsp.exec_cmd(fileManager, {
        float = true,
        size = { 1200, 700 }
    }), {
        title = "yazi"
    })
end)
hl.bind(mainMod .. " + return", function()
    scratchpads.show_or_hide_app(hl.dsp.exec_cmd("kitty -T term sh -c 'fastfetch --logo-type kitty; exec $SHELL'", {
        float = true,
        size = { 1200, 900 },
        -- ["hyprbars:no_bar"] = true
    }), {
        title = "term"
    })
end)
hl.bind(mainMod .. " + X", function()
    scratchpads.minimize_app()
end)

-- Toggle gaps_in between 0 and 3 (equivalent to  {3, 3, 3, 3} )
hl.bind(mainMod .. " + SHIFT + G", function()
    local gapsInValueTable = hl.get_config("general.gaps_in")

    if gapsInValueTable.top == 5 then
        hl.config({
            general = { gaps_in = 0, gaps_out = 0 }
        })
    else
        hl.config({
            general = { gaps_in = 5, gaps_out = 5 }
        })
    end
end)

hl.bind(mainMod .. " + CTRL + F", function()
    local dimInactiveStatus = hl.get_config("decoration.dim_inactive")
    if dimInactiveStatus == false then
        hl.config({
            general = {
                border_size = 0
            },
            decoration = {
                dim_inactive = true,
            }
        })
    else
        hl.config({
            general = {
                border_size = 3
            },
            decoration = {
                dim_inactive = false,
            }
        })
    end
end)

hl.bind("ALT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. "+ SHIFT + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + P", function()
    hl.dispatch(hl.dsp.focus({ last = true }))
end)

hl.bind("ALT + A", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle", layout_aware = true }))
hl.bind("ALT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", layout_aware = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. "+ bracketright", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. "+ SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. "+ bracketleft", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. "+ SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- close special workspaces
hl.bind("Escape", function()
    local special_wp = hl.get_active_special_workspace()
    if special_wp then
        local name = special_wp.name:gsub("^special:", "")
        print("[Lua] closing special workspace: " .. name)
        hl.dispatch(hl.dsp.workspace.toggle_special(name))
    else
       return { ok = false }
    end
end, { auto_consuming = true,  description = "Close special workspace if open, else pass Escape through" })


hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("work"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:work" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))


-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Binds per-layout
hl.bind(mainMod .. "+ comma", layout_bind({
    scrolling = hl.dsp.layout("move +100"),
}))
hl.bind(mainMod .. "+ period", layout_bind({
    scrolling = hl.dsp.layout("move -100"),
}))
hl.bind(mainMod .. "+ equal", layout_bind({
    scrolling = hl.dsp.layout("colresize +conf"),
}))
hl.bind(mainMod .. "+ c", layout_bind({
    scrolling = hl.dsp.layout(""),
}))
hl.bind(mainMod .. "+ minus", layout_bind({
    scrolling = hl.dsp.layout("colresize -conf"),
}))
hl.bind(mainMod .. "+ CTRL + L", layout_bind({
    scrolling = hl.dsp.layout("consume_or_expel next"),
}))
hl.bind(mainMod .. "+ CTRL + H", layout_bind({
    scrolling = hl.dsp.layout("consume_or_expel prev"),
}))
hl.bind(mainMod .. "+ slash", layout_bind({
    scrolling = hl.dsp.layout("inhibit_scroll"),
}))
hl.bind(mainMod .. "+ A", layout_bind({
    master = hl.dsp.layout("swapwithmaster"),
}))
hl.bind(mainMod .. "+ R", layout_bind({
    master = hl.dsp.layout("orientationcycle"),
}))
hl.bind(mainMod .. "+ J", layout_bind({
    scrolling = hl.dsp.layout("focus down"),
    default = hl.dsp.focus({ direction = "down" })
}))
hl.bind(mainMod .. "+ K", layout_bind({
    scrolling = hl.dsp.layout("focus top"),
    default = hl.dsp.focus({ direction = "up" })
}))
hl.bind(mainMod .. "+ up", layout_bind({
    scrolling = hl.dsp.layout("focus up"),
    default = hl.dsp.focus({ direction = "up" })
}))
hl.bind(mainMod .. "+ down", layout_bind({
    scrolling = hl.dsp.layout("focus down"),
    default = hl.dsp.focus({ direction = "down" })
}))
hl.bind(mainMod .. "+ left", layout_bind({
    scrolling = hl.dsp.layout("focus left"),
    monocle = hl.dsp.layout("cycleprev"), -- Monocle: cycle prev window
    default = hl.dsp.focus({ direction = "left" })
}))
hl.bind(mainMod .. "+ right", layout_bind({
    scrolling = hl.dsp.layout("focus right"),
    monocle = hl.dsp.layout("cyclenext"), -- Monocle: cycle next window
    default = hl.dsp.focus({ direction = "right" })
}))
hl.bind(mainMod .. " + SHIFT + H", layout_bind({
    scrolling = hl.dsp.layout("swapcol l"), -- Scrolling: swap column with left one
    dwindle   = hl.dsp.layout("swapsplit"), -- Dwindle: swap window split
}))
hl.bind(mainMod .. " + SHIFT + L", layout_bind({
    scrolling = hl.dsp.layout("swapcol r"),   -- Scrolling: swap column with right one
    dwindle   = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
}))

-- Game mode toggle
hl.bind("F1", modes.toggle_game_mode)
-- Cycle layout: scrolling → dwindle → monocle
hl.bind(mainMod .. " + N", workspaces.cycle_layout)

-- Glass magnifier zoom
local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind(mainMod .. " + CTRL + Z", zoom)
hl.bind(mainMod .. " + CTRL + Up", function()
    zoom(0.5)
end)
hl.bind(mainMod .. " + CTRL + Down", function()
    zoom(-0.5)
end)

hl.bind(mainMod .. "+ SHIFT + Q", function()
    hl.dispatch(hl.dsp.window.tag({ tag = "sensitive", window = hl.get_active_window() }))
end)

-- ============================================================
-- Smart Focus & Non-Wrapping Workspace Navigation
-- Hyprland Lua v0.56.0+
--
-- Mod + H  -> focus left  (window, then previous occupied workspace)
-- Mod + L  -> focus right (window, then next occupied workspace)
-- No wrap-around at the first/last occupied workspace.
-- ============================================================

-- Returns all *normal* workspaces (id > 0, i.e. excludes special/scratchpad
-- workspaces which have negative ids) that currently contain at least one
-- window, sorted ascending by id.
local function get_occupied_workspaces()
  local all = hl.get_workspaces()
  local occ = {}
  for _, ws in ipairs(all) do
    if ws.id > 0 and ws.windows and ws.windows > 0 then
      table.insert(occ, ws)
    end
  end
  table.sort(occ, function(a, b) return a.id < b.id end)
  return occ
end

-- Returns a workspace's windows sorted left-to-right by x position.
local function get_sorted_workspace_windows(ws_id)
  local wins = hl.get_workspace_windows(ws_id)
  if not wins then
    return {}
  end
  table.sort(wins, function(a, b)
    local ax = (a.at and a.at.x) or 0
    local bx = (b.at and b.at.x) or 0
    return ax < bx
  end)
  return wins
end

-- Focuses the leftmost or rightmost window in a given workspace,
-- based on each window's x position.
local function focus_edge_window(ws_id, edge)
  local wins = get_sorted_workspace_windows(ws_id)
  if #wins == 0 then
    return
  end
  local target = (edge == "leftmost") and wins[1] or wins[#wins]
  if target then
    hl.dispatch(hl.dsp.focus({ window = target }))
  end
end

-- Returns the correct selector to use with hl.get_workspace_windows /
-- hl.dsp.focus({workspace=...}) for a given workspace object. Normal
-- workspaces use their numeric id, but special workspaces have negative
-- ids which aren't valid numeric selectors (Hyprland only accepts 1..2^31-1
-- as a numeric id) — for those we must use their name instead (e.g.
-- "special:magic").
local function workspace_selector(ws)
  if ws.id and ws.id > 0 then
    return ws.id
  end
  return ws.name
end

-- direction: "l" or "r"
local function smart_nav(direction)
  local active_win = hl.get_active_window()

  -- IMPORTANT: hl.get_active_workspace() returns the monitor's underlying
  -- *normal* workspace, NOT a special (scratchpad) workspace, even while a
  -- special workspace is open and focused on top of it. So to correctly
  -- detect "am I currently in a special workspace", we must look at the
  -- focused window's own `.workspace` field instead, which does reflect
  -- special workspaces (e.g. id -97 / name "special:magic").
  local current_ws = (active_win and active_win.workspace) or hl.get_active_workspace()
  if not current_ws then
    print("[smart_nav] dir=" .. direction .. " no current workspace found, aborting")
    return
  end

  print("[smart_nav] dir=" .. direction ..
        " active_win=" .. tostring(active_win and active_win.title) ..
        " ws_id=" .. tostring(current_ws.id) ..
        " ws_name=" .. tostring(current_ws.name))

  -- Special workspaces (scratchpads) are left alone: just use plain
  -- native directional focus there, no smart edge/workspace-jump logic.
  if current_ws.id and current_ws.id < 0 then
    print("[smart_nav] on SPECIAL workspace '" .. tostring(current_ws.name) ..
          "' (id=" .. tostring(current_ws.id) .. ") -> plain directional focus")
    hl.dispatch(hl.dsp.focus({ direction = direction }))
    return
  end

  local current_id = current_ws.id
  local wins = get_sorted_workspace_windows(workspace_selector(current_ws))
  print("[smart_nav] normal workspace id=" .. tostring(current_id) ..
        " window_count=" .. tostring(#wins))

  -- Find the active window's position within the sorted list.
  local idx = nil
  if active_win then
    for i, w in ipairs(wins) do
      if w.address == active_win.address then
        idx = i
        break
      end
    end
  end

  local at_edge
  if direction == "r" then
    at_edge = (idx == nil) or (idx == #wins)
  else
    at_edge = (idx == nil) or (idx == 1)
  end

  print("[smart_nav] idx=" .. tostring(idx) .. " at_edge=" .. tostring(at_edge))

  if not at_edge then
    -- There is a neighboring window in this workspace in the requested
    -- direction. Focus it directly by window object (rather than via the
    -- native focus(direction) dispatcher) since that dispatcher can get
    -- blocked or behave inconsistently when the active window is
    -- maximized/fullscreen (especially under layouts with their own
    -- fullscreen handling, like `scrolling`).
    local target = (direction == "r") and wins[idx + 1] or wins[idx - 1]
    print("[smart_nav] focusing neighbor window: " .. tostring(target and target.title))
    if target then
      hl.dispatch(hl.dsp.focus({ window = target }))
    end
    return
  end

  -- Already at the edge of the workspace (or no window focused at all).
  -- Do NOT call the native focus(direction) dispatcher here: under layouts
  -- like `scrolling`, it will auto-create/jump into a brand new empty
  -- workspace on its own, which breaks our own boundary logic below.
  -- Instead, jump straight to the next/previous *occupied* normal workspace
  -- ourselves.
  local occupied = get_occupied_workspaces()
  local target_ws = nil

  if direction == "r" then
    for _, ws in ipairs(occupied) do
      if ws.id > current_id then
        target_ws = ws
        break
      end
    end
  else
    for i = #occupied, 1, -1 do
      if occupied[i].id < current_id then
        target_ws = occupied[i]
        break
      end
    end
  end

  if target_ws then
    print("[smart_nav] jumping to occupied workspace id=" .. tostring(target_ws.id))
    hl.dispatch(hl.dsp.focus({ workspace = target_ws.id }))
    focus_edge_window(target_ws.id, direction == "r" and "leftmost" or "rightmost")
  else
    -- No further workspace with windows exists in this direction anymore.
    -- Instead of stopping dead, keep progressing linearly into the next
    -- workspace by id (empty, or newly created if it doesn't exist yet).
    local rel = (direction == "r") and "+1" or "-1"
    print("[smart_nav] no more occupied workspace, falling back to relative jump " .. rel)
    hl.dispatch(hl.dsp.focus({ workspace = rel }))
  end
end

hl.bind(mainMod .. " + H", function() smart_nav("l") end,
  { description = "Smart focus/workspace navigation left (no wrap)" })

hl.bind(mainMod .. " + L", function() smart_nav("r") end,
  { description = "Smart focus/workspace navigation right (no wrap)" })
