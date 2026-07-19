--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

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
    ["hyprbars:no_bar"] = true}
)
hl.window_rule({
    name              = "zed",
    match             = { class = "dev.zed.Zed" },
    ["hyprbars:bar_color"] = "rgba(000000A6)",
})
hl.window_rule({
    name              = "sober",
    match             = { class = "sober_services" },
    ["hyprbars:no_bar"] = true,
})
hl.window_rule({
    name              = "kitty",
    match             = { class = "kitty" },
    ["hyprbars:bar_color"] = "rgba(000000D4)",
})

hl.window_rule({
    name              = "zen",
    match             = { class = "zen" },
    ["hyprbars:bar_color"] = "rgb(131313)"}
)
-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
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
