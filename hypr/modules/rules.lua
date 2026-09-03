--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Workspace
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true })

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

-- hl.window_rule({
--     name = "shadow_only_when_float",
--     match = {
--         float = false
--     },
--     size = {900, 800},
--     no_shadow= true
-- })
hl.window_rule({ name = "kitty_starting_width", match = { class = "kitty" }, scrolling_width = 0.5})
hl.window_rule({ name = "zen_starting_width", match = { class = "zen" }, scrolling_width = 1})

-- OPEN/CLOSE: aktif glitch, alternatif hapus -- buat coba satu-satu (komen glitch dulu kalau mau ganti)
-- hl.window_rule({ name = "glitch-open-global", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/glitch-open.glsl@0.5" })
-- hl.window_rule({ name = "glitch-close-global", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/glitch-close.glsl@0.5" })
-- 1. Glass Bloom
-- hl.window_rule({ name = "glass-bloom-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/glass-bloom-open.glsl" })
-- hl.window_rule({ name = "glass-bloom-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/glass-bloom-close.glsl" })
-- 2. Liquid Blob
-- hl.window_rule({ name = "liquid-blob-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/liquid-blob-open.glsl" })
-- hl.window_rule({ name = "liquid-blob-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/liquid-blob-close.glsl" })
-- 3. Aurora Materialize
-- hl.window_rule({ name = "aurora-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/aurora-materialize-open.glsl" })
-- hl.window_rule({ name = "aurora-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/aurora-materialize-close.glsl" })
-- 4. Scale + Blur (paling ringan)
-- hl.window_rule({ name = "scale-blur-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/scale-blur-open.glsl" })
-- hl.window_rule({ name = "scale-blur-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/scale-blur-close.glsl" })
-- 5. Magnetic Open
hl.window_rule({ name = "magnetic-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/magnetic-open.glsl" })
hl.window_rule({ name = "magnetic-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/magnetic-close.glsl" })
-- 6. Water Drop
-- hl.window_rule({ name = "water-drop-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/water-drop-open.glsl" })
-- hl.window_rule({ name = "water-drop-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/water-drop-close.glsl" })
-- 7. Portal
-- hl.window_rule({ name = "portal-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/portal-open.glsl" })
-- hl.window_rule({ name = "portal-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/portal-close.glsl" })
-- 8. Crystal / Refraction
-- hl.window_rule({ name = "crystal-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/crystal-open.glsl" })
-- hl.window_rule({ name = "crystal-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/crystal-close.glsl" })
-- 9. Electric Edge
-- hl.window_rule({ name = "electric-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/electric-edge-open.glsl" })
-- hl.window_rule({ name = "electric-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/electric-edge-close.glsl" })
-- 10. Smoke Dissolve
-- hl.window_rule({ name = "smoke-dissolve-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/smoke-dissolve-open.glsl" })
-- hl.window_rule({ name = "smoke-dissolve-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/smoke-dissolve-close.glsl" })
-- 11. Focus Lens
-- hl.window_rule({ name = "focus-lens-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/focus-lens-open.glsl" })
-- hl.window_rule({ name = "focus-lens-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/focus-lens-close.glsl" })
-- 12. Organic Stretch
-- hl.window_rule({ name = "organic-stretch-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/organic-stretch-open.glsl" })
-- hl.window_rule({ name = "organic-stretch-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/organic-stretch-close.glsl" })
-- 13. Black Hole Collapse
-- hl.window_rule({ name = "black-hole-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/black-hole-open.glsl" })
-- hl.window_rule({ name = "black-hole-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/black-hole-close.glsl" })
-- 14. Pixel Dissolve
-- hl.window_rule({ name = "pixel-dissolve-open", match = { class = ".*" }, tag = "+shader_open:/home/fitrah/.config/hypr/shaders/pixel-dissolve-open.glsl" })
-- hl.window_rule({ name = "pixel-dissolve-close", match = { class = ".*" }, tag = "+shader_close:/home/fitrah/.config/hypr/shaders/pixel-dissolve-close.glsl" })

-- FLOATING SHADERS: coba satu-satu, hapus -- buat aktif (cuma 1 yang aktif biar gak stack)
-- hl.window_rule({ name = "floating-liquid", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-liquid.glsl" })
-- hl.window_rule({ name = "floating-aurora", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-aurora.glsl" })
-- hl.window_rule({ name = "floating-plasma", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-plasma.glsl" })
-- hl.window_rule({ name = "floating-fireflies", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-fireflies.glsl" })
-- hl.window_rule({ name = "floating-glass", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-glass.glsl" })
hl.window_rule({ name = "floating-smoke", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-smoke.glsl" })
-- hl.window_rule({ name = "floating-net", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-net.glsl" })
-- hl.window_rule({ name = "floating-dim", match = { float = true }, tag = "+shader_floating:/home/fitrah/.config/hypr/shaders/floating-dim.glsl" })
