local scratchpads = require("utils.scratchpads")
------------------
-- MY PROGRAMS  --
------------------
local terminal    = "kitty"
local fileManager = "kitty -T yazi -e yazi"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local ipc = "noctalia msg "

-- Per-layout binds: same key, different action depending on the active layout
local function layout_bind(bind_table)
    return function ()
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

-- Noctalia
-- Core binds
hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+ SHIFT + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. "+ SHIFT + Escape", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
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
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Toggle applications like MangoWM named scratchpads.
hl.bind(mainMod .. " + E", function ()
    scratchpads.show_or_hide_app(hl.dsp.exec_cmd(fileManager, {
        float = true,
        size = {1200, 700}
    }), {
      title = "yazi"
    })
end)
hl.bind(mainMod .. " + return", function ()
    scratchpads.show_or_hide_app(hl.dsp.exec_cmd("kitty -T term sh -c 'fastfetch --logo-type kitty; exec $SHELL'", {
        float = true,
        size = { 1200, 900 },
        -- ["hyprbars:no_bar"] = true
    }), {
      title = "term"
    })
end)
hl.bind("SUPER + X", function ()
    scratchpads.minimize_app()
end)

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), {long_press = true})
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind("ALT + A", hl.dsp.window.fullscreen({ mode= "maximized", action="toggle", layout_aware=true  }) )
hl.bind("ALT + F", hl.dsp.window.fullscreen({ mode= "fullscreen", action="toggle", layout_aware=true  }) )

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. "+ ALT + L", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. "+ ALT + H",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

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
-- Direction toggle per-workspace (right ↔ down)
local scroll_directions = {}

-- hl.bind(mainMod .. "+ R", function()
--     local workspace = hl.get_active_workspace()
--     if hl.get_active_special_workspace() then
--         workspace = hl.get_active_special_workspace()
--     end
--     if not workspace then return end

--     local id = tostring(workspace.id)
--     local current = scroll_directions[id] or "right"
--     local new_dir = current == "right" and "down" or "right"
--     scroll_directions[id] = new_dir

--     hl.workspace_rule({ workspace = id, layout_opts = { direction = "right" } })
--     hl.notification.create({ text = "Scrolling: " .. new_dir, timeout = 1500, icon = "info" })
-- end)

-- hl.bind(mainMod .. "+ F", layout_bind({
--     scrolling = hl.dsp.layout("fit expand"),
-- }))

hl.bind(mainMod .. "+ bracketright", layout_bind({
    scrolling = hl.dsp.layout("consume_or_expel next"),
}))

hl.bind(mainMod .. "+ bracketleft", layout_bind({
    scrolling = hl.dsp.layout("consume_or_expel prev"),
}))

-- hl.bind(mainMod .. "+ slash", layout_bind({
--     scrolling = hl.dsp.layout("inhibit_scroll"),
-- }))

-- hl.bind(mainMod .. "+ C", layout_bind({
--     scrolling = hl.dsp.layout("fit_into_view"),
-- }))

hl.bind(mainMod .. "+ H", layout_bind({
    scrolling = hl.dsp.layout("focus left"),
    default = hl.dsp.focus({direction = "left"})
}))
hl.bind(mainMod .. "+ J", layout_bind({
    scrolling = hl.dsp.layout("focus down"),
    default = hl.dsp.focus({direction = "down"})
}))
hl.bind(mainMod .. "+ K", layout_bind({
    scrolling = hl.dsp.layout("focus top"),
    default = hl.dsp.focus({direction = "up"})
}))
hl.bind(mainMod .. "+ L", layout_bind({
    scrolling = hl.dsp.layout("focus right"),
    default = hl.dsp.focus({direction = "right"})
}))

hl.bind(mainMod .. "+ o", function ()
    hl.plugin.scrolloverview.overview("toggle")
end)

-- hl.bind(mainMod .. "+ Tab", function ()
--     hl.plugin.scrolloverview.overview("toggle")
-- end)

-- Snappy Switcher
hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next --mod alt"))
hl.bind(mainMod .. "+ Tab", hl.dsp.exec_cmd("snappy-switcher next --workspace --mod super"))

hl.bind(mainMod .. " + SHIFT + H", layout_bind({
    scrolling = hl.dsp.layout("swapcol l"),  -- Scrolling: swap column with left one
    dwindle   = hl.dsp.layout("swapsplit"),  -- Dwindle: swap window split
}))

hl.bind(mainMod .. " + SHIFT + L", layout_bind({
    scrolling = hl.dsp.layout("swapcol r"),  -- Scrolling: swap column with right one
    dwindle   = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
}))

hl.bind(mainMod .. " + L", layout_bind({
    monocle = hl.dsp.layout("cyclenext"),            -- Monocle: cycle next window
}))
hl.bind(mainMod .. " + H", layout_bind({
    monocle = hl.dsp.layout("cycleprev"),           -- Monocle: cycle prev window
}))


-- game mode
hl.bind("F1", function ()
    local game_mode = (hl.get_config("animations.enabled") == false)

    if game_mode then
        hl.exec_cmd(ipc .. "bar-auto-hide-set off bar-blur")
        hl.exec_cmd(ipc .. "bar-reserve-toggle bar-blur")
        hl.exec_cmd("hyprctl reload")
        hl.exec_cmd(ipc .. [[notification-show '{
            "app_name":"🎮 Noctalia",
            "summary":"GAME MODE DISABLED",
            "body":"Desktop effects restored",
            "urgency":"normal",
            "timeout_ms":3000,
            "icon":"monitor"
        }']])
        return
    end

    -- auto hide bar ( Noctalia )
    hl.exec_cmd(ipc .. "bar-auto-hide-set on bar-blur")
    hl.exec_cmd(ipc .. "bar-reserve-toggle bar-blur")

    -- disable plugin
    hl.config({
        plugin = {
            hyprbars = {
                enabled = false
            }
        },
        general = {
            gaps_in = 0, gaps_out = 0, -- Disable gaps
            border_size = 0,
        },

        animations = {
            enabled = false, -- Disable animations
        },

        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
        }
    })
    hl.exec_cmd(ipc .. [[notification-show '{
        "app_name":"🎮 Noctalia",
        "summary":"GAME MODE ENABLED",
        "body":"Performance profile activated\n• Animations OFF\n• Blur OFF\n• Borders OFF",
        "urgency":"critical",
        "timeout_ms":3500,
        "icon":"gamepad-2"
    }']])
end)

-- switch layout
hl.bind("SUPER + N", function ()
    local layouts     = { "scrolling", "dwindle", "monocle" }
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
end)

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

hl.bind("SUPER + SHIFT + Z", zoom)
hl.bind("SUPER + SHIFT + Up", function()
    zoom(0.5)
end)
hl.bind("SUPER + SHIFT + Down", function()
    zoom(-0.5)
end)

hl.bind(mainMod .. "+ SHIFT + P", function ()
    hl.dispatch(hl.dsp.window.tag({ tag = "sensitive", window = hl.get_active_window() }))
end )
