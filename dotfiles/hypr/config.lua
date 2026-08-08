local gaps = 2
local border_size = 2
local rounding = 4

-- Logging
hl.env("AQ_TRACE", "0")
hl.env("HYPRLAND_TRACE", "0")

hl.config({
	debug = {
		disable_logs = true,
	},

	misc = {
		allow_session_lock_restore = true,
		anr_missed_pings = 30, -- cs2 pulls too many resources on launch, which causes anr, without it actually being anr.
	},

	cursor = {
		no_hardware_cursors = 1,
	},

	render = {
		-- Just no...
		direct_scanout = 0,

		-- Keep output in SDR even if apps expose HDR content. My monitor's HDR is not that great.
		cm_auto_hdr = 0,
	},

	general = {
		allow_tearing = true,
		gaps_out = gaps,
		gaps_in = gaps,
		border_size = border_size,
		layout = "scrolling",
	},

	scrolling = {
		column_width = 0.5,
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		fullscreen_on_one_column = true,
		focus_fit_method = 1,
		follow_focus = true,
	},

	decoration = {
		rounding = rounding,
		blur = { passes = 2 },
	},

	input = {
		kb_layout = "br",
		kb_variant = "abnt2",
		accel_profile = "flat",
	},
})

hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "default", style = "slide" })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "default", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "default" })
