--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- work
hl.workspace_rule({ workspace = "special:work", no_rounding = true, decorate =false , gaps_in = 3, gaps_out = 3, no_border = true, monitor = "eDP-1", persistent = true, no_shadow=true, animation="slidevert" })

-- Noctalia Settings
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})


hl.window_rule({
    name              = "scrcpy",
    match             = { class = "scrcpy" },
    keep_aspect_ratio = true,
    float             = true,
})
-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- XWayland
hl.window_rule({
    name = "xwayland-video-bridge-fixes",
    match = {
        class = "xwaylandvideobridge"
    },
    no_initial_focus = true,
    no_focus = true,
    no_anim = true,
    no_blur = true,
    max_size = { 1, 1 },
    opacity = 0.0,
})
hl.window_rule({
    name = "vinegar-roblox-studio",
    match = {
        xwayland = 1
    },
    no_initial_focus = true,
})

hl.window_rule({
    name = "shadow_only_when_float",
    match = {
        float = false
    },
    size = {900, 800},
    no_shadow= true
})
hl.window_rule({ name = "kitty_starting_width", match = { class = "kitty" }, scrolling_width = 0.5})
