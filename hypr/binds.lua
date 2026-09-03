local scratchpads = require("scratchpads")
local helpers    = require("helpers")
local toggles    = require("toggles")
local focus      = require("focus_win_or_wp")

local S           = helpers.S
local Noctalia    = helpers.Noctalia
local layout_bind = helpers.layout_bind

------------------
-- MY PROGRAMS  --
------------------
local terminal    = "kitty"
local fileManager = "kitty -T yazi -e yazi"

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
hl.bind(S("CTRL + B"), toggles.toggle_bar, { description = "Toggle bar auto-hide + reserve + dock" })

------------------
-- MEDIA / HW   --
------------------
hl.bind("XF86AudioRaiseVolume", Noctalia("volume-up"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", Noctalia("volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", Noctalia("volume-mute"), { locked = true, repeating = true, description = "Volume mute toggle" })
hl.bind("XF86MonBrightnessUp", Noctalia("brightness-up"), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", Noctalia("brightness-down"), { locked = true, repeating = true, description = "Brightness down" })
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
hl.bind(S("SHIFT + G"), toggles.toggle_gaps, { description = "Toggle gaps in/out (0 ↔ 5)" })
hl.bind(S("CTRL + F"), toggles.toggle_dim, { description = "Toggle dim inactive + border" })
hl.bind(S("B"), toggles.toggle_border, { description = "Toggle border width" })

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
hl.bind("F1", toggles.toggle_game_mode, { description = "Toggle focus/game mode (no blur/shadow)" })
hl.bind(S("N"), toggles.cycle_layout, { description = "Cycle layout (scrolling → master → monocle)" })

------------------
--  ZOOM / MISC --
------------------
hl.bind(S("CTRL + Z"), toggles.zoom, { description = "Toggle zoom" })
hl.bind(S("CTRL + Up"), toggles.zoom_in, { description = "Zoom in" })
hl.bind(S("CTRL + Down"), toggles.zoom_out, { description = "Zoom out" })
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
hl.bind(S("H"), focus.smart_left, { description = "Smart focus/workspace navigation left (no wrap)" })
hl.bind(S("L"), focus.smart_right, { description = "Smart focus/workspace navigation right (no wrap)" })
