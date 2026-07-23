local game_modifiers = {
    sync_fullscreen = true,
    fullscreen = true,
    immediate = true,
    no_anim = true,
    no_blur = true,
    no_shadow = true,
}

local non_direct_scanout_games = "osu!"

---@param base table
---@param match table
---@return table
local function rule_with(base, match)
    local t = {}
    for k, v in pairs(base) do
        t[k] = v
    end
    t.match = match
    return t
end

-- Layer rules
hl.layer_rule({ match = { namespace = "^(waybar|notifications|walker)$" }, blur = true })
hl.layer_rule({ match = { namespace = "^(walker)$" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "^(waybar)$" }, animation = "slide top" })
hl.layer_rule({ match = { namespace = "^(notifications)$" }, animation = "slide right" })
hl.layer_rule({ match = { namespace = "^(walker)$" }, animation = "slide bottom" })
hl.layer_rule({ match = { namespace = "^(selection|hyprpicker)$" }, animation = "off" })

-- Game content detection
hl.window_rule({ match = { class = "^(steam_app_.*|gamescope|cs2)$" }, content = "game" })
hl.window_rule({
    match = { class = "^(" .. non_direct_scanout_games .. ")$" },
    content = "none", -- Tagged as non game so automatic direct scanout won't turn on for those.
})

-- Game modifiers
hl.window_rule(rule_with(game_modifiers, { content = "game" }))
hl.window_rule(rule_with(game_modifiers, { class = "^(" .. non_direct_scanout_games .. ")$" }))
hl.window_rule({ match = { class = "^(cs2)$" }, immediate = false })

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
    },
})

-- Music workspace
hl.window_rule({ match = { class = "^(spotify)$" }, workspace = "6 silent" })
