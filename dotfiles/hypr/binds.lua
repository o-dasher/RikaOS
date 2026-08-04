local mod = "SUPER"

local function exec(cmd, slice)
	slice = slice or "a"
	return hl.dsp.exec_cmd("app2unit -s " .. slice .. " -- " .. cmd)
end

-- Window management
hl.bind(mod .. " + RETURN", exec("xdg-terminal-exec"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Scrolling layout & Stacking controls
hl.bind(mod .. " + S", hl.dsp.layout("consume_or_expel prev"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.layout("consume_or_expel next"))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + U", hl.dsp.layout("expel"))

-- Focus navigation (vim keys)
hl.bind(mod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mod .. " + K", hl.dsp.layout("focus u"))
hl.bind(mod .. " + J", hl.dsp.layout("focus d"))

-- Window movement & Column swaps
hl.bind(mod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Column sizing controls
hl.bind(mod .. " + R", hl.dsp.layout("colresize +conf"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.layout("colresize -conf"))

-- Screenshots
hl.bind(mod .. " + P", exec("grimblast --freeze --notify copy screen"))
hl.bind(mod .. " + SHIFT + P", exec("grimblast --freeze --notify copy area"))
hl.bind(mod .. " + ALT + P", exec("grimblast --freeze --notify copy active"))

-- Lock & Shutdown
hl.bind("CTRL + SHIFT + L", exec("hyprlock", "s"))
hl.bind("CTRL + SHIFT + Q", exec("hyprshutdown", "s"))

-- Media keys
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioStop", exec("playerctl stop"), { locked = true })

hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Volume
local audio_step = "1"
hl.bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ " .. audio_step .. "%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. audio_step .. "%-"),
	{ locked = true, repeating = true }
)

-- Mouse binds
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces 1-10
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
