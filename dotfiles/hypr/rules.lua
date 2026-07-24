local function merge(t1, t2)
	local t = {}
	for k, v in pairs(t1) do
		t[k] = v
	end
	for k, v in pairs(t2) do
		t[k] = v
	end
	return t
end

-- Layer rules
hl.layer_rule({ match = { namespace = "^(waybar|notifications|walker)$" }, blur = true })
hl.layer_rule({ match = { namespace = "^(walker)$" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "^(waybar)$" }, animation = "slide top" })
hl.layer_rule({ match = { namespace = "^(notifications)$" }, animation = "slide right" })
hl.layer_rule({ match = { namespace = "^(walker)$" }, animation = "slide bottom" })
hl.layer_rule({ match = { namespace = "^(selection|hyprpicker)$" }, animation = "off" })

-- !GAMES!
local non_direct_scanout_games = "osu!"

-- Game content detection
hl.window_rule({ match = { class = "^(steam_app_.*|gamescope|Minecraft.*|cs2)$" }, content = "game" })
hl.window_rule({ match = { xdg_tag = "^(proton-game)$" }, content = "game" })
hl.window_rule({
	match = { class = "^(" .. non_direct_scanout_games .. ")$" },
	content = "none", -- Tagged as non game so automatic direct scanout won't turn on for those.
})

-- Game modifiers
local game_modifiers = {
	sync_fullscreen = true,
	fullscreen = true,
	immediate = true,
	no_anim = true,
	no_blur = true,
	no_shadow = true,
}

hl.window_rule(merge(game_modifiers, { match = { content = "game" } }))
hl.window_rule(merge(game_modifiers, { match = { class = "^(" .. non_direct_scanout_games .. ")$" } }))
-- !GAMES!

-- Float rules
hl.window_rule({
	match = { tag = "floaty" },
	float = true,
	center = true,
	size = "monitor_w*0.6 monitor_h*0.6",
})

hl.window_rule({
	tag = "+floaty",
	match = {
		class = "^(.blueman-manager-wrapped|nemo|com.github.wwmm.easyeffects|com.saivert.pwvucontrol|org.gnome.FileRoller)$",
		title = "^(Bitwarden)$",
	},
})

-- Music workspace
hl.window_rule({ match = { class = "^(spotify)$" }, workspace = "6 silent" })
