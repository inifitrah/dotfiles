local ipc = "noctalia msg "

local M = {}

function M.toggle_game_mode()
    local game_mode = (hl.get_config("decoration.shadow.enabled") == false)

    if game_mode then
        hl.exec_cmd("hyprctl reload")
        hl.exec_cmd(ipc .. [[notification-show '{
            "app_name":"👀 Noctalia",
            "summary":"FOCUS MODE DISABLED",
            "body":"Desktop effects restored",
            "urgency":"normal",
            "timeout_ms":1000,
            "icon":"monitor"
        }']])
        return
    end

    -- auto hide bar ( Noctalia )
    require("modules.hyprbars").disable()
    hl.config({
        general = {
            gaps_in = 3, gaps_out = 0, -- Disable gaps
        },

        -- animations = {
        --     enabled = false, -- Disable animations
        -- },

        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
            dim_inactive = false
        }
    })
    hl.exec_cmd(ipc .. [[notification-show '{
        "app_name":"👀 Noctalia",
        "summary":"FOCUS MODE ENABLED",
        "body":"Focus profile activated\n• Animations OFF\n• Blur OFF\n• Borders OFF",
        "urgency":"critical",
        "timeout_ms":2000,
        "icon":"gamepad-2"
    }']])
end

return M
