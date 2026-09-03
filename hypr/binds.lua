local scratchpads = require("scratchpads")

local DEFAULT_BORDER_SIZE = hl.get_config("general.border_size")

------------------
-- MY PROGRAMS  --
------------------
local terminal    = "kitty"
local fileManager = "kitty -T yazi -e yazi"

------------------
--   HELPERS    --
------------------
local MOD = "SUPER" -- main modifier (Windows key)
local NOCTALIA_IPC = "noctalia msg "

local function Noctalia(cmd) return hl.dsp.exec_cmd(NOCTALIA_IPC .. cmd) end
local function S(key) return MOD .. " + " .. key end

-- Per-layout binds: same key, different action depending on active layout
local function layout_bind(bind_table)
    return function()
        local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
        if not workspace then return end
        local layout = workspace.tiled_layout
        if bind_table[layout] then
            hl.dispatch(bind_table[layout])
        elseif bind_table.default then
            hl.dispatch(bind_table.default)
        end
    end
end

------------------
--     CORE     --
------------------
hl.bind(S("SHIFT + R"), function() hl.dispatch(hl.dsp.exec_cmd("hyprctl reload")) end, { description = "Reload Hyprland" })
hl.bind("ALT + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("ALT + SHIFT + Q", hl.dsp.window.kill(), { description = "Kill window" })
hl.bind(S("SHIFT + M"), hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"), { description = "Exit Hyprland / hyprshutdown" })
hl.bind(S("T"), hl.dsp.exec_cmd(terminal), { description = "Open terminal" })

------------------
--   NOCTALIA   --
------------------
hl.bind(S("Space"), Noctalia("panel-toggle launcher"), { description = "Noctalia: launcher" })
hl.bind(S("SHIFT + comma"), Noctalia("settings-toggle"), { description = "Noctalia: settings" })
hl.bind(S("SHIFT + Escape"), Noctalia("panel-toggle session"), { description = "Noctalia: session menu" })
hl.bind(S("CTRL + V"), Noctalia("panel-toggle clipboard"), { description = "Noctalia: clipboard" })
hl.bind(S("o"), Noctalia("window-switcher"), { description = "Noctalia: window switcher" })
hl.bind(S("CTRL + S"), Noctalia("screenshot-region"), { description = "Noctalia: screenshot region" })
hl.bind(S("CTRL + SHIFT + up"), Noctalia("volume-up"), { description = "Volume up (Noctalia)" })
hl.bind(S("CTRL + SHIFT + down"), Noctalia("volume-down"), { description = "Volume down (Noctalia)" })
hl.bind(S("CTRL + SHIFT + right"), Noctalia("brightness-up"), { description = "Brightness up (Noctalia)" })
hl.bind(S("CTRL + SHIFT + left"), Noctalia("brightness-down"), { description = "Brightness down (Noctalia)" })

-- Bar auto-hide toggle (persisted to cache)
local function get_bar_cache_path()
    local xdg = os.getenv("XDG_CACHE_HOME")
    if xdg and xdg ~= "" then return xdg .. "/noctalia/bar-autohide" end
    return (os.getenv("HOME") or "") .. "/.cache/noctalia/bar-autohide"
end

hl.bind(S("CTRL + B"), function()
    local path = get_bar_cache_path()
    local dir = path:match("(.+)/[^/]+$")
    if dir then os.execute("mkdir -p '" .. dir .. "'") end
    local cur = "0"
    local f = io.open(path, "r")
    if f then
        local c = f:read("*l"); f:close()
        if c then c = c:gsub("%s+", ""); if c == "0" or c == "1" then cur = c end end
    end
    local nxt, cmd = cur == "1" and "0" or "1", cur == "1" and "off" or "on"
    local wf = io.open(path, "w"); if wf then wf:write(nxt .. "\n"); wf:close() end
    hl.dispatch(Noctalia("bar-auto-hide-set " .. cmd))
    hl.dispatch(Noctalia("bar-reserve-toggle"))
    hl.dispatch(Noctalia("dock-toggle"))
    hl.dispatch(Noctalia(cmd == "on" and "bar-layer-set overlay" or "bar-layer-set top"))
end, { description = "Toggle bar auto-hide + reserve + dock" })

------------------
-- MEDIA / HW   --
------------------
-- Unified XF86 binds (noctalia, with locked/repeating). Previously duplicated with raw wpctl/brightnessctl.
hl.bind("XF86AudioRaiseVolume", Noctalia("volume-up"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", Noctalia("volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", Noctalia("volume-mute"), { locked = true, repeating = true, description = "Volume mute toggle" })
hl.bind("XF86MonBrightnessUp", Noctalia("brightness-up"), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", Noctalia("brightness-down"), { locked = true, repeating = true, description = "Brightness down" })
-- No noctalia equivalent — keep raw
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true, description = "Mic mute toggle" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Media: next track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: play/pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: play/pause" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Media: previous track" })

------------------
-- SCRATCHPADS  --
------------------
hl.bind(S("E"), function()
    scratchpads.show_or_hide_app(hl.dsp.exec_cmd(fileManager, { float = true, size = { 1200, 700 } }), { title = "yazi" })
end, { description = "Scratchpad: yazi file manager" })
hl.bind(S("return"), function()
    scratchpads.show_or_hide_app(hl.dsp.exec_cmd("kitty -T term sh -c 'fastfetch --logo-type kitty; exec $SHELL'", {
        float = true, size = { 1200, 900 },
    }), { title = "term" })
end, { description = "Scratchpad: term (fastfetch)" })
hl.bind(S("X"), function() scratchpads.minimize_app() end, { description = "Minimize / hide scratchpad" })

------------------
--   TOGGLES    --
------------------
hl.bind(S("SHIFT + G"), function()
    local gaps = hl.get_config("general.gaps_in")
    local zero = gaps.top == 5
    hl.config({ general = { gaps_in = zero and 0 or 5, gaps_out = zero and 0 or 5 } })
end, { description = "Toggle gaps in/out (0 ↔ 5)" })

hl.bind(S("CTRL + F"), function()
    if hl.get_config("decoration.dim_inactive") == false then
        hl.config({ general = { border_size = 0 }, decoration = { dim_inactive = true } })
    else
        hl.config({ general = { border_size = DEFAULT_BORDER_SIZE }, decoration = { dim_inactive = false } })
    end
end, { description = "Toggle dim inactive + border" })

hl.bind(S("B"), function()
    local bs = hl.get_config("general.border_size")
    hl.config({ general = { border_size = bs == 0 and DEFAULT_BORDER_SIZE or 0 } })
end, { description = "Toggle border width" })

------------------
--    WINDOW    --
------------------
hl.bind("ALT + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(S("V"), function()
    hl.dispatch(hl.dsp.window.cycle_next({ floating = not hl.get_active_window().floating }))
end, { description = "Switch focus between tiled and floating windows" })
hl.bind(S("SHIFT + P"), hl.dsp.window.pseudo(), { description = "Toggle pseudo-tiling" })
hl.bind(S("P"), function() hl.dispatch(hl.dsp.focus({ last = true })) end, { description = "Focus last window" })
hl.bind("ALT + A", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle", layout_aware = true }), { description = "Fullscreen maximize toggle" })
hl.bind("ALT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", layout_aware = true }), { description = "Fullscreen toggle" })
hl.bind(S("mouse:272"), hl.dsp.window.drag(), { mouse = true, description = "Move window (drag)" })
hl.bind(S("mouse:273"), hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

------------------
--  WORKSPACES  --
------------------
for i = 1, 10 do
    local key = i % 10
    hl.bind(S(tostring(key)), hl.dsp.focus({ workspace = i }), { description = "Focus workspace " .. i })
    hl.bind(S("SHIFT + " .. key), hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end
hl.bind(S("bracketright"), hl.dsp.focus({ workspace = "+1" }), { description = "Focus next workspace" })
hl.bind(S("SHIFT + bracketright"), hl.dsp.window.move({ workspace = "+1" }), { description = "Move window to next workspace" })
hl.bind(S("bracketleft"), hl.dsp.focus({ workspace = "-1" }), { description = "Focus previous workspace" })
hl.bind(S("SHIFT + bracketleft"), hl.dsp.window.move({ workspace = "-1" }), { description = "Move window to previous workspace" })
hl.bind(S("mouse_down"), hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll to next workspace" })
hl.bind(S("mouse_up"), hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll to previous workspace" })

-- Special workspaces
hl.bind(S("S"), hl.dsp.workspace.toggle_special("magic"), { description = "Toggle special: magic" })
hl.bind(S("SHIFT + S"), hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move window to special: magic" })
hl.bind(S("W"), hl.dsp.workspace.toggle_special("work"), { description = "Toggle special: work" })
hl.bind(S("SHIFT + W"), hl.dsp.window.move({ workspace = "special:work" }), { description = "Move window to special: work" })
hl.bind("Escape", function()
    local special_wp = hl.get_active_special_workspace()
    if special_wp then
        hl.dispatch(hl.dsp.workspace.toggle_special(special_wp.name:gsub("^special:", "")))
    else
        return { ok = false }
    end
end, { auto_consuming = true, long_press = true, description = "Close special workspace if open, else pass Escape through" })

------------------
-- LAYOUT-AWARE --
------------------
hl.bind(S("comma"), layout_bind({ scrolling = hl.dsp.layout("move +100") }), { description = "Scrolling: scroll +100" })
hl.bind(S("period"), layout_bind({ scrolling = hl.dsp.layout("move -100") }), { description = "Scrolling: scroll -100" })
hl.bind(S("equal"), layout_bind({ scrolling = hl.dsp.layout("colresize +conf") }), { description = "Scrolling: resize column (+conf)" })
hl.bind(S("minus"), layout_bind({ scrolling = hl.dsp.layout("colresize -conf") }), { description = "Scrolling: resize column (-conf)" })
hl.bind(S("CTRL + L"), layout_bind({ scrolling = hl.dsp.layout("consume_or_expel next") }), { description = "Scrolling: consume/expel next" })
hl.bind(S("CTRL + H"), layout_bind({ scrolling = hl.dsp.layout("consume_or_expel prev") }), { description = "Scrolling: consume/expel prev" })
hl.bind(S("slash"), layout_bind({ scrolling = hl.dsp.layout("inhibit_scroll") }), { description = "Scrolling: inhibit scroll" })
hl.bind(S("A"), layout_bind({ master = hl.dsp.layout("swapwithmaster") }), { description = "Master: swap with master" })
hl.bind(S("R"), layout_bind({ master = hl.dsp.layout("orientationcycle") }), { description = "Master: cycle orientation" })
hl.bind(S("J"), layout_bind({
    scrolling = hl.dsp.group.prev(),
    monocle = hl.dsp.layout("cycleprev"),
    master = hl.dsp.layout("cycleprev"),
    default = hl.dsp.focus({ direction = "down" }),
}), { description = "Focus down / prev (layout-aware)" })
hl.bind(S("K"), layout_bind({
    scrolling = hl.dsp.group.next(),
    monocle = hl.dsp.layout("cyclenext"),
    master = hl.dsp.layout("cyclenext"),
    default = hl.dsp.focus({ direction = "up" }),
}), { description = "Focus up / next (layout-aware)" })
hl.bind(S("up"), layout_bind({
    scrolling = hl.dsp.layout("focus up"), monocle = hl.dsp.no_op(), master = hl.dsp.no_op(),
    default = hl.dsp.focus({ direction = "up" }),
}), { description = "Focus up (layout-aware)" })
hl.bind(S("down"), layout_bind({
    scrolling = hl.dsp.layout("focus down"), monocle = hl.dsp.no_op(), master = hl.dsp.no_op(),
    default = hl.dsp.focus({ direction = "down" }),
}), { description = "Focus down (layout-aware)" })
hl.bind(S("left"), layout_bind({
    scrolling = hl.dsp.layout("focus left"), monocle = hl.dsp.layout("cycleprev"), master = hl.dsp.layout("cycleprev"),
    default = hl.dsp.focus({ direction = "left" }),
}), { description = "Focus left (layout-aware)" })
hl.bind(S("right"), layout_bind({
    scrolling = hl.dsp.layout("focus right"), monocle = hl.dsp.layout("cyclenext"), master = hl.dsp.layout("cyclenext"),
    default = hl.dsp.focus({ direction = "right" }),
}), { description = "Focus right (layout-aware)" })
hl.bind(S("SHIFT + H"), layout_bind({
    scrolling = hl.dsp.layout("swapcol l"), dwindle = hl.dsp.layout("swapsplit"),
}), { description = "Swap column left / swap split (layout-aware)" })
hl.bind(S("SHIFT + L"), layout_bind({
    scrolling = hl.dsp.layout("swapcol r"), dwindle = hl.dsp.layout("togglesplit"),
}), { description = "Swap column right / toggle split (layout-aware)" })

------------------
--    MODES     --
------------------
local function toggle_game_mode()
    if hl.get_config("decoration.shadow.enabled") == false then
        hl.exec_cmd("hyprctl reload")
        hl.exec_cmd(NOCTALIA_IPC .. [[notification-show '{
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
        general = { gaps_in = 0, gaps_out = 0 },
        decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0, dim_inactive = false },
    })
    hl.window_rule({ name = "magnetic-open", match = { class = ".*" }, tag = "-shader_open:/home/fitrah/.config/hypr/shaders/magnetic-open.glsl" })
    hl.window_rule({ name = "magnetic-close", match = { class = ".*" }, tag = "-shader_close:/home/fitrah/.config/hypr/shaders/magnetic-close.glsl" })
    hl.window_rule({ name = "floating-smoke", match = { float = true }, tag = "-shader_floating:/home/fitrah/.config/hypr/shaders/floating-smoke.glsl" })
    hl.exec_cmd(NOCTALIA_IPC .. [[notification-show '{
        "app_name":"👀 Noctalia",
        "summary":"FOCUS MODE ENABLED",
        "body":"Focus profile activated\n• Blur OFF\n• Borders OFF",
        "urgency":"critical",
        "timeout_ms":2000,
        "icon":"gamepad-2"
    }']])
end
hl.bind("F1", toggle_game_mode, { description = "Toggle focus/game mode (no blur/shadow)" })

local function cycle_layout()
    local layouts = { "scrolling", "master", "monocle" }
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not workspace then return end
    local next_layout = "dwindle"
    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            next_layout = layouts[(i % #layouts) + 1]; break
        end
    end
    local target = workspace.special and tostring(workspace.name) or tostring(workspace.id)
    hl.workspace_rule({ workspace = target, layout = next_layout })
    hl.notification.create({ text = "Layout: " .. next_layout, timeout = 1500, icon = "info" })
end
hl.bind(S("N"), cycle_layout, { description = "Cycle layout (scrolling → master → monocle)" })

------------------
--  ZOOM / MISC --
------------------
local MAX_ZOOM, MIN_ZOOM, ZOOM_TOGGLE_FACTOR = 3, 1, 1.5
local function zoom(offset)
    local cur = hl.get_config("cursor.zoom_factor")
    cur = offset ~= nil and cur + offset or cur ~= MIN_ZOOM and MIN_ZOOM or ZOOM_TOGGLE_FACTOR
    hl.config({ cursor = { zoom_factor = math.max(MIN_ZOOM, math.min(MAX_ZOOM, cur)) } })
end
hl.bind(S("CTRL + Z"), zoom, { description = "Toggle zoom" })
hl.bind(S("CTRL + Up"), function() zoom(0.5) end, { description = "Zoom in" })
hl.bind(S("CTRL + Down"), function() zoom(-0.5) end, { description = "Zoom out" })
hl.bind(S("SHIFT + Q"), function()
    hl.dispatch(hl.dsp.window.tag({ tag = "sensitive", window = hl.get_active_window() }))
end, { description = "Tag window as sensitive" })
hl.bind(S("ALT + G"), hl.dsp.group.toggle(), { description = "Group: toggle" })
hl.bind(S("ALT + C"), hl.dsp.group.lock_active({ action = "toggle" }), { description = "Group: toggle lock" })
hl.bind(S("up"), hl.dsp.group.next(), { description = "Group: next window" })
hl.bind(S("down"), hl.dsp.group.prev(), { description = "Group: previous window" })

------------------
-- SMART NAV H/L --
------------------
-- Mod+H/L: focus left/right within workspace, or jump to next occupied workspace (no wrap)
local LAYOUT_FOCUS_MESSAGE = { scrolling = { l = "focus left", r = "focus right" } }

local function get_occupied_workspaces()
    local occ = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        if ws.id > 0 and ws.windows and ws.windows > 0 then table.insert(occ, ws) end
    end
    table.sort(occ, function(a, b) return a.id < b.id end)
    return occ
end
local function find_next_occupied(occupied, current_id, direction)
    if direction == "r" then
        for _, ws in ipairs(occupied) do if ws.id > current_id then return ws end end
    else
        for i = #occupied, 1, -1 do if occupied[i].id < current_id then return occupied[i] end end
    end
end
local function workspace_selector(ws) return ws.id and ws.id > 0 and ws.id or ws.name end
local function center_x(w) return (w.at and w.at.x or 0) + (w.size and w.size.x or 0) / 2 end
local function at_workspace_edge(active_win, wins, direction)
    local acx = center_x(active_win)
    for _, w in ipairs(wins) do
        if w.address ~= active_win.address and ((direction == "r" and center_x(w) > acx) or (direction == "l" and center_x(w) < acx)) then
            return false
        end
    end
    return true
end
local function get_tiled_layout(ws) return ws.tiled_layout or ws.tiledLayout end
local function focus_within_workspace(layout, direction)
    local msg = (LAYOUT_FOCUS_MESSAGE[layout] or {})[direction]
    if msg then hl.dispatch(hl.dsp.layout(msg)) else hl.dispatch(hl.dsp.focus({ direction = direction })) end
end
local function jump_to_workspace(current_id, direction)
    local target = find_next_occupied(get_occupied_workspaces(), current_id, direction)
    if target then hl.dispatch(hl.dsp.focus({ workspace = target.id })); return end
    hl.dispatch(hl.dsp.focus({ workspace = direction == "r" and "+1" or "-1" }))
end
local function smart_nav(direction)
    local active_win = hl.get_active_window()
    local current_ws = (active_win and active_win.workspace) or hl.get_active_workspace()
    if not current_ws then return end
    local wins = hl.get_workspace_windows(workspace_selector(current_ws)) or {}
    local edge = (not active_win) or at_workspace_edge(active_win, wins, direction)
    if not edge then focus_within_workspace(get_tiled_layout(current_ws), direction); return end
    if (current_ws.id or 0) < 0 then return end
    jump_to_workspace(current_ws.id, direction)
end
hl.bind(S("H"), function() smart_nav("l") end, { description = "Smart focus/workspace navigation left (no wrap)" })
hl.bind(S("L"), function() smart_nav("r") end, { description = "Smart focus/workspace navigation right (no wrap)" })
