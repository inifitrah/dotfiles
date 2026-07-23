local M = {}

function M.setup()
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

        -- window rule
        hl.window_rule({
            name = "hyprland-dialog",
            match = {
                initial_class = "hyprland-dialog"
            },
            ["hyprbars:no_bar"] = true
        })
        hl.window_rule({
            name                   = "zed",
            match                  = {
                class = "dev.zed.Zed",
            },
            ["hyprbars:bar_color"] = "rgb(202324)",
        })
        hl.window_rule({
            name                   = "kitty",
            match                  = { class = "kitty" },
            ["hyprbars:bar_color"] = "rgba(000000D4)",
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
        hl.window_rule({
            name = "hide-hyprbars",
            match = {
                float = true
            },
            rounding = 17,
            border_size = 1,
            border_color = "rgb(606570)",
            -- no_shadow = true,
            ["hyprbars:no_bar"] = true
        })
    end
end

function M.disable()
    if hl.plugin.hyprbars ~= nil then
        hl.config({
            plugin = {
                hyprbars = {
                    enabled = false
                }
            }
        })
    end
end

return M
