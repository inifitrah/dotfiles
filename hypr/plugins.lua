hl.config({
    plugin = {
        scrolloverview = {
                   gesture_distance = 300, -- how far is the "max" for the gesture
                   scale = 0.5, -- preferred overview scale
                   workspace_gap = 100,
                   layout = "vertical", -- vertical or horizontal
                   wallpaper = 2, -- 0: global only, 1: per-workspace only, 2: both
                   blur = false, -- blur only the main overview wallpaper

                   shadow = {
                       enabled = true,
                       range = 50,
                       render_power = 3,
                       color = 0xee1a1a1a,
                   },
               },
        hyprbars = {
                  bar_height                 = 32,
                  bar_part_of_window         = true,
                  bar_buttons_alignment      = "left",
                  bar_button_padding         = 10,
                  bar_blur                   = false,
                  bar_padding                = 12	,
                  bar_text_font              = "",
                  bar_text_size			   = 14,
                  bar_precedence_over_border = true,
                  bar_color                  = "rgba(00000000)",
                  col                        = {
                      text = "rgb(ffffff)",
                  },
                  icon_on_hover              = true,
                  inactive_button_color      = "rgb(c2c2c2)",
                  on_double_click            = "hyprctl dispatch 'hl.dsp.window.fullscreen_state({internal = 1, client = 0})'"
              },
    }
})
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
