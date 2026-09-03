local M = {}

local SPECIAL_WORKSPACE = {
    hidden = "special:hidden",
    minimized = "special:minimized"
}
local currently_shown_address = nil
local pending_spawn = nil -- { match = {title?, class?}, ws_name = "..." }

local function matches(win, opts)
    if not win or not opts then return false end
    return (opts.title and win.title == opts.title)
        or (opts.class and (win.class == opts.class or win.initialClass == opts.class))
end

local function find_matching_window(opts)
    if not opts then return nil end
    for _, win in ipairs(hl.get_windows()) do
        if matches(win, opts) then
            return win
        end
    end
    return nil
end

local function find_window_by_address(address)
    if not address then
        return nil
    end
    for _, win in ipairs(hl.get_windows()) do
        if win.address == address then
            return win
        end
    end
    return nil
end

local function hide_app(win)
    if not win then return end
    print("[app_toggle] hide_app: '" .. tostring(win.title) ..
          "' (address=" .. tostring(win.address) .. ")")
    hl.dispatch(hl.dsp.window.move({
        workspace = SPECIAL_WORKSPACE.hidden,
        window = win,
        follow = false,
    }))
    if currently_shown_address == win.address then
        currently_shown_address = nil
    end
end

local function show_app(app_win, current_ws)
    if not app_win or not current_ws or not current_ws.name then return end

    if currently_shown_address and currently_shown_address ~= app_win.address then
        local other_win = find_window_by_address(currently_shown_address)
        if other_win then
            hide_app(other_win)
        end
    end

    hl.dispatch(hl.dsp.window.move({
        workspace = current_ws.name,
        window = app_win,
    }))
    hl.dispatch(hl.dsp.window.center({
        window = app_win,
    }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top", window = app_win }))

    currently_shown_address = app_win.address
end

function M.show_or_hide_app(dsp, match)
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not current_ws or not current_ws.name then
        -- No active workspace — cannot show/hide, just spawn
        if dsp then hl.dispatch(dsp) end
        return
    end
    local app_win = find_matching_window(match)

    if not app_win then
        -- Not open yet: spawn it, and remember what we're waiting for so
        -- the window.open listener can pick it up once it actually opens.
        pending_spawn = { match = match, ws_name = current_ws.name }
        hl.dispatch(dsp)
        return
    end

    local app_ws = app_win.workspace
    if not app_ws or not app_ws.name then return end
    local app_ws_name = app_ws.name
    local app_is_in_current_workspace = app_ws_name == current_ws.name
    local app_is_in_hidden_workspace = app_ws_name == SPECIAL_WORKSPACE.hidden

    print("[app_toggle]   app_ws_name=" .. tostring(app_ws_name) ..
          " in_current=" .. tostring(app_is_in_current_workspace) ..
          " in_hidden=" .. tostring(app_is_in_hidden_workspace))

    if not app_is_in_current_workspace and not app_is_in_hidden_workspace then
        show_app(app_win, current_ws)
    elseif not app_is_in_hidden_workspace then
        -- Currently visible in the current workspace: toggle it off.
        hide_app(app_win)
    elseif app_is_in_hidden_workspace then
        show_app(app_win, current_ws)
    end
end

function M.toggle_focused_app()
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not current_ws or not current_ws.name then return end
    local minimized_ws = hl.get_workspace(SPECIAL_WORKSPACE.minimized)

    if minimized_ws and minimized_ws.windows and minimized_ws.windows > 0 then
        hl.dispatch(hl.dsp.window.move({ workspace = current_ws.name, window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        local active_win = hl.get_active_window()
        if not active_win then return end
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = active_win }))
        hl.dispatch(hl.dsp.window.move({ workspace = SPECIAL_WORKSPACE.minimized, follow = false }))
    end
end

hl.on("window.open", function(w)
    if not pending_spawn then
        return
    end
    if not w or not matches(w, pending_spawn.match) then
        return
    end

    local ws_name = pending_spawn.ws_name
    local ws = ws_name and hl.get_workspace(ws_name) or nil
    pending_spawn = nil

    if ws then
        show_app(w, ws)
    end
end)

return M
