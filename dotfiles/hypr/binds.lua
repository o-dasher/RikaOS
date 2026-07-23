local mod = "SUPER"

local function exec(cmd)
	return hl.dsp.exec_cmd("app2unit " .. cmd)
end

-- Window management
hl.bind(mod .. " + RETURN", exec("xdg-terminal-exec"))
hl.bind(mod .. " + F", hl.dsp.exec_raw("fullscreen", "0"))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exec_raw("fullscreen", "1"))

-- Groups
hl.bind(mod .. " + S", hl.dsp.group.toggle())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

-- Focus & Group navigation (vim keys)
hl.bind(mod .. " + H", function()
	hl.dispatch(hl.dsp.focus({ direction = "left" }))
	hl.dispatch(hl.dsp.group.prev())
end)
hl.bind(mod .. " + L", function()
	hl.dispatch(hl.dsp.focus({ direction = "right" }))
	hl.dispatch(hl.dsp.group.next())
end)
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Group window movement & Move into/out of group
hl.bind(mod .. " + SHIFT + H", function()
	hl.dispatch(hl.dsp.group.move_window("b"))
	hl.dispatch(hl.dsp.exec_raw("moveintogroup", "l"))
end)
hl.bind(mod .. " + SHIFT + L", function()
	hl.dispatch(hl.dsp.group.move_window("f"))
	hl.dispatch(hl.dsp.exec_raw("moveintogroup", "r"))
end)
hl.bind(mod .. " + SHIFT + K", hl.dsp.exec_raw("moveintogroup", "u"))
hl.bind(mod .. " + SHIFT + J", hl.dsp.exec_raw("moveintogroup", "d"))
hl.bind(mod .. " + SHIFT + U", hl.dsp.exec_raw("moveoutofgroup"))

-- Screenshots
hl.bind(mod .. " + P", exec("grimblast --freeze --notify copy screen"))
hl.bind(mod .. " + SHIFT + P", exec("grimblast --freeze --notify copy area"))
hl.bind(mod .. " + ALT + P", exec("grimblast --freeze --notify copy active"))

-- Lock
hl.bind("CTRL + SHIFT + L", exec("hyprlock"))

-- Media keys
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioStop", exec("playerctl stop"), { locked = true })

hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Volume (repeating)
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
