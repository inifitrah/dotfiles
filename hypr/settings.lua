-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 3,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "scrolling",

        no_focus_fallback = true
    },

    decoration = {
        rounding       = 20,
        rounding_power = 2,
        dim_special = 0.1,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 30,
            render_power = 30,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = false,
            size      = 4,
            passes    = 4,
            vibrancy  = 0.1700,
            brightness = 0.4
        },
    },

    animations = {
        enabled = true,
    },

    cursor = {
        no_warps = false
    },
    debug = {
       -- enable_stdout_logs = true,
       disable_logs = false,       -- opsional, kalau mau logging ke file juga tetap nyala
       -- colored_stdout_logs = true, -- opsional, biar ada warna
     }

})
