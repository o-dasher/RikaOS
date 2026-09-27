local gaps = 2
local border_size = 2
local rounding = 4

-- Logging
hl.env("AQ_TRACE", "0")
hl.env("HYPRLAND_TRACE", "0")

-- Primary GPU: dynamically detect and prioritize dedicated GPU over integrated GPU.
-- Note: AQ_DRM_DEVICES uses ':' as a delimiter, so paths containing ':' (like /dev/dri/by-path/)
-- cannot be passed directly. We resolve the PCI device to its /dev/dri/cardN node via sysfs.
local function get_pci_drm_card(pci_id)
	for i = 0, 7 do
		local path = "/sys/bus/pci/devices/" .. pci_id .. "/drm/card" .. i
		local f = io.open(path, "r")
		if f then
			f:close()
			return "/dev/dri/card" .. i
		end
	end
	return nil
end

local dgpu_card = get_pci_drm_card("0000:03:00.0")
local igpu_card = get_pci_drm_card("0000:11:00.0")

if dgpu_card and igpu_card then
	hl.env("AQ_DRM_DEVICES", dgpu_card .. ":" .. igpu_card)
elseif dgpu_card then
	hl.env("AQ_DRM_DEVICES", dgpu_card)
end

hl.config({
	debug = {
		disable_logs = true,
	},

	misc = {
		allow_session_lock_restore = true,
		anr_missed_pings = 20, -- cs2 pulls too many resources on launch, which causes anr, without it actually being anr.
	},

	render = {
		direct_scanout = 2,

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
