local scratchpads = require("scratchpads")

local DEFAULT_BORDER_SIZE = hl.get_config("general.border_size")

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
hl.bind(mainMod .. "+ CTRL + SHIFT + up", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind(mainMod .. "+ CTRL + SHIFT + down", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind(mainMod .. "+ CTRL + SHIFT + right", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind(mainMod .. "+ CTRL + SHIFT + left", hl.dsp.exec_cmd(ipc .. "brightness-down"))

local function get_bar_cache_path()
    local xdg = os.getenv("XDG_CACHE_HOME")
    if xdg and xdg ~= "" then
        return xdg .. "/noctalia/bar-autohide"
    end
    return (os.getenv("HOME") or "") .. "/.cache/noctalia/bar-autohide"
end

hl.bind(mainMod .. "+ CTRL + B", function()
    local path = get_bar_cache_path()
    local dir = path:match("(.+)/[^/]+$")
    if dir then os.execute("mkdir -p '" .. dir .. "'") end
    local cur = "0"
    local f = io.open(path, "r")
    if f then
        local c = f:read("*l")
        f:close()
        if c then
            c = c:gsub("%s+", "")
            if c == "0" or c == "1" then cur = c end
        end
    end
    local nxt, cmd
    if cur == "1" then nxt = "0"; cmd = "off" else nxt = "1"; cmd = "on" end
    local wf = io.open(path, "w")
    if wf then wf:write(nxt .. "\n"); wf:close() end
    hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-auto-hide-set " .. cmd))
    hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-reserve-toggle"))
    hl.dispatch(hl.dsp.exec_cmd(ipc .. "dock-toggle"))
    if cmd == "on" then
        hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-layer-set overlay"))
    else
        hl.dispatch(hl.dsp.exec_cmd(ipc .. "bar-layer-set top"))
    end
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
                border_size = DEFAULT_BORDER_SIZE
            },
            decoration = {
                dim_inactive = false,
            }
        })
    end
end)

hl.bind("ALT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. "+ V", function()
    hl.dispatch(hl.dsp.window.cycle_next({
        floating = not hl.get_active_window().floating
    }))
end, { description = "Switch focus between tiled and floating windows" })
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

-- Game mode toggle (inline dari modes.lua)
local function toggle_game_mode()
    local game_mode = (hl.get_config("decoration.shadow.enabled") == false)

    if game_mode then
        hl.exec_cmd("hyprctl reload")
        hl.exec_cmd(ipc .. [[notification-show '{
            "app_name":"👀 Noctalia",
            "summary":"FOCUS MODE DISABLED",
            "body":"Desktop effects restored",
            "urgency":"normal",
            "timeout_ms":1000,
            "icon":"monitor"
        }']])
        return
    end

    hl.config({
        general = {
            gaps_in = 0, gaps_out = 0, -- Disable gaps
        },
        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
            dim_inactive = false
        }
    })
    hl.window_rule({ name = "magnetic-open", match = { class = ".*" }, tag = "-shader_open:/home/fitrah/.config/hypr/shaders/magnetic-open.glsl" })
    hl.window_rule({ name = "magnetic-close", match = { class = ".*" }, tag = "-shader_close:/home/fitrah/.config/hypr/shaders/magnetic-close.glsl" })
    hl.window_rule({ name = "floating-smoke", match = { float = true }, tag = "-shader_floating:/home/fitrah/.config/hypr/shaders/floating-smoke.glsl" })
    hl.exec_cmd(ipc .. [[notification-show '{
        "app_name":"👀 Noctalia",
        "summary":"FOCUS MODE ENABLED",
        "body":"Focus profile activated\n• Blur OFF\n• Borders OFF",
        "urgency":"critical",
        "timeout_ms":2000,
        "icon":"gamepad-2"
    }']])
end

hl.bind("F1", toggle_game_mode)

-- Cycle layout: scrolling -> master -> monocle
local function cycle_layout()
    local layouts     = { "scrolling", "master", "monocle" }
    local workspace   = hl.get_active_workspace()
    if hl.get_active_special_workspace() then
        workspace = hl.get_active_special_workspace()
    end

    local next_layout = "dwindle"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

    if workspace.special then
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
    else
        hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
    end

    hl.notification.create({ text = "Layout: " .. next_layout, timeout = 1500, icon = "info" })
end

hl.bind(mainMod .. " + N", cycle_layout)


hl.bind(mainMod .. " + B", function()
    local bs = hl.get_config("general.border_size")
    if bs == 0 then
        hl.config({ general = { border_size = DEFAULT_BORDER_SIZE } })
    else
        hl.config({ general = { border_size = 0 } })
    end
end, { description = "Toggle border width" })

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

-- Smart Focus: Mod+H/L — focus left/right within workspace, or jump to next occupied workspace (no wrap)
-- At edge, delegate to layout message if available, else hl.dsp.focus; special workspaces stay put.
local LAYOUT_FOCUS_MESSAGE = {
  scrolling = { l = "focus left", r = "focus right" },
}

local function get_occupied_workspaces() -- normal workspaces (id>0) with windows, sorted
  local occ = {}
  for _, ws in ipairs(hl.get_workspaces()) do
    if ws.id > 0 and ws.windows and ws.windows > 0 then
      table.insert(occ, ws)
    end
  end
  table.sort(occ, function(a, b) return a.id < b.id end)
  return occ
end

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

local function workspace_selector(ws) -- id>0 ? id : name (special needs name)
  if ws.id and ws.id > 0 then
    return ws.id
  end
  return ws.name
end

local function center_x(w)
  local x = (w.at and w.at.x) or 0
  local width = (w.size and w.size.x) or 0
  return x + width / 2
end

local function at_workspace_edge(active_win, wins, direction) -- true if at extreme edge
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

local function get_tiled_layout(ws)
  return ws.tiled_layout or ws.tiledLayout
end

local function focus_within_workspace(layout, direction)
  local msg = (LAYOUT_FOCUS_MESSAGE[layout] or {})[direction]
  if msg then
    hl.dispatch(hl.dsp.layout(msg))
  else
    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

local function jump_to_workspace(current_id, direction)
  local target_ws = find_next_occupied(get_occupied_workspaces(), current_id, direction)
  if target_ws then
    hl.dispatch(hl.dsp.focus({ workspace = target_ws.id }))
    return
  end
  local rel = (direction == "r") and "+1" or "-1"
  hl.dispatch(hl.dsp.focus({ workspace = rel }))
end

local function smart_nav(direction)
  local active_win = hl.get_active_window()
  local current_ws = (active_win and active_win.workspace) or hl.get_active_workspace()
  if not current_ws then return end
  local layout = get_tiled_layout(current_ws)
  local is_special = (current_ws.id or 0) < 0
  local wins = hl.get_workspace_windows(workspace_selector(current_ws)) or {}
  local edge = (not active_win) or at_workspace_edge(active_win, wins, direction)
  if not edge then
    focus_within_workspace(layout, direction)
    return
  end
  if is_special then return end
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
