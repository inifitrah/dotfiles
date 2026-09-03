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
        allow_tearing = false,
        layout = "scrolling",
        no_focus_fallback = true
    },
    decoration = {
        rounding       = 20,
        rounding_power = 2,
        dim_special = 0.6,
        dim_strength = 0.5,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 30,
            render_power = 30,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled   = false,
            size      = 4,
            passes    = 4,
            vibrancy  = 0.1700,
            brightness = 0.4
        },
    },
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
        mouse_refocus = false
    },
    misc = {
        force_default_wallpaper = 0,   -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        focus_on_activate       = true,
        font_family             = "NotoSans Nerd Font",
        disable_autoreload      = false
    },
    binds = {
        hide_special_on_workspace_change = true
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
