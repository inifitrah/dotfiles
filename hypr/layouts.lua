----------------
---- LAYOUTS ----
----------------
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true })

-- See https://wiki.hypr.land/Configuring/Layouts/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
    master = {
        new_status = "master",
        mfact = 0.70,
        orientation = "center",
        -- always_keep_position = true
        focus_master_on_close = false,
    },
    scrolling = {
        fullscreen_on_one_column = false,
        column_width = 0.8,
        focus_fit_method = 1,
        follow_focus = true,
        follow_min_visible = 0.5,
        wrap_focus = false,
        wrap_swapcol = false,
        explicit_column_widths  = "0.5, 0.8, 1.0",
        direction = "right",
    },
})
