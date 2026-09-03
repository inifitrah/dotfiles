-- focus_window_or_workspace.lua — smart H/L: focus left/right within workspace, or jump to next occupied workspace
local M = {}

local LAYOUT_FOCUS_MESSAGE = { scrolling = { l = "focus left", r = "focus right" } }

local function get_occupied_workspaces()
    local occ = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        if ws.id > 0 and ws.windows and ws.windows > 0 then table.insert(occ, ws) end
    end
    table.sort(occ, function(a, b) return a.id < b.id end)
    return occ
end

local function find_next_occupied(occupied, current_id, direction)
    if direction == "r" then
        for _, ws in ipairs(occupied) do if ws.id > current_id then return ws end end
    else
        for i = #occupied, 1, -1 do if occupied[i].id < current_id then return occupied[i] end end
    end
end

local function workspace_selector(ws) return ws.id and ws.id > 0 and ws.id or ws.name end
local function center_x(w) return (w.at and w.at.x or 0) + (w.size and w.size.x or 0) / 2 end

local function at_workspace_edge(active_win, wins, direction)
    local acx = center_x(active_win)
    for _, w in ipairs(wins) do
        if w.address ~= active_win.address and ((direction == "r" and center_x(w) > acx) or (direction == "l" and center_x(w) < acx)) then
            return false
        end
    end
    return true
end

local function get_tiled_layout(ws) return ws.tiled_layout or ws.tiledLayout end

local function focus_within_workspace(layout, direction)
    local msg = (LAYOUT_FOCUS_MESSAGE[layout] or {})[direction]
    if msg then hl.dispatch(hl.dsp.layout(msg)) else hl.dispatch(hl.dsp.focus({ direction = direction })) end
end

local function jump_to_workspace(current_id, direction)
    local target = find_next_occupied(get_occupied_workspaces(), current_id, direction)
    if target then hl.dispatch(hl.dsp.focus({ workspace = target.id })); return end
    hl.dispatch(hl.dsp.focus({ workspace = direction == "r" and "+1" or "-1" }))
end

function M.focus_window_or_workspace(direction)
    local active_win = hl.get_active_window()
    local current_ws = (active_win and active_win.workspace) or hl.get_active_workspace()
    if not current_ws then return end
    local wins = hl.get_workspace_windows(workspace_selector(current_ws)) or {}
    local edge = (not active_win) or at_workspace_edge(active_win, wins, direction)
    if not edge then focus_within_workspace(get_tiled_layout(current_ws), direction); return end
    if (current_ws.id or 0) < 0 then return end
    jump_to_workspace(current_ws.id, direction)
end

function M.left() M.focus_window_or_workspace("l") end
function M.right() M.focus_window_or_workspace("r") end

return M
