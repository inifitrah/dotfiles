-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

hl.config({
  ecosystem = {
    enforce_permissions = true,
  },
    general = {
      gaps_in = 5,
      gaps_out = 10,
    },

    decoration = {
      rounding = 20,
      rounding_power = 2,

      shadow = {
        enabled = true,
        range = 4,
        render_power = 3,
        color = 0xee1a1a1a,
      },

      blur = {
        enabled = true,
        size = 3,
        passes = 2,
        vibrancy = 0.1696,
      },
    },
})

hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
