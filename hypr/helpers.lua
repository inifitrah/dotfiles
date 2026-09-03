-- helpers.lua — shared bind helpers (MOD, S, Noctalia, layout_bind)
local M = {}

M.MOD = "SUPER" -- main modifier (Windows key)
M.NOCTALIA_IPC = "noctalia msg "
M.DEFAULT_BORDER_SIZE = hl.get_config("general.border_size")

function M.Noctalia(cmd) return hl.dsp.exec_cmd(M.NOCTALIA_IPC .. cmd) end
function M.S(key) return M.MOD .. " + " .. key end

-- Per-layout binds: same key, different action depending on active layout
function M.layout_bind(bind_table)
    return function()
        local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
        if not workspace then return end
        local layout = workspace.tiled_layout
        if bind_table[layout] then
            hl.dispatch(bind_table[layout])
        elseif bind_table.default then
            hl.dispatch(bind_table.default)
        end
    end
end

return M
