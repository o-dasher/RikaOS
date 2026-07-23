local gaps = 2
local border_size = 2
local rounding = 4
local indicator_height = 24

-- Logging
hl.env("AQ_TRACE", "0")
hl.env("HYPRLAND_TRACE", "0")

-- Hyprland environment
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.config({
	debug = {
		disable_logs = true,
	},

	cursor = {
		-- Fixes graphical glitches on gpu intensive works that switches between hardware and software cursors. (e.g. games).
		no_hardware_cursors = 1,
	},

	misc = {
		allow_session_lock_restore = true,
	},

	render = {
		-- For some reason it is still way too glitchy so off now.
		direct_scanout = 0,

		-- Keep output in SDR even if apps expose HDR content. My monitor's HDR is not that great.
		cm_auto_hdr = 0,
	},

	general = {
		allow_tearing = true,
		gaps_out = gaps,
		gaps_in = gaps,
		border_size = border_size,
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

	group = {
		groupbar = {
			rounding = rounding,
			indicator_height = indicator_height,
			height = 1,
			font_size = 12,

			-- Render text inside group bar indicator
			text_offset = -math.floor(indicator_height / 2),
		},
	},
})

hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "default", style = "slide" })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "default", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "default" })
