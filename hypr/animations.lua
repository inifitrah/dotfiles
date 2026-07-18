------------------
---- ANIMATIONS ----
------------------

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("overshot",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05}  } })
hl.curve("smoothOut",      { type = "bezier", points = { {0.5, 0},     {0.99, 0.99} } })
hl.curve("smoothIn",       { type = "bezier", points = { {0.5, -0.5},  {0.68, 1.5}  } })

hl.curve("wind",          { type = "bezier", points = { {0.05, 0.85}, {0.03, 0.97} } })
hl.curve("winIn",         { type = "bezier", points = { {0.07, 0.88}, {0.04, 0.99} } })
hl.curve("easeOutCirc",   { type = "bezier", points = { {0, 0.48},    {0.38, 1}    } })

hl.curve("md3_decel",      { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5,    bezier = "default" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 3,    bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 3.2,  bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2.8,  bezier = "easeOutCirc" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 3.0,  bezier = "wind", style = "slide" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "smoothIn", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
