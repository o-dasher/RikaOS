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

-- Shell (Noctalia)
hl.bind(mod .. " + D", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))

-- Screenshots
hl.bind(mod .. " + P", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind(mod .. " + ALT + P", hl.dsp.exec_cmd("noctalia msg screenshot-annotate"))

-- Lock & Session
hl.bind("CTRL + SHIFT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("CTRL + SHIFT + Q", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

-- Media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("noctalia msg media stop"), { locked = true })

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })

-- Volume
local audio_step = "1"
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("noctalia msg volume-up " .. audio_step),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("noctalia msg volume-down " .. audio_step),
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
