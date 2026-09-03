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
})

-- screencopy: allow trusted screen capture tools without prompt
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/noctalia", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/lib/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wf-recorder", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wl-screenrec", type = "screencopy", mode = "allow" })

-- plugin: allow hyprpm and shader plugins to load
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
hl.permission({ binary = "/home/fitrah/.local/share/hyprland/plugins/HyprWindowShade.so", type = "plugin", mode = "allow" })
hl.permission({ binary = "/home/fitrah/.local/share/hyprland/plugins/.*\\.so", type = "plugin", mode = "allow" })
