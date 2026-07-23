local ipc = "noctalia msg "

local M = {}

function M.toggle_game_mode()
    local game_mode = (hl.get_config("animations.enabled") == false)

    if game_mode then
        hl.exec_cmd(ipc .. "bar-auto-hide-set off bar-blur")
        hl.exec_cmd(ipc .. "bar-reserve-toggle bar-blur")
        hl.exec_cmd("hyprctl reload")
        hl.exec_cmd(ipc .. [[notification-show '{
            "app_name":"🎮 Noctalia",
            "summary":"GAME MODE DISABLED",
            "body":"Desktop effects restored",
            "urgency":"normal",
            "timeout_ms":3000,
            "icon":"monitor"
        }']])
        return
    end

    -- auto hide bar ( Noctalia )
    hl.exec_cmd(ipc .. "bar-auto-hide-set on bar-blur")
    hl.exec_cmd(ipc .. "bar-reserve-toggle bar-blur")

    require("modules.hyprbars").disable()
    hl.config({
        general = {
            gaps_in = 0, gaps_out = 0, -- Disable gaps
            border_size = 0,
        },

        animations = {
            enabled = false, -- Disable animations
        },

        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
        }
    })
    hl.exec_cmd(ipc .. [[notification-show '{
        "app_name":"🎮 Noctalia",
        "summary":"GAME MODE ENABLED",
        "body":"Performance profile activated\n• Animations OFF\n• Blur OFF\n• Borders OFF",
        "urgency":"critical",
        "timeout_ms":3500,
        "icon":"gamepad-2"
    }']])
end

function M.cycle_layout()
    local layouts     = { "scrolling", "dwindle", "monocle" }
    local workspace   = hl.get_active_workspace()
    if hl.get_active_special_workspace() then
        workspace = hl.get_active_special_workspace()
    end

    local next_layout = "dwindle"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

    if workspace.special then
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
    else
        hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
    end

    hl.notification.create({ text = "Layout: " .. next_layout, timeout = 1500, icon = "info" })
end

return M
