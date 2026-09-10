local M = {}

local function matches(win, pat)
	if not win or win.floating then
		return false
	end
	local c, ic, t = win.class or "", win.initial_class or "", win.title or ""
	if type(pat) == "table" then
		local class_match = (pat.class == nil) or c:match(pat.class) or ic:match(pat.class)
		local exclude_match = pat.exclude and (t:match(pat.exclude) or (win.initial_title or ""):match(pat.exclude))
		return class_match and not exclude_match
	end
	return c:match(pat) ~= nil or ic:match(pat) ~= nil
end

--- Reorganize two windows side by side on a target workspace.
--- @param opts { workspace: number|string, left: string|table, right: string|table, maximize?: boolean }
function M.organize_side_by_side(opts)
	local ws_id = tonumber(opts.workspace)
	local focused_first = false

	local function maximize(win, state)
		if win and (win.fullscreen == 1) ~= state then
			hl.dispatch(hl.dsp.window.fullscreen({
				mode = "maximized",
				action = state and "set" or "unset",
				window = "address:" .. win.address,
			}))
		end
	end

	local function focus(win)
		if win then
			hl.dispatch(hl.dsp.focus({ window = "address:" .. win.address }))
		end
	end

	local function get_windows()
		local left, right
		for _, w in ipairs(hl.get_workspace_windows(ws_id)) do
			if matches(w, opts.left) then
				left = w
			elseif matches(w, opts.right) then
				right = w
			end
		end
		return left, right
	end

	local function reorganize()
		local left, right = get_windows()
		if not left then
			focused_first = false
		end

		if left and right and right.at.x < left.at.x then
			maximize(left, false)
			maximize(right, false)
			hl.dispatch(hl.dsp.window.swap({
				window = "address:" .. right.address,
				with = "address:" .. left.address,
			}))
		end

		if opts.maximize then
			maximize(left, true)
			maximize(right, true)
		end

		local active = hl.get_active_workspace()
		if not focused_first and active and active.id == ws_id and left then
			focus(left)
			focused_first = true
		end
	end

	local function on_event(w)
		if not w or matches(w, opts.left) or matches(w, opts.right) then
			reorganize()
			hl.timer(reorganize, { timeout = 50, type = "oneshot" })
		end
	end

	for _, ev in ipairs({ "window.open", "window.close", "window.destroy", "window.title", "window.move_to_workspace" }) do
		hl.on(ev, on_event)
	end

	hl.on("workspace.active", function(active)
		if not focused_first and active and active.id == ws_id then
			local left = get_windows()
			if left then
				focus(left)
				focused_first = true
			end
		end
	end)
end

hl.utils = M

return M
