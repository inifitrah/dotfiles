local M = {}

local function find_window(opts)
    for _, win in ipairs(hl.get_windows()) do
        if (opts.title and win.title == opts.title)
            or (opts.class and (win.class == opts.class or win.initialClass == opts.class)) then
            return win
        end
    end

    return nil
end

function M.toggle_specific_app(dsp, match)
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    local app_win = find_window(match)
    local special_ws = "special:hidden"

       if not app_win then
           hl.dispatch(dsp)
           return
       end

       local app_ws_name = app_win.workspace.name

       if app_ws_name ~= current_ws.name and current_ws.name ~= special_ws then
           hl.dispatch(hl.dsp.window.move({
               workspace = current_ws.name,
               window = app_win,
           }))
           hl.dispatch(hl.dsp.window.center({
               window = app_win,
           }))

       elseif current_ws.name ~= special_ws then
           hl.dispatch(hl.dsp.window.move({
               workspace = special_ws,
               window = app_win,
               follow = false,
           }))

       else
           local base_ws = hl.get_active_workspace()

           hl.dispatch(hl.dsp.window.move({
               workspace = base_ws.name,
               window = app_win,
           }))
           hl.dispatch(hl.dsp.window.center({
               window = app_win,
           }))
       end
end
    function M.minimize_app()
        local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
        if hl.get_workspace("special:minimized") then
               hl.dispatch(hl.dsp.window.move({ workspace = current_ws.name, window = "tag:minimized" }))
               hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
           else
               hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
               hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
           end
       end

return M
