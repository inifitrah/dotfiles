------------------
-- MY PROGRAMS  --
------------------

local terminal    = "kitty"
local fileManager = "kitty -T yazi -e yazi"
local menu        = "hyprlauncher"


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local ipc = "noctalia msg "
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
local closeWindowBind = hl.bind("ALT" .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))

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

-- Scrolling
hl.bind(mainMod .. "+ comma", hl.dsp.layout("move +100"))
hl.bind(mainMod .. "+ period", hl.dsp.layout("move -100"))
hl.bind(mainMod .. "+ SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. "+ SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. "+ equal", hl.dsp.layout("colresize +0.5"))
hl.bind(mainMod .. "+ minus", hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. "+ R", hl.dsp.layout("fit all"))
hl.bind(mainMod .. "+ F", hl.dsp.layout("fit active"))

hl.bind(mainMod .. "+ o", function ()
    hl.plugin.scrolloverview.overview("toggle")
end)

hl.bind(" ALT + H", hl.dsp.layout("cycleprev"))
hl.bind(" ALT + L", hl.dsp.layout("cyclenext"))

hl.bind("SUPER + X", function ()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)

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
end)
