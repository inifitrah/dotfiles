-----------------
---- PLUGINS  ---
-----------------
if hl.plugin.scrolloverview ~= nil then
hl.config({
    plugin = {
        scrolloverview = {
                   gesture_distance = 300, -- how far is the "max" for the gesture
                   scale = 0.5, -- preferred overview scale
                   workspace_gap = 100,
                   layout = "vertical", -- vertical or horizontal
                   wallpaper = 1, -- 0: global only, 1: per-workspace only, 2: both
                   blur = false, -- blur only the main overview wallpaper
            input = {
                   },
                   shadow = {
                       enabled = false,
                       range = 50,
                       render_power = 3,
                       color = 0xee1a1a1a,
            },
        },
    }
})
end

if hl.plugin.hyprbars ~= nil then
        hl.plugin.hyprbars.add_button({
            bg_color = "rgb(fe5154)",
            fg_color = "rgb(000000)",
            size = 16,
            icon = "󰖭",
            action = "hyprctl dispatch 'hl.dsp.window.close()'",
        })
        hl.plugin.hyprbars.add_button({
            bg_color = "rgb(f7c000)",
            fg_color = "rgb(000000)",
            size = 16,
            icon = "",
            action = "hyprctl dispatch 'hl.dsp.window.float()'",
        })
        hl.plugin.hyprbars.add_button({
            bg_color = "rgb(2dbf4d)",
            fg_color = "rgb(000000)",
            size = 16,
            icon = "󰘖",
            action = "hyprctl dispatch 'hl.dsp.window.fullscreen_state({internal = 1, client = 0})'"
        })
        hl.config({

            plugin = {
                hyprbars = {
                    enabled                    = true,
                    bar_height                 = 32,
                    bar_part_of_window         = true,
                    bar_buttons_alignment      = "left",
                    bar_button_padding         = 10,
                    bar_blur                   = false,
                    bar_padding                = 12,
                    bar_text_font              = "",
                    bar_text_size              = 14,
                    bar_precedence_over_border = true,
                    bar_color                  = "rgb(131313)",
                    col                        = {
                        text = "rgb(ffffff)",
                    },
                    icon_on_hover              = true,
                    inactive_button_color      = "rgb(c2c2c2)",
                    on_double_click            = "hyprctl dispatch 'hl.dsp.window.fullscreen_state({internal = 1, client = 0})'"
                },
            }
        })
        hl.window_rule({
            name = "hyprland-dialog",
            match = {
                initial_class = "hyprland-dialog"
            },
            ["hyprbars:no_bar"] = true,
        })
        hl.window_rule({
            name = "spotify",
            match = {
                initial_class = "Spotify"
            },
            ["hyprbars:bar_color"] = "rgb(000000)",
        })
        hl.window_rule({
            name                   = "zed",
            match                  = {
                class = "dev.zed.Zed",
            },
            ["hyprbars:bar_color"] = "rgb(1e1d1b)",
        })
        hl.window_rule({
            name                   = "kitty",
            match                  = { class = "kitty" },
            ["hyprbars:bar_color"] = "rgb(1e1d1b)",
        })
        hl.window_rule({
            name                   = "zen",
            match                  = { class = "zen" },
            ["hyprbars:bar_color"] = "rgb(131313)"
        })
        hl.window_rule({
            name = "sensitive-app",
            match = {
                tag = "sensitive"
            },
            no_screen_share = true,
            ["hyprbars:no_bar"] = true
        })
    end

local ok, err = pcall(hl.plugin.load,
    "/home/fitrah/.local/share/hyprland/plugins/HyprWindowShade.so")
if not ok then
    hl.on("hyprland.start", function()
        hl.notification.create({
            text    = "[HyprWindowShade] failed to load: " .. tostring(err),
            timeout = 8000,
            color   = "rgb(ff5555)",
        })
    end)
end
