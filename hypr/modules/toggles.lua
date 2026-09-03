-- toggles.lua — bar / gaps / dim / border / zoom / game_mode / cycle_layout
local helpers = require("modules.helpers")
local Noctalia = helpers.Noctalia

local M = {}

local DEFAULT_BORDER_SIZE = helpers.DEFAULT_BORDER_SIZE

-- Bar auto-hide toggle (persisted to cache)
local function get_bar_cache_path()
    local xdg = os.getenv("XDG_CACHE_HOME")
    if xdg and xdg ~= "" then return xdg .. "/noctalia/bar-autohide" end
    return (os.getenv("HOME") or "") .. "/.cache/noctalia/bar-autohide"
end

function M.toggle_bar()
    local path = get_bar_cache_path()
    local dir = path:match("(.+)/[^/]+$")
    if dir then os.execute("mkdir -p '" .. dir .. "'") end
    local cur = "0"
    local f = io.open(path, "r")
    if f then
        local c = f:read("*l"); f:close()
        if c then c = c:gsub("%s+", ""); if c == "0" or c == "1" then cur = c end end
    end
    local nxt, cmd = cur == "1" and "0" or "1", cur == "1" and "off" or "on"
    local wf = io.open(path, "w"); if wf then wf:write(nxt .. "\n"); wf:close() end
    hl.dispatch(Noctalia("bar-auto-hide-set " .. cmd))
    hl.dispatch(Noctalia("bar-reserve-toggle"))
    hl.dispatch(Noctalia("dock-toggle"))
    hl.dispatch(Noctalia(cmd == "on" and "bar-layer-set overlay" or "bar-layer-set top"))
end

function M.toggle_gaps()
    local gaps = hl.get_config("general.gaps_in")
    local zero = gaps.top == 5
    hl.config({ general = { gaps_in = zero and 0 or 5, gaps_out = zero and 0 or 5 } })
end

function M.toggle_dim()
    if hl.get_config("decoration.dim_inactive") == false then
        hl.config({ general = { border_size = 0 }, decoration = { dim_inactive = true } })
    else
        hl.config({ general = { border_size = DEFAULT_BORDER_SIZE }, decoration = { dim_inactive = false } })
    end
end

function M.toggle_border()
    local bs = hl.get_config("general.border_size")
    hl.config({ general = { border_size = bs == 0 and DEFAULT_BORDER_SIZE or 0 } })
end

-- Zoom
M.MAX_ZOOM, M.MIN_ZOOM, M.ZOOM_TOGGLE_FACTOR = 3, 1, 1.5

function M.zoom(offset)
    local cur = hl.get_config("cursor.zoom_factor")
    cur = offset ~= nil and cur + offset or cur ~= M.MIN_ZOOM and M.MIN_ZOOM or M.ZOOM_TOGGLE_FACTOR
    hl.config({ cursor = { zoom_factor = math.max(M.MIN_ZOOM, math.min(M.MAX_ZOOM, cur)) } })
end

function M.zoom_in() M.zoom(0.5) end
function M.zoom_out() M.zoom(-0.5) end

-- Game / focus mode toggle
function M.toggle_game_mode()
    if hl.get_config("decoration.shadow.enabled") == false then
        hl.exec_cmd("hyprctl reload")
        hl.exec_cmd(helpers.NOCTALIA_IPC .. [[notification-show '{
            "app_name":"👀 Noctalia",
            "summary":"FOCUS MODE DISABLED",
            "body":"Desktop effects restored",
            "urgency":"normal",
            "timeout_ms":1000,
            "icon":"monitor"
        }']])
        return
    end
    hl.config({
        general = { gaps_in = 0, gaps_out = 0 },
        decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0, dim_inactive = false },
    })
    hl.window_rule({ name = "magnetic-open", match = { class = ".*" }, tag = "-shader_open:/home/fitrah/.config/hypr/shaders/magnetic-open.glsl" })
    hl.window_rule({ name = "magnetic-close", match = { class = ".*" }, tag = "-shader_close:/home/fitrah/.config/hypr/shaders/magnetic-close.glsl" })
    hl.window_rule({ name = "floating-smoke", match = { float = true }, tag = "-shader_floating:/home/fitrah/.config/hypr/shaders/floating-smoke.glsl" })
    hl.exec_cmd(helpers.NOCTALIA_IPC .. [[notification-show '{
        "app_name":"👀 Noctalia",
        "summary":"FOCUS MODE ENABLED",
        "body":"Focus profile activated\n• Blur OFF\n• Borders OFF",
        "urgency":"critical",
        "timeout_ms":2000,
        "icon":"gamepad-2"
    }']])
end

function M.cycle_layout()
    local layouts = { "scrolling", "master", "monocle" }
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not workspace then return end
    local next_layout = "dwindle"
    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            next_layout = layouts[(i % #layouts) + 1]; break
        end
    end
    local target = workspace.special and tostring(workspace.name) or tostring(workspace.id)
    hl.workspace_rule({ workspace = target, layout = next_layout })
    hl.notification.create({ text = "Layout: " .. next_layout, timeout = 1500, icon = "info" })
end

return M
