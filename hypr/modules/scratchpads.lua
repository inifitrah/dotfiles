local M = {}

local SPECIAL_WORKSPACE = {
    hidden = "special:hidden",
    minimized = "special:minimized"
}

-- Tracks the address of whichever managed app is currently shown via
-- M.show_or_hide_app, so that showing a *different* app automatically
-- hides it first. This is what enforces "only 1 app visible at a time".
local currently_shown_address = nil

-- When we spawn a brand-new app (it wasn't open yet), the window doesn't
-- exist until the spawned process actually opens it — which happens
-- *asynchronously*, after M.show_or_hide_app has already returned. We
-- record what we're waiting for here; the "window.open" listener below
-- picks it up once the window actually appears and applies the same
-- show_app() treatment (hide-others, center, raise, track) that an
-- already-existing window would have gotten immediately.
local pending_spawn = nil -- { match = {title?, class?}, ws_name = "..." }

local function matches(win, opts)
    return (opts.title and win.title == opts.title)
        or (opts.class and (win.class == opts.class or win.initialClass == opts.class))
end

local function find_matching_window(opts)
    for _, win in ipairs(hl.get_windows()) do
        if matches(win, opts) then
            return win
        end
    end
    return nil
end

-- Looks a window up by its stable .address field. Safer than building an
-- "address:0x..." selector string by hand, since we don't have to guess
-- whether .address already includes the "0x" prefix.
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
    print("[app_toggle] show_app: '" .. tostring(app_win.title) ..
          "' (address=" .. tostring(app_win.address) ..
          ") -> ws=" .. tostring(current_ws.name))

    if currently_shown_address and currently_shown_address ~= app_win.address then
        local other_win = find_window_by_address(currently_shown_address)
        print("[app_toggle]   another app currently shown: " ..
              tostring(other_win and other_win.title) ..
              " (address=" .. tostring(currently_shown_address) .. ")")
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
    print("[app_toggle]   currently_shown_address = " .. tostring(currently_shown_address))
end

function M.show_or_hide_app(dsp, match)
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    local app_win = find_matching_window(match)

    print("[app_toggle] show_or_hide_app: match=" .. tostring(match.title or match.class) ..
          " found=" .. tostring(app_win ~= nil) ..
          " current_ws=" .. tostring(current_ws.name))

    if not app_win then
        -- Not open yet: spawn it, and remember what we're waiting for so
        -- the window.open listener can pick it up once it actually opens.
        pending_spawn = { match = match, ws_name = current_ws.name }
        print("[app_toggle]   not found -> spawning, pending_spawn set for ws=" .. tostring(current_ws.name))
        hl.dispatch(dsp)
        return
    end

    local app_ws_name = app_win.workspace.name
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

function M.minimize_app()
    local current_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    local minimized_ws = hl.get_workspace(SPECIAL_WORKSPACE.minimized)

    if minimized_ws and minimized_ws.windows and minimized_ws.windows > 0 then
        hl.dispatch(hl.dsp.window.move({ workspace = current_ws.name, window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = SPECIAL_WORKSPACE.minimized, follow = false }))
    end
end

-- Catches windows that were just spawned via M.show_or_hide_app (because
-- they didn't exist yet at call time) and applies the same "show" handling
-- once they actually open: hide whatever else is currently shown, move
-- them into the workspace we originally intended, center + raise them,
-- and track their address for the single-visible-app enforcement.
--
-- Registered once at module load time (top-level, not inside a function).
hl.on("window.open", function(w)
    if not pending_spawn then
        return
    end

    print("[app_toggle] window.open: '" .. tostring(w.title) ..
          "' class=" .. tostring(w.class) ..
          " (checking against pending_spawn)")

    if not matches(w, pending_spawn.match) then
        print("[app_toggle]   does not match pending_spawn, ignoring")
        return
    end

    print("[app_toggle]   MATCHED pending_spawn -> applying show_app")

    local ws = hl.get_workspace(pending_spawn.ws_name)
    pending_spawn = nil

    if ws then
        show_app(w, ws)
    else
        print("[app_toggle]   target workspace no longer exists, skipping show_app")
    end
end)

return M
