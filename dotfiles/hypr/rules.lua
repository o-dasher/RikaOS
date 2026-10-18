-- Layer rules
hl.layer_rule({ match = { namespace = "^(noctalia-bar-.*)$" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({
	match = { namespace = "^(noctalia-panel|noctalia-notification|noctalia-osd)$" },
	blur = true,
	ignore_alpha = 0.2,
})
hl.layer_rule({ match = { namespace = "^(noctalia-bar-.*|noctalia-attached-panel)$" }, animation = "slide top" })
hl.layer_rule({ match = { namespace = "^(noctalia-panel)$" }, animation = "slide bottom" })
hl.layer_rule({ match = { namespace = "^(noctalia-notification|noctalia-osd)$" }, animation = "slide right" })
hl.layer_rule({ match = { namespace = "hyprshutdown" }, blur = true, animation = "fade" })
hl.layer_rule({
	match = {
		namespace = "^(selection|hyprpicker|noctalia-screenshot-region|noctalia-annotate|noctalia-wallpaper|noctalia-backdrop)$",
	},
	animation = "off",
})

-- !GAMES!
-- Game content detection
hl.window_rule({ match = { class = "^(steam_app_.*|gamescope|Minecraft.*|cs2|osu!)$" }, content = "game" })
hl.window_rule({ match = { xdg_tag = "^(proton-game)$" }, content = "game" })

-- Game modifiers
hl.window_rule({
	match = { content = "game" },
	sync_fullscreen = true,
	fullscreen = true,
	stay_focused = true,
	focus_on_activate = true,
	immediate = true,
	no_anim = true,
	no_blur = true,
	no_shadow = true,
})
-- !GAMES!

-- Float rules
hl.window_rule({
	match = { tag = "floaty" },
	float = true,
	center = true,
	size = "monitor_w*0.6 monitor_h*0.6",
})

-- Extension & App class matches
local bitwarden_class = "brave-nngceckbapebfimnlniiiahkandclblb-Default"
local floaty_classes = "^(nemo|com\\.github\\.wwmm\\.easyeffects|com\\.saivert\\.pwvucontrol|org\\.gnome\\.FileRoller|"
	.. bitwarden_class
	.. ")$"

hl.window_rule({
	tag = "+floaty",
	match = {
		class = floaty_classes,
	},
})

-- Music workspace
hl.window_rule({ match = { class = "^(sidra)$" }, workspace = "6 silent" })
