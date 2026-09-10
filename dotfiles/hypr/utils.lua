local M = {}

local function match_str(val, pat)
	if not val or not pat then
		return false
	end
	return val == pat or val:match(pat) ~= nil
end

local function matches(win, spec)
	if not win then
		return false
	end
	if win.floating and not (type(spec) == "table" and spec.floating) then
		return false
	end
	if type(spec) == "table" then
		local c = win.class or ""
		local ic = win.initial_class or ""
		local t = win.title or ""
		local it = win.initial_title or ""
		if spec.class and not (match_str(c, spec.class) or match_str(ic, spec.class)) then
			return false
		end
		if spec.title and not (match_str(t, spec.title) or match_str(it, spec.title)) then
			return false
		end
		if spec.exclude_title and (match_str(t, spec.exclude_title) or match_str(it, spec.exclude_title)) then
			return false
		end
		return true
	elseif type(spec) == "string" then
		local c = win.class or ""
		local ic = win.initial_class or ""
		return match_str(c, spec) or match_str(ic, spec)
	end
	return false
end

--- Reorganize two windows side by side on a target workspace.
--- @param opts { workspace: number|string, left: string|table, right: string|table, maximize?: boolean, focus_left?: boolean }
function M.organize_side_by_side(opts)
	local ws = opts.workspace
	local left_match = opts.left
	local right_match = opts.right
	local should_maximize = opts.maximize
	local should_focus_left = opts.focus_left ~= false
	local focused_first = false

	local function ensure_maximized(win)
		if should_maximize and win and win.fullscreen ~= 1 then
			hl.dispatch(hl.dsp.window.fullscreen({
				mode = "maximized",
				action = "set",
				window = "address:" .. win.address,
			}))
		end
	end

	local function un_maximize(win)
		if win and win.fullscreen ~= 0 then
			hl.dispatch(hl.dsp.window.fullscreen({
				mode = "maximized",
				action = "unset",
				window = "address:" .. win.address,
			}))
		end
	end

	local function focus_left()
		local wins = hl.get_workspace_windows(ws)
		for _, win in ipairs(wins) do
			if matches(win, left_match) then
				hl.dispatch(hl.dsp.focus({ window = "address:" .. win.address }))
				return true
			end
		end
		return false
	end

	local function is_current_workspace()
		local active_ws = hl.get_active_workspace()
		if not active_ws then
			return false
		end
		local target_id = tonumber(ws)
		return (active_ws.id == target_id) or (tostring(active_ws.name) == tostring(ws))
	end

	local function reorganize()
		local wins = hl.get_workspace_windows(ws)
		local left_win, right_win = nil, nil
		for _, win in ipairs(wins) do
			if matches(win, left_match) then
				left_win = win
			elseif matches(win, right_match) then
				right_win = win
			end
		end
		if left_win and right_win and right_win.at.x < left_win.at.x then
			-- Hyprland refuses to swap windows if either window is maximized ("Can't swap fullscreen window")
			un_maximize(left_win)
			un_maximize(right_win)
			hl.dispatch(hl.dsp.window.swap({
				window = "address:" .. right_win.address,
				with = "address:" .. left_win.address,
			}))
		end
		ensure_maximized(left_win)
		ensure_maximized(right_win)

		if is_current_workspace() and should_focus_left and not focused_first then
			if focus_left() then
				focused_first = true
			end
		end
	end

	local function on_event(w)
		if not w or matches(w, left_match) or matches(w, right_match) then
			reorganize()
			hl.timer(reorganize, { timeout = 50, type = "oneshot" })
			hl.timer(reorganize, { timeout = 300, type = "oneshot" })
		end
	end

	local function on_destroy()
		local wins = hl.get_workspace_windows(ws)
		local has_left = false
		for _, win in ipairs(wins) do
			if matches(win, left_match) then
				has_left = true
				break
			end
		end
		if not has_left then
			focused_first = false
		end
		reorganize()
	end

	hl.on("window.open", on_event)
	hl.on("window.close", on_destroy)
	hl.on("window.destroy", on_destroy)
	hl.on("window.title", on_event)
	hl.on("window.move_to_workspace", on_event)

	if should_focus_left then
		hl.on("workspace.active", function(active_ws)
			if not active_ws or focused_first then
				return
			end
			local target_id = tonumber(ws)
			local is_target = (active_ws.id == target_id) or (tostring(active_ws.name) == tostring(ws))
			if is_target then
				if focus_left() then
					focused_first = true
					hl.timer(focus_left, { timeout = 50, type = "oneshot" })
				end
			end
		end)
	end
end

hl.utils = M

return M
