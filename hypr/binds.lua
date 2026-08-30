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
end, { auto_consuming = true, long_press = true,  description = "Close special workspace if open, else pass Escape through" })


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
    -- scrolling = hl.dsp.layout("focus down"),
    scrolling = hl.dsp.group.prev(),
    monocle = hl.dsp.layout("cycleprev"),
    master = hl.dsp.layout("cycleprev"),
    default = hl.dsp.focus({ direction = "down" })
}))
hl.bind(mainMod .. "+ K", layout_bind({
    -- scrolling = hl.dsp.layout("focus top"),
    scrolling = hl.dsp.group.next(),
    monocle = hl.dsp.layout("cyclenext"),
    master = hl.dsp.layout("cyclenext"),
    default = hl.dsp.focus({ direction = "up" })
}))
hl.bind(mainMod .. "+ up", layout_bind({
    scrolling = hl.dsp.layout("focus up"),
    monocle = hl.dsp.no_op(),
    master = hl.dsp.no_op(),
    default = hl.dsp.focus({ direction = "up" })
}))
hl.bind(mainMod .. "+ down", layout_bind({
    scrolling = hl.dsp.layout("focus down"),
    monocle = hl.dsp.no_op(),
    master = hl.dsp.no_op(),
    default = hl.dsp.focus({ direction = "down" })
}))
hl.bind(mainMod .. "+ left", layout_bind({
    scrolling = hl.dsp.layout("focus left"),
    monocle = hl.dsp.layout("cycleprev"),
    master = hl.dsp.layout("cycleprev"),
    default = hl.dsp.focus({ direction = "left" })
}))
hl.bind(mainMod .. "+ right", layout_bind({
    scrolling = hl.dsp.layout("focus right"),
    monocle = hl.dsp.layout("cyclenext"),
    master = hl.dsp.layout("cyclenext"),
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
--
-- Design: geometry (window x positions) is used ONLY to answer "am I
-- already at the edge of this workspace in this direction?" — a coarse
-- yes/no that stays correct even with window groups or a fullscreen
-- window elsewhere (hidden group tabs share their visible sibling's
-- position, so they don't skew the min/max; a fullscreen window's own
-- position is self-consistent within one snapshot).
--
-- The actual "who exactly is my neighbor" decision is NOT made by us —
-- it's delegated to the layout itself (hl.dsp.layout(message) for layouts
-- we know a message for, hl.dsp.focus({direction=...}) as the default),
-- since the layout has real knowledge of groups/fullscreen/tabs that we
-- can't reliably reconstruct from position data alone.
-- ============================================================

-- Per-layout "move focus within the workspace" messages. Add more layouts
-- here as needed; anything not listed falls back to native
-- hl.dsp.focus({direction=...}).
local LAYOUT_FOCUS_MESSAGE = {
  scrolling = { l = "focus left", r = "focus right" },
}

local function log(fmt, ...)
  print("[smart_nav] " .. string.format(fmt, ...))
end

-- Returns all *normal* workspaces (id > 0, i.e. excludes special/scratchpad
-- workspaces which have negative ids) that currently contain at least one
-- window, sorted ascending by id.
local function get_occupied_workspaces()
  local occ = {}
  for _, ws in ipairs(hl.get_workspaces()) do
    if ws.id > 0 and ws.windows and ws.windows > 0 then
      table.insert(occ, ws)
    end
  end
  table.sort(occ, function(a, b) return a.id < b.id end)
  return occ
end

-- Finds the nearest occupied workspace beyond `current_id` in `direction`.
local function find_next_occupied(occupied, current_id, direction)
  if direction == "r" then
    for _, ws in ipairs(occupied) do
      if ws.id > current_id then return ws end
    end
  else
    for i = #occupied, 1, -1 do
      if occupied[i].id < current_id then return occupied[i] end
    end
  end
  return nil
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

-- Returns a window's horizontal center. That's the only geometry we still
-- need (see file header) — no more full rect/overlap scoring.
local function center_x(w)
  local x = (w.at and w.at.x) or 0
  local width = (w.size and w.size.x) or 0
  return x + width / 2
end

-- Coarse edge check: is `active_win` already at the extreme edge (no other
-- window's center lies further in `direction`) among ALL windows in this
-- workspace? Deliberately does NOT try to pick a specific neighbor or
-- filter by group/visible state — see the file header for why.
local function at_workspace_edge(active_win, wins, direction)
  local acx = center_x(active_win)
  for _, w in ipairs(wins) do
    if w.address ~= active_win.address then
      local wcx = center_x(w)
      if (direction == "r" and wcx > acx) or (direction == "l" and wcx < acx) then
        return false
      end
    end
  end
  return true
end

-- Returns the workspace's current tiled layout name (e.g. "scrolling",
-- "dwindle", "master", "monocle"), or nil if unknown.
local function get_tiled_layout(ws)
  return ws.tiled_layout or ws.tiledLayout
end

-- Moves focus within the current workspace using the layout's own
-- semantics: a per-layout message when we have one (currently just
-- `scrolling`), otherwise the native direction dispatcher.
local function focus_within_workspace(layout, direction)
  local msg = (LAYOUT_FOCUS_MESSAGE[layout] or {})[direction]
  if msg then
    log("layout='%s' -> hl.dsp.layout('%s')", tostring(layout), msg)
    hl.dispatch(hl.dsp.layout(msg))
  else
    log("layout='%s' (no message registered) -> hl.dsp.focus(direction=%s)", tostring(layout), direction)
    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

-- Jumps to the next/previous occupied workspace, or (if none left in that
-- direction) keeps progressing linearly via a relative +1/-1 jump.
local function jump_to_workspace(current_id, direction)
  local target_ws = find_next_occupied(get_occupied_workspaces(), current_id, direction)

  if target_ws then
    log("jumping to occupied workspace id=%s", tostring(target_ws.id))
    -- Just switch to the workspace: Hyprland natively restores whichever
    -- window was last focused there. We intentionally do NOT force focus
    -- onto a specific window here — this is a workspace switch, not a
    -- "continue the linear window sequence" jump.
    hl.dispatch(hl.dsp.focus({ workspace = target_ws.id }))
    return
  end

  local rel = (direction == "r") and "+1" or "-1"
  log("no more occupied workspace, falling back to relative jump %s", rel)
  hl.dispatch(hl.dsp.focus({ workspace = rel }))
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
    log("dir=%s no current workspace found, aborting", direction)
    return
  end

  local layout = get_tiled_layout(current_ws)
  local is_special = (current_ws.id or 0) < 0

  log("dir=%s active_win=%s ws_id=%s ws_name=%s layout=%s is_special=%s",
      direction, tostring(active_win and active_win.title), tostring(current_ws.id),
      tostring(current_ws.name), tostring(layout), tostring(is_special))

  local wins = hl.get_workspace_windows(workspace_selector(current_ws)) or {}
  local edge = (not active_win) or at_workspace_edge(active_win, wins, direction)
  log("window_count=%d at_edge=%s", #wins, tostring(edge))

  if not edge then
    focus_within_workspace(layout, direction)
    return
  end

  if is_special then
    -- Special workspaces (scratchpads) never escalate to jumping to
    -- another workspace when at the edge — just stay put.
    log("special workspace, at edge -> staying put")
    return
  end

  -- At the edge of a normal workspace (or no window focused at all).
  -- Do NOT call the native focus(direction)/layout message here: under
  -- layouts like `scrolling`, it will auto-create/jump into a brand new
  -- empty workspace on its own, which breaks our own boundary logic.
  -- Instead, jump straight to the next/previous *occupied* normal
  -- workspace ourselves.
  jump_to_workspace(current_ws.id, direction)
end

hl.bind(mainMod .. " + H", function() smart_nav("l") end,
  { description = "Smart focus/workspace navigation left (no wrap)" })

hl.bind(mainMod .. " + L", function() smart_nav("r") end,
  { description = "Smart focus/workspace navigation right (no wrap)" })

--  Group
hl.bind(mainMod .. "+ ALT + G", hl.dsp.group.toggle())
hl.bind(mainMod .. "+ ALT + C", hl.dsp.group.lock_active({ action = "toggle" }))
hl.bind(mainMod .. " + up", hl.dsp.group.next())
hl.bind(mainMod .. " + down", hl.dsp.group.prev())
