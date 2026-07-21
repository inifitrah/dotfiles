local M = {}

local SPECIAL_WORKSPACE = {
    hidden = "special:hidden",
    minimized = "special:minimized"
}
local function find_maching_window(opts)
    for _, win in ipairs(hl.get_windows()) do
        if (opts.title and win.title == opts.title)
            or (opts.class and (win.class == opts.class or win.initialClass == opts.class)) then
            return win
        end
    end

    return nil
end

local function show_app(app_win, current_ws)
    hl.dispatch(hl.dsp.window.move({
        workspace = current_ws.name,
        window = app_win,
    }))
    hl.dispatch(hl.dsp.window.center({
        window = app_win,
    }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top", window = app_win }))
end

function M.show_or_hide_app(dsp, match)
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    local app_win = find_maching_window(match)

    if not app_win then
        hl.dispatch(dsp)
        return
    end

    local app_ws_name = app_win.workspace.name
    local app_is_in_current_workspace = app_ws_name == current_ws.name
    local app_is_in_hidden_workspace = current_ws.name == SPECIAL_WORKSPACE.hidden

    if not app_is_in_current_workspace and not app_is_in_hidden_workspace then
        show_app(app_win, current_ws)
    elseif not app_is_in_hidden_workspace then
        -- Hide applications by moving them into a dedicated special workspace
        hl.dispatch(hl.dsp.window.move({
            workspace = SPECIAL_WORKSPACE.hidden,
            window = app_win,
            follow = false,
        }))
    elseif app_is_in_hidden_workspace then
        show_app(app_win, current_ws)
    end
end

function M.minimize_app()
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    if hl.get_workspace(SPECIAL_WORKSPACE.minimized) then
        hl.dispatch(hl.dsp.window.move({ workspace = current_ws.name, window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = SPECIAL_WORKSPACE.minimized, follow = false }))
    end
end

return M
